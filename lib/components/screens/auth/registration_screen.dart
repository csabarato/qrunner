import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qrunner/utils/progress_indicators.dart';

import '../../../constants/strings.dart';
import '../../../constants/styles.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/validators.dart';
import '../../buttons/rounded_button.dart';
import '../../text_logo.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;

  late String username;
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
                        decoration:
                            kTextFieldDecoration.copyWith(labelText: kUsername),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          username = value;
                        },
                        validator: (value) => validateTextField(value),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: kTextFieldDecoration.copyWith(
                            labelText: kEmailAddress),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) => validateEmail(value),
                      ),
                      const SizedBox(
                        height: 25.0,
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
                        validator: (value) => validatePassword(value),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: RoundedButton(
                          text: kRegistration,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await showLoadingIndicator(kRegistration);
                              try {
                                final userCredential = await
                                _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
                                final user = userCredential.user;
                                if (user == null) {
                                  throw Exception(kRegistrationErrorMsg);
                                } else {
                                  await user.sendEmailVerification();
                                  await user.updateDisplayName(username);
                                  EasyLoading.dismiss();
                                  handleRegistrationSuccess();
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                                handleRegistrationErrors(e);
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

  handleRegistrationSuccess() {
    showInfoDialog(context, kRegistrationSuccessTitle, kRegistrationSuccessMsg, () {
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }

  handleRegistrationErrors(e) {
    if (e is FirebaseAuthException) {
      showErrorDialog(
          context, e.message!);
      return;
    }
    showErrorDialog(context, e.toString(),);
  }
}
