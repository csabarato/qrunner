import 'package:flutter/material.dart';
import 'package:qrunner/components/buttons/rounded_button.dart';
import 'package:qrunner/components/screens/qr_code_reader_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/track_type.dart';
import 'package:qrunner/utils/dialog_utils.dart';

import '../../models/code_scan_data.dart';
import '../../services/result_service.dart';
import '../cards/read_code_result_card.dart';

class ReadCodesScreen extends StatefulWidget {
  const ReadCodesScreen({
    Key? key,
    required this.trackId,
    required this.trackName,
    required this.trackType,
    required this.numOfPoints,
    required this.codeList,
  }) : super(key: key);

  final String trackId;
  final String trackName;
  final TrackType trackType;
  final int numOfPoints;
  final List<String> codeList;

  @override
  State<ReadCodesScreen> createState() => ReadCodesScreenState();
}

class ReadCodesScreenState extends State<ReadCodesScreen> {
  Map<int, CodeScanData> resultBarcodeMap = {};

  @override
  void initState() {
    super.initState();
    ResultService.readScannedCodes(widget.trackId).then((value) {
      resultBarcodeMap = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trackName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: RoundedButton(
              text: kRead,
              color: Colors.green,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const QRCodeReaderScreen();
                })).then((value) => {
                      onCodeScanned(context, value, DateTime.now()),
                      setState(() {}),
                    });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (isCodeScanned(index)) {
                  return ReadCodeResultCard(
                    index: index,
                    isScanned: isCodeScanned(index),
                    codeScanData: resultBarcodeMap[index]!,
                    startDateTime: resultBarcodeMap[0]!.scanTimestamp,
                  );
                }
                return null;
              },
              shrinkWrap: true,
              itemCount: widget.numOfPoints,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RoundedButton(
                text: kDelete,
                color: Colors.redAccent,
                onTap: () {
                  ResultService.deleteCodeScanData().then(
                          (res) => {
                            if (res > 0) {
                              resultBarcodeMap.clear(),
                              setState(() {})
                            }
                          });
                }),
          )
        ],
      ),
    );
  }

  bool isCodeScanned(int index) {
    return resultBarcodeMap[index] != null;
  }

  bool isReadButtonEnabled(int index) {
    return resultBarcodeMap.length < widget.numOfPoints;
  }

  void onCodeScanned(
      BuildContext context, String code, DateTime scanTimestamp) {
    int indexOfCode = getNextIndexOfCode(code);
    if (widget.trackType == TrackType.fixedOrderCollecting) {
      validateCodeFixedOrderType(context, code, indexOfCode, scanTimestamp);
    } else {
      validateCodePointCollectingType(
          context, code, indexOfCode, scanTimestamp);
    }
  }

  int getNextIndexOfCode(String code) {
    return resultBarcodeMap.length;
  }

  void validateCodeFixedOrderType(
      BuildContext context, String value, int index, DateTime scanTimestamp) {
    if (widget.codeList[index] != value) {
      showErrorDialog(context, kErrorScannedCodeIsNotTheNext,
          title: kCodeReadError);
    } else {
      resultBarcodeMap[index] = CodeScanData(value, scanTimestamp);
      ResultService.saveCodeScanToLocalDb(
          widget.trackId, value, index, scanTimestamp);
    }
  }

  void validateCodePointCollectingType(
      BuildContext context, String value, int index, DateTime scanTimestamp) {
    if (!widget.codeList.contains(value)) {
      showErrorDialog(context, kErrorScannedCodeNotPresent,
          title: kCodeReadError);
      return;
    }

    if (resultBarcodeMap.values.any((codeScan) => codeScan.code == value)) {
      showErrorDialog(context, kErrorCodeAlreadyScanned, title: kCodeReadError);
      return;
    }

    resultBarcodeMap[index] = CodeScanData(value, scanTimestamp);
    ResultService.saveCodeScanToLocalDb(
        widget.trackId, value, index, scanTimestamp);
  }
}
