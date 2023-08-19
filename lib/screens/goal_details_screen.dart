// ignore_for_file: use_build_context_synchronously

import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/widgets/step_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import '../utils/utils.dart';

class GoalDetailsScreen extends StatefulWidget {
  final dynamic snap;
  const GoalDetailsScreen({super.key, required this.snap});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  final TextEditingController _goalNameController = TextEditingController();

  final TextEditingController _stepNameController = TextEditingController();

  final List stepsList = <String>[];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int completedCount = 0;
  int goalCount = 0;

  bool isCompleted = false;
  bool isImportant = false;

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
    widget.snap['goalName'] = _goalNameController.value.text;
    widget.snap['isImportant'] = isImportant;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final inputBorder = OutlineInputBorder(
        borderSide: const BorderSide(
            width: 2, color: Colors.black45, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10));
    _goalNameController.text = widget.snap['goalName'];
    isImportant = widget.snap['isImportant'];
    return StreamBuilder(
        stream: firestore
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('Goals')
            .doc(widget.snap['goalId'])
            .collection('Steps')
            .snapshots(),
        builder: (context, stepSnapshots) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                  child: Row(
                    children: [
                      StreamBuilder(
                        stream: controllerListener(_goalNameController),
                        builder: (context, snapshot) {
                          return StreamBuilder(
                            stream: importantListener(isImportant),
                            builder: (context, snapshot) {
                              if (_goalNameController.value.text ==
                                      widget.snap['goalName'] &&
                                  isImportant == widget.snap['isImportant']) {
                                return Container();
                              } else {
                                return InkWell(
                                  onTap: () async {
                                    String res = await FirestoreMethods()
                                        .updateGoal(
                                            widget.snap,
                                            _goalNameController.value.text,
                                            isImportant);
                                    if (res == "success") {
                                      updateSnap();
                                    }
                                  },
                                  child: Text(
                                    'save',
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
                      ),
                    ],
                  ),
                )
              ],
            ),
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
                //Goal Name
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Goal Name',
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
                                  constraints:
                                      const BoxConstraints(maxWidth: 250)),
                              controller: _goalNameController,
                            ),
                          ],
                        ),
                        StreamBuilder(
                            stream: importantListener(isImportant),
                            builder: (context, goalSnap) {
                              return Transform.scale(
                                scale: 1.5,
                                child: InkWell(
                                  child: Icon(
                                    Icons.star,
                                    color: isImportant == false
                                        ? Colors.black
                                        : Colors.yellow,
                                  ),
                                  onTap: () {
                                    isImportant = !isImportant;
                                  },
                                ),
                              );
                            }),
                      ],
                    ),

                    //Add Step, Total Step
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder(
                          stream: _firestore
                              .collection('Users')
                              .doc(_auth.currentUser!.uid)
                              .collection('Goals')
                              .doc(widget.snap['goalId'])
                              .collection('Steps')
                              .where('isCompleted', isEqualTo: true)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  completedSnapshots) {
                            if (completedSnapshots.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            completedCount =
                                completedSnapshots.data!.docs.length.toInt();
                            return StreamBuilder(
                              stream: _firestore
                                  .collection('Users')
                                  .doc(_auth.currentUser!.uid)
                                  .collection('Goals')
                                  .doc(widget.snap['goalId'])
                                  .collection('Steps')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      goalSnapshots) {
                                if (goalSnapshots.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                goalCount =
                                    goalSnapshots.data!.docs.length.toInt();
                                if (goalCount <= completedCount) {
                                  FirestoreMethods()
                                      .goalIsCompleted(widget.snap);
                                } else {
                                  FirestoreMethods()
                                      .goalNotCompleted(widget.snap);
                                }
                                return Text(
                                  'Steps Completed: $completedCount / $goalCount',
                                  style: GoogleFonts.workSans(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                );
                              },
                            );
                          },
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
                                                              topRight: Radius
                                                                  .circular(
                                                                      20)),
                                                      color: Colors.orange),
                                                ),
                                              ),
                                              Text(
                                                'Add a step',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                                      focusedBorder:
                                                          inputBorder,
                                                      enabledBorder:
                                                          inputBorder,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxWidth: 200)),
                                                  controller:
                                                      _stepNameController,
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
                                                                  color: Colors
                                                                      .red,
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
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize:
                                                                      14.0,
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
                                                    StreamBuilder(
                                                        stream: controllerListener(
                                                            _stepNameController),
                                                        builder: (context,
                                                            snapshot) {
                                                          return ElevatedButton(
                                                            style:
                                                                const ButtonStyle(
                                                                    fixedSize: MaterialStatePropertyAll(
                                                                        Size.fromWidth(
                                                                            100)),
                                                                    shape:
                                                                        MaterialStatePropertyAll(
                                                                      RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color:
                                                                                Colors.green,
                                                                            width: 3),
                                                                        borderRadius:
                                                                            BorderRadius.all(
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
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              String res = await FirestoreMethods()
                                                                  .addStepToGoal(
                                                                      widget
                                                                          .snap,
                                                                      _stepNameController
                                                                          .value
                                                                          .text,
                                                                      stepSnapshots
                                                                          .data!
                                                                          .docs
                                                                          .length);
                                                              if (res ==
                                                                  'success') {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                            },
                                                          );
                                                        }),
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
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    //Steps streambuilder
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: StreamBuilder(
                          stream: firestore
                              .collection('Users')
                              .doc(auth.currentUser!.uid)
                              .collection('Goals')
                              .doc(widget.snap['goalId'])
                              .collection('Steps')
                              .orderBy('index')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  'Please add a step',
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => StepTile(
                                snap: snapshot.data!.docs[index].data(),
                                index: index,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
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
                          title: "Delete Goal",
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
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              iconColor: Colors.black,
                            ),
                            IconsButton(
                              onPressed: () async {
                                String res = await FirestoreMethods()
                                    .deleteGoal(widget.snap['goalId']);
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
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
                    'Delete goal',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          );
        });
  }
}
