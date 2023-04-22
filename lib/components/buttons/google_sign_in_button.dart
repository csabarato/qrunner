import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrunner/constants/strings.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key, required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: Colors.black,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                image: AssetImage('images/google_logo.png'),
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 15.0),
              Text(
                kGoogleSignIn,
                //style: TextStyle(color: Colors.black, fontSize: 16.0),
                style:
                    GoogleFonts.lexendDeca(color: Colors.white, fontSize: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
