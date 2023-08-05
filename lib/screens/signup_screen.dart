// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:accomplishr_mobile_app/resources/auth_methods.dart';
import 'package:accomplishr_mobile_app/screens/email_verification_screen.dart';
import 'package:accomplishr_mobile_app/screens/login_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/utils/utils.dart';
import 'package:accomplishr_mobile_app/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      confirm: _confirmController.text,
    );
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
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Accomplishr',
                                style: GoogleFonts.workSans(
                                    color: greenColor,
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
                                'SIGN UP',
                                style: GoogleFonts.workSans(
                                    color: greenColor,
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
                                hintText: 'Username',
                                textEditingController: _usernameController,
                                textInputType: TextInputType.text,
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
                              InputField(
                                hintText: 'Confirm Password',
                                textEditingController: _confirmController,
                                textInputType: TextInputType.visiblePassword,
                                isPass: true,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              InkWell(
                                onTap: signUpUser,
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
                                          'SIGN UP',
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
                                      "Already have an account?",
                                      style: GoogleFonts.workSans(
                                        color: whiteColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        ),
                                        child: Text(
                                          "Log In",
                                          style: GoogleFonts.workSans(
                                            color: greenColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline,
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
        ),
      ),
    );
  }
}
