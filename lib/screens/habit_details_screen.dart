import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/utils/utils.dart';
import 'package:accomplishr_mobile_app/widgets/percent_input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitDetailsScreen extends StatelessWidget {
  final dynamic snap;
  HabitDetailsScreen({super.key, required this.snap});

  final TextEditingController _habitNameController = TextEditingController();

  final TextEditingController _habitDescriptionController =
      TextEditingController();

  final TextEditingController _countController = TextEditingController();

  final TextEditingController _goalController = TextEditingController();

  Stream<String> controllerListener(TextEditingController controller) async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield controller.value.text;
    }
  }

  void updateSnap() {
    snap['habitName'] = _habitNameController.value.text;
    snap['habitDescription'] = _habitDescriptionController.value.text;
    snap['count'] = _countController.value;
    snap['goal'] = _countController.value;
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: const BorderSide(
            width: 2, color: Colors.black45, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10));
    _habitNameController.text = snap['habitName'];
    _habitDescriptionController.text = snap['habitDescription'];
    _countController.text = snap['count'].toString();
    _goalController.text = snap['goal'].toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    bool isCompleted =
                        int.tryParse(_countController.value.text)! >=
                            int.tryParse(_goalController.value.text)!;

                    if (_habitNameController.value.text != snap['habitName'] ||
                        _habitDescriptionController.value.text !=
                            snap['habitDescription'] ||
                        _goalController.value.text != snap['goal'].toString() ||
                        _countController.value.text !=
                            snap['count'].toString()) {
                      FirestoreMethods().updateHabit(
                          _habitNameController.value.text,
                          snap['habitId'],
                          _habitDescriptionController.value.text,
                          int.tryParse(_countController.value.text)!,
                          int.tryParse(_goalController.value.text)!,
                          isCompleted);
                      updateSnap();
                    } else {
                      showSnackBar('Please Update The Habit', context);
                    }
                    FirestoreMethods().habitsCompleted();
                  },
                  child: Text(
                    'save',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: grayColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Habit Name',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      TextField(
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                            focusedBorder: inputBorder,
                            enabledBorder: inputBorder,
                            contentPadding: const EdgeInsets.all(5),
                            constraints: const BoxConstraints(maxWidth: 250)),
                        controller: _habitNameController,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              StreamBuilder(
                stream: controllerListener(_countController),
                builder: (context, snapshot) {
                  return StreamBuilder(
                    stream: controllerListener(_goalController),
                    builder: (context, snapshot) {
                      return Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: whiteColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularPercentIndicator(
                            animation: true,
                            animationDuration: 600,
                            animateFromLastPercent: true,
                            radius: 140,
                            lineWidth: 30,
                            percent: _countController.text == ''
                                ? 0
                                : _goalController.text == ''
                                    ? 0
                                    : int.tryParse(_countController.text)! /
                                                int.tryParse(
                                                    (_goalController.text))! >
                                            1
                                        ? 1
                                        : int.parse(_countController.text) /
                                            int.parse((_goalController.text)),
                            progressColor:
                                const Color.fromARGB(255, 87, 209, 91),
                            backgroundColor:
                                const Color.fromARGB(255, 191, 191, 191),
                            center: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PercentInputField(
                                    textEditingController: _countController,
                                    textAlign: TextAlign.right),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '/',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                PercentInputField(
                                  textEditingController: _goalController,
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Row(
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      if (_countController.text != '0') {
                        _countController.text =
                            (int.tryParse(_countController.text)! - 1)
                                .toString();
                      }
                    },
                    fillColor: Colors.black,
                    padding: const EdgeInsets.all(8.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.exposure_minus_1_outlined,
                      size: 25.0,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      _countController.text =
                          (int.tryParse(_countController.text)! + 1).toString();
                    },
                    fillColor: Colors.black,
                    padding: const EdgeInsets.all(8.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.plus_one,
                      size: 25.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Colors.black,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Dialogs.bottomMaterialDialog(
                    msgStyle: GoogleFonts.workSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                    titleStyle: GoogleFonts.workSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18),
                    msg: 'Are you sure? You can\'t undo this',
                    title: "Delete Habit",
                    color: Colors.white,
                    context: context,
                    actions: [
                      IconsOutlineButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'Cancel',
                        iconData: Icons.cancel_outlined,
                        color: grayColor,
                        textStyle: GoogleFonts.poppins(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        iconColor: Colors.black,
                      ),
                      IconsButton(
                        onPressed: () async {
                          String res = await FirestoreMethods()
                              .deleteHabit(snap['habitId']);
                          if (res != "success") {
                            showSnackBar(res, context);
                          } else {
                            FirestoreMethods().habitsCompleted();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        },
                        text: 'Delete',
                        iconData: Icons.delete,
                        color: Colors.red,
                        textStyle: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w600),
                        iconColor: Colors.white,
                      ),
                    ]);
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Colors.transparent,
                ),
              ),
              child: const Icon(Icons.delete, semanticLabel: 'Delete'),
            ),
            Text(
              'Delete Habit',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
