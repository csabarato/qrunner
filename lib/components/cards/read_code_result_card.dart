import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/code_scan_data.dart';
import 'package:qrunner/utils/date_format_utils.dart';

class ReadCodeResultCard extends StatelessWidget {
  const ReadCodeResultCard(
      {Key? key,
      required this.index,
      required this.isScanned,
      required this.codeScanData,
      required this.startDateTime})
      : super(key: key);

  final int index;
  final bool isScanned;
  final CodeScanData codeScanData;
  final DateTime startDateTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isScanned ? Colors.green : Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isScanned ? Colors.green : Colors.blueGrey,
            width: 3.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${index + 1}. $kPoint   -   $kScanned',
              style: const TextStyle(color: Colors.white),
            ),
            const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            Text(
              codeScanData.scanTimestamp.difference(startDateTime).toString().split('.').first,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
