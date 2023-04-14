import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ReadCodeScreen extends StatefulWidget {
  const ReadCodeScreen({Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ReadCodeScreenState();
}

class ReadCodeScreenState extends State<ReadCodeScreen> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'qrKey');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan code'),),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            print(barcode.rawValue);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
