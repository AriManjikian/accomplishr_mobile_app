import 'dart:ui';

import 'package:accomplishr_mobile_app/screens/add_habit_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
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
  int completedCount = 0;
  int habitCount = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<String> docsfunction() async {
    final today = DateTime.now();
    final sevendaysago = today.subtract(const Duration(days: 7));
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Dates')
        .where('dateAdded', isGreaterThanOrEqualTo: sevendaysago)
        .get();
    return 'ari';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50,
        backgroundColor: Colors.black,
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60)),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Habits',
                            style: GoogleFonts.workSans(
                                color: whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'Become disciplined',
                            style: GoogleFonts.workSans(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Container(
                        width: 80,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/checkmark.png'),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Container(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
        ),
      ),
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
                  stream: FirebaseFirestore.instance
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
                      stream: FirebaseFirestore.instance
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
                    backgroundColor: MaterialStatePropertyAll(greenColor),
                  ),
                  child: Text(
                    'New Habit',
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(_auth.currentUser!.uid)
                      .collection('Habits')
                      .orderBy('dateAdded', descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    //TODO add empty Habits widget
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
