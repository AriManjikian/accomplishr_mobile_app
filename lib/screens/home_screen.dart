import 'package:accomplishr_mobile_app/screens/settings_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/widgets/bar_graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/goal_tile.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';
  int maxCount = 0;

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List getBottomList() {
    List bottomList = [];
    switch (DateTime.now().format('EEEE')) {
      case "Monday":
        bottomList = ["Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Mon"];
        break;
      case "Tuesday":
        bottomList = ["Wed", "Thu", "Fri", "Sat", "Sun", "Mon", "Tue"];
        break;
      case "Wednesday":
        bottomList = ["Thu", "Fri", "Sat", "Sun", "Mon", "Tue", "Wed"];
        break;
      case "Thursday":
        bottomList = ["Fri", "Sat", "Sun", "Mon", "Tue", "Wed", "Thu"];
        break;
      case "Friday":
        bottomList = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
        break;
      case "Saturday":
        bottomList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        break;
      case "Sunday":
        bottomList = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        break;
      default:
        ["_", "_", "_", "_", "_", "_", "_"];
    }
    return bottomList;
  }

  List weekValuesListener(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List valuesList = [];
    try {
      int j = 0;
      for (var i = 6; i >= 0; i--) {
        String subtractedDate =
            DateTime.now().subtract(Duration(days: i)).format('yMMMd');
        if (snapshot.data?.docs[j]['dateAdded'].toString() == subtractedDate) {
          valuesList.add(snapshot.data?.docs[j]['count']);
          if (maxCount < snapshot.data?.docs[j]['count']) {
            maxCount = snapshot.data?.docs[j]['count'];
          }

          j++;
        } else {
          valuesList.add(0);
        }
      }
      return valuesList;
    } catch (e) {
      return [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ];
    }
  }

  void getUsername() async {
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .get();

    setState(() {
      username = (docSnap.data() as Map<String, dynamic>)['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50,
        backgroundColor: Colors.black,
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(70),
              bottomRight: Radius.circular(70)),
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.black87),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello, $username',
                      style: GoogleFonts.workSans(
                        color: whiteColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: const Icon(Icons.settings),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const SettingsScreen();
                            },
                          ));
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Don't forget your goals!",
                  style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
            bottomLeft: Radius.circular(70),
            bottomRight: Radius.circular(70),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(_auth.currentUser!.uid)
                    .collection('Dates')
                    .where('date',
                        isGreaterThanOrEqualTo: DateTime.now().subtract(
                            Duration(
                                days: 7,
                                hours: DateTime.now().getHours,
                                minutes: DateTime.now().getMinutes,
                                seconds: DateTime.now().getSeconds,
                                milliseconds: DateTime.now().getMilliseconds,
                                microseconds: DateTime.now().getMicroseconds)))
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  List graphList = weekValuesListener(snapshot);
                  List bottomList = getBottomList();
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        child: BarGraphWidget(
                          bottomList: bottomList,
                          maxHabitCount: maxCount,
                          dataList: graphList,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('Users')
                        .doc(_auth.currentUser!.uid)
                        .collection('Habits')
                        .where('isImportant', isEqualTo: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Text(
                            'Important Habits',
                            style: GoogleFonts.workSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return HabitTile(
                                  snap: snapshot.data!.docs[index].data(),
                                );
                              }),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('Users')
                        .doc(_auth.currentUser!.uid)
                        .collection('Goals')
                        .where('isImportant', isEqualTo: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Text(
                            'Important Goals',
                            style: GoogleFonts.workSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return GoalTile(
                                  snap: snapshot.data!.docs[index].data(),
                                );
                              }),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
