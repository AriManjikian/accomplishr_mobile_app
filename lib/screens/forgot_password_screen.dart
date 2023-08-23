// ignore_for_file: use_build_context_synchronously

import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final inputBorder = const UnderlineInputBorder(
    borderSide:
        BorderSide(width: 2, color: whiteColor, style: BorderStyle.solid),
  );
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 200.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Enter Your Email',
                                    style: GoogleFonts.poppins(
                                        color: whiteColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: whiteColor,
                                    style: const TextStyle(
                                        color: whiteColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                        focusedBorder: inputBorder,
                                        enabledBorder: inputBorder,
                                        contentPadding: const EdgeInsets.all(5),
                                        isDense: true,
                                        constraints: const BoxConstraints(
                                            maxWidth: 250)),
                                    controller: _emailController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(greenColor)),
                              onPressed: () async {
                                String res = "Some error occured";
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: _emailController.value.text);
                                  res == 'success';
                                  showSnackBar(
                                      'We have sent you an email at ${_emailController.value.text}',
                                      context);
                                  Navigator.of(context).pop();
                                } catch (err) {
                                  res = err.toString();
                                  showSnackBar(err.toString(), context);
                                }
                              },
                              child: Text(
                                'Send Email',
                                style: GoogleFonts.workSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
