import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qrunner/components/screens/tracks_screen.dart';
import 'package:qrunner/components/text_logo.dart';
import 'package:qrunner/utils/dialog_utils.dart';

import '../../constants/strings.dart';
import '../buttons/google_sign_in_button.dart';
import '../buttons/rounded_button.dart';
import 'auth/login_screen.dart';
import 'auth/registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const id = 'home_screen';
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
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
              GoogleSignInButton(onPressed: () {
                signInWithGoogle();
              }),
            ],
          ),
        ),
      ),
    );
  }

  signInWithGoogle() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        throw Exception(kGoogleSignInFailedMsg);
      }

      GoogleSignInAuthentication auth = await account.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);

      if(firebaseAuth.currentUser == null){
        throw Exception(kGoogleSignInFailedMsg);
      }
      navigateToTracksScreen();
    } catch(e) {
      showErrorDialog(context, e.toString(), title: kGoogleSignInFailedMsg);
    }
  }

  navigateToTracksScreen() {
    Navigator.pushReplacementNamed(context, TracksScreen.id);
  }
}
