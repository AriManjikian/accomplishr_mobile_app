import 'dart:ui';

import 'package:accomplishr_mobile_app/screens/login_screen.dart';
import 'package:accomplishr_mobile_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg-1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
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
                ),
                const SizedBox(
                  height: 50,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(color: Colors.white60),
                          borderRadius: const BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          '"A dream becomes a goal when action is taken toward its achievement." - Bo Bennet',
                          style: GoogleFonts.workSans(
                              color: whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                const Shadow(
                                  color: Colors.black54,
                                  blurRadius: 55,
                                  offset: Offset(5, 10),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                            width: 3,
                            color: whiteColor,
                          ))),
                          child: Text(
                            'LOG IN',
                            style: GoogleFonts.workSans(
                              color: whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                            width: 3,
                            color: whiteColor,
                          ))),
                          child: Text(
                            'SIGN UP',
                            style: GoogleFonts.workSans(
                              color: whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
