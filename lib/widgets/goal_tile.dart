import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/goal_details_screen.dart';
import '../utils/colors.dart';

class GoalTile extends StatelessWidget {
  final dynamic snap;

  GoalTile({super.key, required this.snap});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(snap['goalId'])
            .collection('Steps')
            .snapshots(),
        builder: (context, stepSnapshot) {
          return StreamBuilder(
              stream: _firestore
                  .collection('Users')
                  .doc(_auth.currentUser!.uid)
                  .collection('Goals')
                  .doc(snap['goalId'])
                  .collection('Steps')
                  .where('isCompleted', isEqualTo: true)
                  .snapshots(),
              builder: (context, completedSnapshot) {
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        color: snap["isCompleted"] == true
                            ? greenColor
                            : Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${snap["goalName"]}',
                                  style: GoogleFonts.poppins(
                                    color: snap['isCompleted'] == true
                                        ? Colors.black
                                        : offWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Steps:  ${completedSnapshot.data?.docs.length}/${stepSnapshot.data?.docs.length}',
                                  style: GoogleFonts.poppins(
                                    color: snap['isCompleted'] == true
                                        ? Colors.black
                                        : offWhiteColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return GoalDetailsScreen(
                          snap: snap,
                        );
                      },
                    ));
                  },
                );
              });
        });
  }
}
