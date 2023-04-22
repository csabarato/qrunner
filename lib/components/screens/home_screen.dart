import 'package:flutter/material.dart';
import 'package:qrunner/components/text_logo.dart';

import '../buttons/google_sign_in_button.dart';
import '../buttons/rounded_button.dart';
import '../constants/strings.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: TextLogo()),
              RoundedButton(
                text: kLogin,
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              RoundedButton(
                text: kRegistration,
                onTap: () {
                  //Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
              GoogleSignInButton(onPressed: () {
                //signInWithGoogle();
              }),
            ],
          ),
        ),
      ),
    );

  }
}
