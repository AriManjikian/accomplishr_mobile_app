// ignore_for_file: use_build_context_synchronously

import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/utils/utils.dart';
import 'package:accomplishr_mobile_app/widgets/step_create_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _stepNameController = TextEditingController();

  final List stepsList = <String>[];

  @override
  void dispose() {
    super.dispose();
    _goalNameController.dispose();
    _stepNameController.dispose();
  }

  Stream<List> listListener(List list) async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield list;
    }
  }

  Future<String> uploadgoal() async {
    String res = "some error occured";
    try {
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: const BorderSide(
            width: 2, color: Colors.black45, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10));
    return StreamBuilder(
      stream: listListener(stepsList),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          body: Center(
            child: Column(
              children: [
                Text(
                  'Goal name:',
                  style: GoogleFonts.workSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
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
                      constraints: const BoxConstraints(maxWidth: 300)),
                  controller: _goalNameController,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total steps: ${stepsList.length}',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _stepNameController.clear();
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Container(
                                        height: 300.0,
                                        width: 250.0,
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Container(
                                                height: 60.0,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                    color: Colors.orange),
                                              ),
                                            ),
                                            Text(
                                              'Add a step',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: TextField(
                                                cursorColor: Colors.black,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                decoration: InputDecoration(
                                                    focusedBorder: inputBorder,
                                                    enabledBorder: inputBorder,
                                                    contentPadding:
                                                        const EdgeInsets.all(5),
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 200)),
                                                controller: _stepNameController,
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30.0,
                                                      vertical: 25),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    style: const ButtonStyle(
                                                        fixedSize:
                                                            MaterialStatePropertyAll(
                                                                Size.fromWidth(
                                                                    100)),
                                                        shape:
                                                            MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    Colors.red,
                                                                width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                        ),
                                                        elevation:
                                                            MaterialStatePropertyAll(
                                                                0),
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                whiteColor)),
                                                    child: Center(
                                                      child: Text(
                                                        'Cancel',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    style: const ButtonStyle(
                                                        fixedSize:
                                                            MaterialStatePropertyAll(
                                                                Size.fromWidth(
                                                                    100)),
                                                        shape:
                                                            MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .green,
                                                                width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                        ),
                                                        elevation:
                                                            MaterialStatePropertyAll(
                                                                0),
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                whiteColor)),
                                                    child: Center(
                                                      child: Text(
                                                        'Save',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      stepsList.add(
                                                          _stepNameController
                                                              .value.text);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )));
                              });
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orange),
                        ),
                        child: Text(
                          'Add Step',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: stepsList.length,
                      itemBuilder: (context, index) {
                        return StepCreateTile(
                            name: stepsList[index], index: index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            height: 80,
            color: Colors.black,
            child: Center(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 26.0, vertical: 16),
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.orange),
                    minimumSize: MaterialStatePropertyAll(
                        Size.fromWidth(double.infinity))),
                child: Text(
                  'Save Goal',
                  style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  String res = await FirestoreMethods()
                      .uploadGoal(stepsList, _goalNameController.value.text);
                  if (res == 'success') {
                    Navigator.of(context).pop();
                  } else {
                    showSnackBar(res, context);
                  }
                },
              ),
            )),
          ),
        );
      },
    );
  }
}
