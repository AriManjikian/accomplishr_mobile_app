import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadHabit(
    String habitName,
    String habitDescription,
    int count,
    int goal,
    bool isCompleted,
  ) async {
    String res = "Some error occurred";
    try {
      String habitId = const Uuid().v1();
      DateTime dateTime = DateTime.now();

      Habit habit = Habit(
        habitId: habitId,
        habitName: habitName,
        habitDescription: habitDescription,
        count: count,
        goal: goal,
        isCompleted: isCompleted,
        dateAdded: dateTime,
      );

      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Habits')
          .doc(habitId)
          .set(
            habit.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> updateHabit(
    String habitName,
    String habitId,
    String habitDescription,
    int count,
    int goal,
    bool isCompleted,
  ) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Habits')
          .doc(habitId)
          .update({
        "habitName": habitName,
        "habitDescription": habitDescription,
        "count": count,
        "goal": goal,
        "isCompleted": isCompleted,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  void checkDate() async {
    QuerySnapshot date = await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Dates')
        .orderBy('date')
        .limitToLast(1)
        .get();
    if (date.docs.isNotEmpty) {
      if (date.docs[0]['dateAdded'] != DateTime.now().format('yMMMd')) {
        print(date.docs[0]['dateAdded']);
        print(DateTime.now().format('yMMMd'));
        _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Dates')
            .doc(DateTime.now().format('yMMMd'))
            .set({
          "dateAdded": DateTime.now().format('yMMMd'),
          "count": 0,
          "date": DateTime.now()
        });
        QuerySnapshot habits = await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Habits')
            .get();
        for (var i = 0; i < habits.docs.length; i++) {
          final String habitId = habits.docs[i].get('habitId');
          _firestore
              .collection("Users")
              .doc(_auth.currentUser!.uid)
              .collection('Habits')
              .doc(habitId)
              .update({
            "count": 0,
            "isCompleted": false,
          });
        }
      }
    } else {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Dates')
          .doc(DateTime.now().format('yMMMd'))
          .set({
        "dateAdded": DateTime.now().format('yMMMd'),
        "count": 0,
        "date": DateTime.now()
      });
    }
  }

  Future<String> addOneToCount(String habitId, int habitCount) async {
    habitCount = habitCount + 1;
    String res = "Some error occurred";
    try {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Habits')
          .doc(habitId)
          .update({'count': habitCount});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> habitsCompleted() async {
    String res = "Some error occurred";
    try {
      QuerySnapshot completedHabits = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Habits')
          .where('isCompleted', isEqualTo: true)
          .get();

      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Dates')
          .doc(DateTime.now().format('yMMMd'))
          .update({'count': completedHabits.docs.length});

      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> deleteHabit(String habitId) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Habits')
          .doc(habitId)
          .delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
