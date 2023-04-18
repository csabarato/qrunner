import 'package:flutter/material.dart';
import 'package:qrunner/components/constants/strings.dart';

class ReadCodeCard extends StatelessWidget {
  const ReadCodeCard(
      {Key? key,
      required this.index,
      this.readResult = "",
      required this.onTap,
      required this.isScanned})
      : super(key: key);

  final int index;
  final String readResult;
  final VoidCallback onTap;
  final bool isScanned;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: isScanned
          ? const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.green,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)))
          : null,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${index + 1}. $kPoint'),
            Text(readResult),
            ElevatedButton(
              onPressed: isScanned ? null : onTap,
              style: ElevatedButton.styleFrom(
                  backgroundColor: isScanned ? Colors.green : Colors.blueGrey,
                  disabledBackgroundColor: Colors.green,
                  disabledForegroundColor: Colors.white,
                  minimumSize: const Size(100.0, 40)),
              child: isScanned ? const Text(kDone) : const Text(kRead),
            )
          ],
        ),
      ),
    );
  }
}
