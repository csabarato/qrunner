import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../constants/strings.dart';

class ReadCodeScreen extends StatefulWidget {
  const ReadCodeScreen(
      {Key? key, required this.index, required this.barcodeMap})
      : super(key: key);

  final int index;
  final Map<int, Barcode> barcodeMap;

  @override
  State<StatefulWidget> createState() => ReadCodeScreenState();
}

class ReadCodeScreenState extends State<ReadCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'qrKey');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.index + 1}. $kReadPoint'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            widget.barcodeMap[widget.index] = barcode;
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
