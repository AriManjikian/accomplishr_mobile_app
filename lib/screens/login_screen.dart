// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:accomplishr_mobile_app/resources/auth_methods.dart';
import 'package:accomplishr_mobile_app/screens/signup_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/utils/utils.dart';
import 'package:accomplishr_mobile_app/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'email_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pop(
        MaterialPageRoute(
          builder: (context) => const VerifyEmailPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg-2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white60),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Accomplishr',
                            style: GoogleFonts.workSans(
                                color: whiteColor,
                                fontSize: 45,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  const Shadow(
                                    color: Colors.black54,
                                    blurRadius: 55,
                                    offset: Offset(5, 10),
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            'LOG IN',
                            style: GoogleFonts.workSans(
                                color: whiteColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  const Shadow(
                                    color: Colors.black54,
                                    blurRadius: 55,
                                    offset: Offset(5, 10),
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          InputField(
                            hintText: 'Email',
                            textEditingController: _emailController,
                            textInputType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          InputField(
                            hintText: 'Password',
                            textEditingController: _passwordController,
                            textInputType: TextInputType.visiblePassword,
                            isPass: true,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: loginUser,
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                width: 3,
                                color: whiteColor,
                              ))),
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Text(
                                      'LOG IN',
                                      style: GoogleFonts.workSans(
                                        color: whiteColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.workSans(
                                    color: whiteColor,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupScreen(),
                                      ),
                                    ),
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.workSans(
                                        color: greenColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
