import 'package:flutter/material.dart';
import 'package:qrunner/constants/strings.dart';

showErrorDialog(BuildContext context, String message) {
  showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      title: const Text(kError, style: TextStyle(color: Colors.blueAccent),),
      content: Text(message),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text('OK'))
      ],
    );
  });
}

showInfoDialog(BuildContext context,String title, String message, VoidCallback onAccept) async {
  await showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: Colors.blue),),
      content: Text(message),
      actions: [
        TextButton(onPressed: onAccept, child: const Text('OK'))
      ],
    );
  });
}