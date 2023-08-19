import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class StepTile extends StatefulWidget {
  final dynamic snap;
  final int index;
  const StepTile({
    super.key,
    required this.snap,
    required this.index,
  });

  @override
  State<StepTile> createState() => _StepTileState();
}

class _StepTileState extends State<StepTile> {
  final TextEditingController _stepEditController = TextEditingController();

  Stream<bool?> checkListener(bool? isCompleted) async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield isCompleted;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: const BorderSide(
            width: 2, color: Colors.black45, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            backgroundColor: const Color.fromARGB(255, 71, 71, 71),
            icon: Icons.edit,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            onPressed: (onPressedContext) async {
              _stepEditController.text = widget.snap['stepName'];
              return showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                            height: 300.0,
                            width: 250.0,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    height: 60.0,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        color: Colors.orange),
                                  ),
                                ),
                                Text(
                                  'Edit step',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                        focusedBorder: inputBorder,
                                        enabledBorder: inputBorder,
                                        contentPadding: const EdgeInsets.all(5),
                                        constraints: const BoxConstraints(
                                            maxWidth: 200)),
                                    controller: _stepEditController,
                                  ),
                                ),
                                Expanded(child: Container()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: const ButtonStyle(
                                            fixedSize: MaterialStatePropertyAll(
                                                Size.fromWidth(100)),
                                            shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.red,
                                                    width: 3),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                            elevation:
                                                MaterialStatePropertyAll(0),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    whiteColor)),
                                        child: Center(
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        style: const ButtonStyle(
                                            fixedSize: MaterialStatePropertyAll(
                                                Size.fromWidth(100)),
                                            shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.green,
                                                    width: 3),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                            elevation:
                                                MaterialStatePropertyAll(0),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    whiteColor)),
                                        child: Center(
                                          child: Text(
                                            'Save',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        ),
                                        onPressed: () async {
                                          //TODO add check for step name, do same thing for goal and habit, and username
                                          if (_stepEditController.value.text !=
                                              widget.snap['stepName']) {
                                            String res =
                                                await FirestoreMethods()
                                                    .editStepName(
                                                        widget.snap,
                                                        _stepEditController
                                                            .value.text);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )));
                  });
            },
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            onPressed: (dialogContext) {
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
                          color: Colors.black, fontWeight: FontWeight.w600),
                      iconColor: Colors.black,
                    ),
                    IconsButton(
                      onPressed: () async {
                        String res =
                            await FirestoreMethods().deleteStep(widget.snap);
                        if (res == "Deleted Goal") {
                          Navigator.of(context).popUntil((route) {
                            return route.isFirst;
                          });
                        } else if (res == "Deleted Step") {
                          Navigator.of(context).pop();
                        } else {
                          showSnackBar(res, context);
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
          )
        ]),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: widget.snap['isCompleted'] == true
                ? const Color.fromARGB(255, 248, 182, 96)
                : grayColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Step ${widget.index + 1}:',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              '${widget.snap["stepName"]}',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: checkListener(widget.snap['isCompleted']),
                        builder: (context, snapshot) {
                          return Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              activeColor:
                                  const Color.fromARGB(255, 55, 145, 58),
                              value: widget.snap['isCompleted'],
                              onChanged: (newBool) {
                                widget.snap['isCompleted'] = newBool;
                                FirestoreMethods()
                                    .changeStepCompleted(widget.snap, newBool);
                              },
                            ),
                          );
                        }),
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
