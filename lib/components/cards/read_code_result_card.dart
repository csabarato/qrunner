import 'package:flutter/material.dart';
import 'package:qrunner/constants/strings.dart';

class ReadCodeResultCard extends StatelessWidget {
  const ReadCodeResultCard(
      {Key? key, required this.index, required this.isScanned})
      : super(key: key);

  final int index;
  final bool isScanned;

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
            isScanned
                ? Text(
                    '${index + 1}. $kPoint   -   $kScanned',
                    style: const TextStyle(color: Colors.white),
                  )
                : Text('${index + 1}. $kPoint   -   $kReadTheCode!'),
            isScanned
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  )
                : const Icon(Icons.qr_code),
          ],
        ),
      ),
    );
  }
}
