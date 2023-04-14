import 'dart:developer';

import 'package:authdemo/router/app.route.dart';
import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appRouter = AppRouter();
  runApp(MaterialApp.router(
    routerConfig: appRouter.config(),
  ));
}

// Login Screen
@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Login or sign up\nwith\nphone number",
            textAlign: TextAlign.center,
          ),
          FormWidget(
            onSaved: (value) {
              log(value);
            },
          ),
        ],
      ),
    );
  }
}

// Form Widget

class FormWidget extends StatefulWidget {
  const FormWidget({
    super.key,
    required this.onSaved,
  });

  final ValueChanged<String> onSaved;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  TextEditingController number = TextEditingController();
  TextEditingController otp = TextEditingController();

  final _formkeyNumber = GlobalKey<FormState>();
  final _formkeyOtp = GlobalKey<FormState>();
  bool isOtpSent = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: !isOtpSent
          ? Form(
              key: _formkeyNumber,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Mobile Number"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'required';
                      }
                      return null;
                    },
                    controller: number,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formkeyNumber.currentState!.validate()) {
                              widget.onSaved(number.text);

                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: "+91${number.text}",
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  log("otp is sent");
                                  isOtpSent = true;
                                  setState(() {});
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            }
                          },
                          child: const Text("Send")))
                ],
              ),
            )
          : Form(
              key: _formkeyOtp,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Otp sent to ${number.text}"),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Enter OTP"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'required';
                      }
                      return null;
                    },
                    controller: otp,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formkeyOtp.currentState!.validate()) {
                              widget.onSaved(otp.text);
                              setState(() {});
                            }
                          },
                          child: const Text("Verify otp")))
                ],
              ),
            ),
    );
  }
}

// Home Screen

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Home")),
    );
  }
}
