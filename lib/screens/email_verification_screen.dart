import 'dart:async';
import 'dart:ui';
import 'package:accomplishr_mobile_app/screens/responsive_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:accomplishr_mobile_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  VerifyEmailPageState createState() => VerifyEmailPageState();
}

class VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
    }

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const ResponsiveScreen()
      : Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg-1.jpg'),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Email Verification',
                                style: GoogleFonts.workSans(
                                    color: whiteColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    shadows: [
                                      const Shadow(
                                        color: Colors.black54,
                                        blurRadius: 55,
                                        offset: Offset(5, 10),
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(45.0),
                                child: Text(
                                  'We have sent an email verification link to \n ${FirebaseAuth.instance.currentUser!.email}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: whiteColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const CircularProgressIndicator(
                                color: greenColor,
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
