import 'package:cloud_firestore/cloud_firestore.dart';
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
}
