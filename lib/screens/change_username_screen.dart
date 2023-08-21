import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeUsernameScreen extends StatefulWidget {
  const ChangeUsernameScreen({super.key});

  @override
  State<ChangeUsernameScreen> createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final inputBorder = const UnderlineInputBorder(
    borderSide:
        BorderSide(width: 2, color: whiteColor, style: BorderStyle.solid),
  );
  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  Stream<String> controllerListener(TextEditingController controller) async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield controller.value.text;
    }
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
                                    'Enter New Username',
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
                                            maxWidth: 250)),
                                    controller: _usernameController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: StreamBuilder(
                              stream: controllerListener(_usernameController),
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                greenColor)),
                                    onPressed: () {
                                      FirestoreMethods().changeUsername(
                                          _usernameController.value.text,
                                          context);
                                    },
                                    child: Text(
                                      'Change Username',
                                      style: GoogleFonts.workSans(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ));
                              }),
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
