import 'package:flutter/material.dart';
import 'package:qrunner/components/screens/read_code_screen.dart';
import 'package:qrunner/models/track_type.dart';
import 'package:qrunner/utils/dialog_utils.dart';

import '../cards/read_code_card.dart';

class ReadCodesListScreen extends StatefulWidget {
  const ReadCodesListScreen({Key? key,required this.trackType, required this.numOfPoints, required this.codeList}) : super(key: key);

  final TrackType trackType;
  final int numOfPoints;
  final List<String> codeList;

  @override
  State<ReadCodesListScreen> createState() => ReadCodesListScreenState();
}

class ReadCodesListScreenState extends State<ReadCodesListScreen> {
  Map<int, String> resultBarcodeMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pontok beolvasása'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                itemCount: widget.numOfPoints,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ReadCodeCard(
                    index: index,
                    isScanned: isCodeScanned(index),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ReadCodeScreen(
                          index: index,
                        );
                      })).then((value) => {
                          checkCodeValidity(index, value),
                         setState(() {}),
                      });
                    },
                  );
                })
          ],
        ),
      ),
    );
  }

  bool isCodeScanned(int index) {
    return resultBarcodeMap[index] != null;
  }

  void checkCodeValidity(int index, String value) {
    if (widget.trackType == TrackType.fixedOrderCollecting) {
     validateCodeFixedOrderType(index, value);
    } // TODO : validate point collecting
  }

  void validateCodeFixedOrderType(int index, String value) {
    int nextPointIndex = resultBarcodeMap.length;

    if (nextPointIndex != index) {
      showErrorDialog(context, 'Ez nem a következő pont.',
          title: 'Hibás kódolvasás!');
    } else if (widget.codeList[index] != value) {
      showErrorDialog(context, 'A beolvasott kód nem ehhez a ponthoz tartozik.',
          title: 'Hibás kódolvasás!');
    } else {
      resultBarcodeMap[index] = value;
    }
  }
}
