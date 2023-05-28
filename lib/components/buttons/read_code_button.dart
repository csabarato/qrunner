import 'package:flutter/material.dart';

import '../../constants/strings.dart';

class ReadCodeButton extends StatelessWidget {
  const ReadCodeButton({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          disabledBackgroundColor: Colors.green,
          disabledForegroundColor: Colors.white,
          minimumSize: const Size(200.0, 50.0)),
      child: const Text(kRead),
    );
  }
}
