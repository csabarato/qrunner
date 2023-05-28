import 'package:flutter/material.dart';
import 'package:qrunner/components/buttons/read_code_button.dart';
import 'package:qrunner/components/screens/qr_code_reader_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/track_type.dart';
import 'package:qrunner/utils/dialog_utils.dart';

import '../cards/read_code_result_card.dart';

class ReadCodesScreen extends StatefulWidget {
  const ReadCodesScreen(
      {Key? key,
      required this.trackType,
      required this.numOfPoints,
      required this.codeList})
      : super(key: key);

  final TrackType trackType;
  final int numOfPoints;
  final List<String> codeList;

  @override
  State<ReadCodesScreen> createState() => ReadCodesScreenState();
}

class ReadCodesScreenState extends State<ReadCodesScreen> {
  Map<int, String> resultBarcodeMap = {};

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
            padding: const EdgeInsets.all(20.0),
            child: ReadCodeButton(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const QRCodeReaderScreen();
                })).then((value) => {
                      onCodeScanned(value),
                      setState(() {}),
                    });
              },
            ),
          ),
          const SizedBox(
            height: 20.0,
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
              itemCount: widget.numOfPoints,
            ),
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

  void onCodeScanned(String value) {
    if (widget.trackType == TrackType.fixedOrderCollecting) {
      validateCodeFixedOrderType(value);
    } else {
      validateCodePointCollectingType(value);
    }
  }

  void validateCodeFixedOrderType(String value) {
    int nextPointIndex = resultBarcodeMap.length;

    if (widget.codeList[nextPointIndex] != value) {
      showErrorDialog(
          context, 'A beolvasott kód nem a következő ponthoz tartozik!',
          title: 'Hibás kódolvasás!');
    } else {
      resultBarcodeMap[nextPointIndex] = value;
    }
  }

  void validateCodePointCollectingType(String value) {
    if (!widget.codeList.contains(value)) {
      showErrorDialog(context,
          'Keress tovább, ez a pont nem szerepel a pálya pontjai között!',
          title: 'Hibás kódolvasás!');
      return;
    }
    int indexOfCode = widget.codeList.indexOf(value);
    if (resultBarcodeMap[indexOfCode] != null) {
        showErrorDialog(context,
            'Ezt a pontot már beolvastad!',
            title: 'Hibás kódolvasás!');
        return;
    }
    resultBarcodeMap[indexOfCode] = value;
    }
}
