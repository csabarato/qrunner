import 'package:flutter/material.dart';

class ReadCodeCard extends StatelessWidget {
  const ReadCodeCard({Key? key, required this.index, this.readResult = "",
  required this.onTap}) : super(key: key);

  final int index;
  final String readResult;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${index +1} . pont"),
            Text(readResult),
            ElevatedButton(onPressed: onTap, child: const Text('Beolvas'))
          ],
        ),
      ),
    );
  }
}
