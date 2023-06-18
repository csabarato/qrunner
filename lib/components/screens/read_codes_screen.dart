import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrunner/components/buttons/rounded_button.dart';
import 'package:qrunner/components/screens/qr_code_reader_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/result_model.dart';
import 'package:qrunner/models/track_type.dart';
import 'package:qrunner/services/result_service.dart';
import 'package:qrunner/utils/dialog_utils.dart';

import '../../models/code_scan_data.dart';
import '../cards/read_code_result_card.dart';

class ReadCodesScreen extends StatefulWidget {
  const ReadCodesScreen(
      {Key? key,
      required this.trackId,
      required this.trackType,
      required this.numOfPoints,
      required this.codeList})
      : super(key: key);

  final String trackId;
  final TrackType trackType;
  final int numOfPoints;
  final List<String> codeList;

  @override
  State<ReadCodesScreen> createState() => ReadCodesScreenState();
}

class ReadCodesScreenState extends State<ReadCodesScreen> {
  Map<int, CodeScanData> resultBarcodeMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kReadCodesTitle),
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
                      onCodeScanned(value, DateTime.now()),
                      setState(() {}),
                    });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ReadCodeResultCard(
                  index: index,
                  isScanned: isCodeScanned(index),
                );
              },
              shrinkWrap: true,
              itemCount: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RoundedButton(
                text: kSubmit,
                onTap: () async {
                  final resultModel = ResultModel(
                      FirebaseAuth.instance.currentUser!.uid,
                      widget.trackId,
                      resultBarcodeMap);
                  saveResults(resultModel);
                }),
          )
        ],
      ),
    );
  }

  saveResults(ResultModel resultModel) async {
    try {
      await ResultService.saveResult(resultModel);
      handleResultSavingSuccess();
    } catch (e) {
      showInfoDialog(context, kError, e.toString(), () {
        Navigator.pop(context);
      });
    }
  }

  bool isCodeScanned(int index) {
    return resultBarcodeMap[index] != null;
  }

  bool isReadButtonEnabled(int index) {
    return resultBarcodeMap.length < widget.numOfPoints;
  }

  void onCodeScanned(String value, DateTime scanTimestamp) {
    if (widget.trackType == TrackType.fixedOrderCollecting) {
      validateCodeFixedOrderType(value, scanTimestamp);
    } else {
      validateCodePointCollectingType(value, scanTimestamp);
    }
  }

  void validateCodeFixedOrderType(String value, DateTime scanTimestamp) {
    int nextPointIndex = resultBarcodeMap.length;

    if (widget.codeList[nextPointIndex] != value) {
      showErrorDialog(context, kErrorScannedCodeIsNotTheNext,
          title: kCodeReadError);
    } else {
      resultBarcodeMap[nextPointIndex] = CodeScanData(value, scanTimestamp);
    }
  }

  void validateCodePointCollectingType(String value, DateTime scanTimestamp) {
    if (!widget.codeList.contains(value)) {
      showErrorDialog(context, kErrorScannedCodeNotPresent,
          title: kCodeReadError);
      return;
    }
    int indexOfCode = widget.codeList.indexOf(value);
    if (resultBarcodeMap[indexOfCode] != null) {
      showErrorDialog(context, kErrorCodeAlreadyScanned, title: kCodeReadError);
      return;
    }
    resultBarcodeMap[indexOfCode] = CodeScanData(value, scanTimestamp);
  }

  void handleResultSavingSuccess() {
    showInfoDialog(context, kSaveResultsSuccessTitle , kSaveResultsSuccessTitle, () {
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }
}
