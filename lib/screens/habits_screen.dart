import 'package:accomplishr_mobile_app/screens/add_habit_screen.dart';
import 'package:accomplishr_mobile_app/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import '../widgets/habit_tile.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int completedCount = 0;
  int habitCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Your Habits', 'Become Disciplined',
          const AssetImage('assets/checkmark.png')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder(
                  stream: _firestore
                      .collection('Users')
                      .doc(_auth.currentUser!.uid)
                      .collection('Habits')
                      .where('isCompleted', isEqualTo: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    completedCount = snapshot.data!.docs.length.toInt();
                    return StreamBuilder(
                      stream: _firestore
                          .collection('Users')
                          .doc(_auth.currentUser!.uid)
                          .collection('Habits')
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
                        habitCount = snapshot.data!.docs.length.toInt();
                        return Text(
                          'Completed: $completedCount / $habitCount',
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
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const AddHabitScreen();
                      },
                    ));
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  child: Text(
                    'New Habit',
                    style: GoogleFonts.poppins(
                        color: whiteColor, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: StreamBuilder(
                  stream: _firestore
                      .collection('Users')
                      .doc(_auth.currentUser!.uid)
                      .collection('Habits')
                      .orderBy('dateAdded')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Looks A bit empty here',
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => HabitTile(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
