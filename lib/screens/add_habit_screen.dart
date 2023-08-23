// ignore_for_file: use_build_context_synchronously

import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/screens/habits_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _habitGoalController = TextEditingController();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final inputBorder = const UnderlineInputBorder(
    borderSide:
        BorderSide(width: 2, color: whiteColor, style: BorderStyle.solid),
  );
  @override
  void dispose() {
    super.dispose();
    _habitGoalController.dispose();
    _habitNameController.dispose();
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
                                    'Habit Name',
                                    style: GoogleFonts.poppins(
                                        color: whiteColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextField(
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
                                            maxWidth: 130)),
                                    controller: _habitNameController,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Habit Goal',
                                    style: GoogleFonts.poppins(
                                        color: whiteColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
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
                                            maxWidth: 130)),
                                    controller: _habitGoalController,
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
                                String res =
                                    await _firestoreMethods.uploadHabit(
                                        _habitNameController.text,
                                        0,
                                        int.parse(_habitGoalController.text),
                                        false,
                                        context);
                                if (res == 'success') {
                                  Navigator.of(context).pop(MaterialPageRoute(
                                    builder: (context) {
                                      return const HabitsScreen();
                                    },
                                  ));
                                }
                              },
                              child: Text(
                                'Add Habit',
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
