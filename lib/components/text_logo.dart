import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextLogo extends StatelessWidget {
  const TextLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    Text('QRUNNER', style: GoogleFonts.lexendDeca(
      color: Colors.black,
      fontSize: 35.0,
      letterSpacing: 6.0
    ));
  }
}
