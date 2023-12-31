// ignore_for_file: use_build_context_synchronously

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

// ignore: must_be_immutable
class HabitDetailsScreen extends StatelessWidget {
  final dynamic snap;
  HabitDetailsScreen({super.key, required this.snap});

  final TextEditingController _habitNameController = TextEditingController();

  final TextEditingController _countController = TextEditingController();

  final TextEditingController _goalController = TextEditingController();

  bool isImportant = false;
  bool isCompleted = false;

  Stream<String> controllerListener(TextEditingController controller) async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield controller.value.text;
    }
  }

  Stream<bool?> importantListener(bool? isImportant) async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield isImportant;
    }
  }

  void updateSnap() {
    snap['habitName'] = _habitNameController.value.text.toString();
    snap['count'] = int.tryParse(_countController.value.text);
    snap['goal'] = int.tryParse(_goalController.value.text);
    snap['isCompleted'] = isCompleted;
    snap['isImportant'] = isImportant;
  }

  @override
  Widget build(BuildContext context) {
    isImportant = snap['isImportant'];
    const inputBorder = UnderlineInputBorder(
      borderSide:
          BorderSide(width: 2, color: Colors.black, style: BorderStyle.solid),
    );
    _habitNameController.text = snap['habitName'];
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
                StreamBuilder(
                  stream: controllerListener(_countController),
                  builder: (context, snapshot) {
                    return StreamBuilder(
                      stream: controllerListener(_goalController),
                      builder: (context, snapshot) {
                        return StreamBuilder(
                          stream: controllerListener(_habitNameController),
                          builder: (context, snapshot) {
                            return StreamBuilder(
                              stream: importantListener(isImportant),
                              builder: (context, snapshot) {
                                if (_countController.value.text ==
                                        snap['count'].toString() &&
                                    _goalController.value.text ==
                                        snap['goal'].toString() &&
                                    _habitNameController.value.text ==
                                        snap['habitName'] &&
                                    isImportant == snap['isImportant']) {
                                  return Container();
                                } else {
                                  return InkWell(
                                    onTap: () async {
                                      int count = 0;
                                      int goal = 0;
                                      try {
                                        count = int.parse(
                                            _countController.value.text);
                                        goal = int.parse(
                                            _goalController.value.text);
                                        if (count >= goal) {
                                          isCompleted = true;
                                        } else {
                                          isCompleted = false;
                                        }
                                        String res = await FirestoreMethods()
                                            .updateHabit(
                                                _habitNameController.value.text,
                                                snap['habitId'],
                                                count,
                                                goal,
                                                isCompleted,
                                                isImportant);
                                        if (res == "success") {
                                          updateSnap();
                                        } else {
                                          showSnackBar(res, context);
                                        }
                                      } catch (e) {
                                        showSnackBar(
                                            'Something Went Wrong, Try Changing Your Input',
                                            context);
                                      }
                                    },
                                    child: Text(
                                      'Save',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: grayColor),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: StreamBuilder(
                stream: importantListener(isImportant),
                builder: (context, goalSnap) {
                  return Transform.scale(
                    scale: 1.5,
                    child: InkWell(
                      child: Icon(
                        Icons.star,
                        color: isImportant == false
                            ? offWhiteColor
                            : const Color.fromARGB(255, 238, 255, 1),
                      ),
                      onTap: () {
                        isImportant = !isImportant;
                      },
                    ),
                  );
                }),
          ),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextField(
                          cursorColor: Colors.black,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              focusedBorder: inputBorder,
                              enabledBorder: inputBorder,
                              contentPadding: EdgeInsets.all(5),
                              isDense: true,
                              constraints: BoxConstraints(maxWidth: 250)),
                          controller: _habitNameController,
                        ),
                      ),
                    ],
                  ),
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
                      return SizedBox(
                        width: double.infinity,
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
                                    : BigInt.parse(_countController.text) /
                                                BigInt.parse(
                                                    (_goalController.text)) >
                                            1
                                        ? 1
                                        : BigInt.parse(_countController.text) /
                                            BigInt.parse(
                                                (_goalController.text)),
                            progressColor:
                                const Color.fromARGB(255, 87, 209, 91),
                            backgroundColor:
                                const Color.fromARGB(255, 0, 20, 37),
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
                                        color: Colors.black,
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
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: RawMaterialButton(
                        onPressed: () {
                          if (_countController.text != '0') {
                            _countController.text =
                                (int.tryParse(_countController.text)! - 1)
                                    .toString();
                          }
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        fillColor: Colors.black,
                        child: Text(
                          '-',
                          style: GoogleFonts.workSans(
                              color: whiteColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w800),
                        )),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: RawMaterialButton(
                        onPressed: () {
                          _countController.text =
                              (int.tryParse(_countController.text)! + 1)
                                  .toString();
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        fillColor: Colors.black,
                        child: Text(
                          '+',
                          style: GoogleFonts.workSans(
                              color: whiteColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w800),
                        )),
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
                        textStyle: GoogleFonts.poppins(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        iconColor: Colors.black,
                      ),
                      IconsButton(
                        onPressed: () async {
                          String res = await FirestoreMethods()
                              .deleteHabit(snap['habitId'], snap['dateAdded']);
                          if (res != "success") {
                            showSnackBar(res, context);
                          } else {
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
                padding: MaterialStatePropertyAll(EdgeInsets.only(top: 10)),
                iconSize: MaterialStatePropertyAll(35),
                backgroundColor: MaterialStatePropertyAll(
                  Colors.transparent,
                ),
              ),
              child: const Icon(Icons.delete, semanticLabel: 'Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
