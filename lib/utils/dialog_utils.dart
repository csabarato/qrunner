import 'package:flutter/material.dart';
import 'package:qrunner/constants/strings.dart';

showErrorDialog(BuildContext context, String message, {String title= kError}) {
  showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: Colors.blueAccent),),
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

showConfirmDialog(BuildContext context,String title, String message, VoidCallback onAccept) async {
  await showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: Colors.blue),),
      content: Text(message),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text(kCancel)),
        TextButton(onPressed: onAccept, child: const Text('OK'))
      ],
    );
  });
}