import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrunner/components/screens/read_code_screen.dart';

import '../cards/read_code_card.dart';

class ReadCodesListScreen extends StatefulWidget {
  const ReadCodesListScreen({Key? key}) : super(key: key);

  @override
  State<ReadCodesListScreen> createState() => _ReadCodesListScreenState();
}

class _ReadCodesListScreenState extends State<ReadCodesListScreen> {
  Map<int, Barcode> resultBarcodeMap = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              itemCount: 10,
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
                        barcodeMap: resultBarcodeMap,
                      );
                    })).then((_) => setState(() {}));
                  },
                );
              })
        ],
      ),
    );
  }

  bool isCodeScanned(int index) {
    return resultBarcodeMap[index] != null;
  }
}
