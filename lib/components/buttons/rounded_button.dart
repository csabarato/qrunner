import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.color = Colors.blueGrey,
      this.minWidth = 240.0})
      : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color color;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: color,
      minimumSize: const Size(240.0, 45.0),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: style,
        child: Text(text, style: GoogleFonts.lexendDeca(fontSize: 15.0),),
      ),
    );
  }
}
