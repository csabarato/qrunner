import 'package:flutter/material.dart';
import 'package:qrunner/components/text_logo.dart';
import 'package:qrunner/constants/strings.dart';

import '../../../constants/styles.dart';
import '../../../utils/validators.dart';
import '../../buttons/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
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
                      height: 48.0,
                    ),
                    TextFormField(
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
                        text: kLogin,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              // TODO: Refactor and finish login process
                              /*await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                              if (_auth.currentUser == null) {
                                throw Exception(kLoginErrorMsg);
                              } else if (!_auth.currentUser!.emailVerified) {
                                throw FirebaseAuthException(
                                    message: kEmailNotVerifiedMsg,
                                    code: kEmailNotVerifiedCode);
                              } else {
                                UserService.saveUser(_auth.currentUser!.email!,
                                    _auth.currentUser!.displayName!);

                                if (!mounted) return;
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    MenuScreen.id,
                                        (Route<dynamic> route) => false);*/
                              //}
                            } catch (e) {
                              //handleLoginErrors(e);
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
    );
  }
}
