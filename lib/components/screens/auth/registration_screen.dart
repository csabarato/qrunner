import 'package:flutter/material.dart';

import '../../../constants/strings.dart';
import '../../../constants/styles.dart';
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
                            if (_formKey.currentState!.validate()) {}
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
}
