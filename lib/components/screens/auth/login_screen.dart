import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrunner/components/screens/tracks_screen.dart';
import 'package:qrunner/components/text_logo.dart';
import 'package:qrunner/constants/strings.dart';

import '../../../constants/styles.dart';
import '../../../utils/dialog_utils.dart';
import '../../buttons/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextLogo(),
                const SizedBox(height: 25.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: kTextFieldDecoration.copyWith(
                            labelText: kEmailAddress),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(
                        height: 48.0,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            kTextFieldDecoration.copyWith(labelText: kPassword),
                        textAlign: TextAlign.center,
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: RoundedButton(
                          text: kLogin,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await _firebaseAuth.signInWithEmailAndPassword(
                                    email: email, password: password);
                                if (_firebaseAuth.currentUser == null) {
                                  throw Exception(kLoginErrorMsg);
                                } else if (!_firebaseAuth.currentUser!.emailVerified) {
                                  throw FirebaseAuthException(
                                      message: kEmailNotVerifiedMsg,
                                      code: kEmailNotVerifiedMsg);
                                } else {
                                  navigateToTracksScreen();
                                }
                              } catch (e) {
                                handleLoginErrors(e);
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleLoginErrors(e) {
    if (e is FirebaseAuthException) {
      switch(e.code) {
        case kWrongPasswordCode:
          showErrorDialog(context, kWrongPassword, title: kLoginErrorMsg);
          break;
        case kUserNotExistsCode:
          showErrorDialog(context, kUserNotExists, title: kLoginErrorMsg);
          break;
        default: showErrorDialog(context, e.message!);
      }
      return;
    }
    showErrorDialog(context, e.toString(),);
  }

  navigateToTracksScreen() {
    Navigator.pushNamedAndRemoveUntil(
        context, TracksScreen.id,
            (route) => false);
  }
}
