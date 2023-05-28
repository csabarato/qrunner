import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants/strings.dart';

class QRCodeReaderScreen extends StatefulWidget {
  const QRCodeReaderScreen(
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => QRCodeReaderScreenState();
}

class QRCodeReaderScreenState extends State<QRCodeReaderScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'qrKey');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kReadPoint),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          Navigator.pop(context, barcodes[0].rawValue);
        },
      ),
    );
  }
}
