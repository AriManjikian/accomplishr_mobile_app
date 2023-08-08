import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/widgets/bar_graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String username = '';
  int maxCount = 0;

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  List weekValuesListener(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    try {
      List valuesList = [];

      int j = 0;
      for (var i = 6; i >= 0; i--) {
        String subtractedDate =
            DateTime.now().subtract(Duration(days: i)).format('yMMMd');
        if (snapshot.data?.docs[j]['dateAdded'].toString() == subtractedDate) {
          valuesList.add(snapshot.data?.docs[j]['count']);
          maxCount = snapshot.data?.docs[j]['count'];

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
                Text(
                  'Hello, $username',
                  style: GoogleFonts.workSans(
                    color: whiteColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
          children: [
            // valuesList.length <= 0
            //     ? BarGraphWidget(maxHabitCount: 10, dataList: [
            //         0,
            //         0,
            //         0,
            //         0,
            //         0,
            //         0,
            //         0,
            //       ])
            //     : BarGraphWidget(maxHabitCount: 10, dataList: valuesList)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Dates')
                  .where('date',
                      isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(
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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: BarGraphWidget(
                          maxHabitCount: maxCount, dataList: graphList),
                    ),
                  ],
                );
              },
            )
          ],
        )),
      ),
    );
  }
}
