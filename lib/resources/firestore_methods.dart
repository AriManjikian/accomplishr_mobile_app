// ignore_for_file: use_build_context_synchronously

import 'package:accomplishr_mobile_app/models/goal.dart';
import 'package:accomplishr_mobile_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//checks the date, if user hasnt logged in on that day, it creates new doc in database
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
  }

//uploads a new habit to the database
  Future<String> uploadHabit(String habitName, int count, int goal,
      bool isCompleted, BuildContext context) async {
    String res = "Some error occurred";
    try {
      String habitId = const Uuid().v1();
      DateTime dateTime = DateTime.now();

      Habit habit = Habit(
          habitId: habitId,
          habitName: habitName,
          count: count,
          goal: goal,
          isCompleted: isCompleted,
          dateAdded: dateTime,
          isImportant: false);
      if (habitName != '') {
        _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Habits')
            .doc(habitId)
            .set(
              habit.toJson(),
            );
        res = 'success';
      } else {
        res == 'Please provide valid information';
        showSnackBar(res, context);
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//updates an existing habit in the database
  Future<String> updateHabit(
    String habitName,
    String habitId,
    int count,
    int goal,
    bool isCompleted,
    bool isImportant,
  ) async {
    String res = "Some error occurred";
    try {
      if (habitName != '') {
        _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Habits')
            .doc(habitId)
            .update({
          "habitName": habitName,
          "count": count,
          "goal": goal,
          "isCompleted": isCompleted,
          "isImportant": isImportant,
        });

        if (isCompleted == true) {
          String todaysDate = DateTime.now().format('yMMMd');
          _firestore
              .collection("Users")
              .doc(_auth.currentUser!.uid)
              .collection('Dates')
              .doc(todaysDate)
              .update({
            habitId: true,
          });
        } else {
          String todaysDate = DateTime.now().format('yMMMd');
          _firestore
              .collection("Users")
              .doc(_auth.currentUser!.uid)
              .collection('Dates')
              .doc(todaysDate)
              .update({
            habitId: false,
          });
        }
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }

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

    return res;
  }

//deletes a habit from the database

  Future<String> deleteHabit(String habitId, Timestamp dateAdded) async {
    String res = "Some error occurred";
    try {
      QuerySnapshot dateSnaps = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Dates')
          .where('date',
              isGreaterThanOrEqualTo:
                  dateAdded.toDate().subtract(const Duration(days: 1)))
          .get();
      if (dateSnaps.docs.isNotEmpty) {
        for (var i = 0; i < dateSnaps.docs.length; i++) {
          try {
            bool habitIdExists = dateSnaps.docs[i].get(habitId);
            if (habitIdExists == true) {
              _firestore
                  .collection('Users')
                  .doc(_auth.currentUser!.uid)
                  .collection('Dates')
                  .doc(dateSnaps.docs[i].id)
                  .update({
                "count": dateSnaps.docs[i]["count"] - 1,
                habitId: false,
              });
            }
          } catch (e) {
            //
          }
        }
      }

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

//uploads a goal to the database
  Future<String> uploadGoal(List stepsList, String goalName) async {
    if (stepsList.isEmpty) {
      return "Please add steps";
    }
    String res = "Some error occured";
    try {
      String goalId = const Uuid().v1();
      DateTime dateTime = DateTime.now();

      Goal goal = Goal(
          goalId: goalId,
          goalName: goalName,
          isCompleted: false,
          dateAdded: dateTime,
          isImportant: false);
      if (goalName != '') {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(goalId)
            .set(goal.toJson());
        for (var i = 0; i < stepsList.length; i++) {
          String stepId = const Uuid().v4();
          await _firestore
              .collection('Users')
              .doc(_auth.currentUser!.uid)
              .collection('Goals')
              .doc(goalId)
              .collection('Steps')
              .doc(stepId)
              .set({
            "goalId": goalId,
            "stepName": stepsList[i],
            "stepId": stepId,
            "index": i,
            "isCompleted": false,
          });
          res = "success";
        }
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//updates an existing goal to the database
  Future<String> updateGoal(
      dynamic snap, String goalName, bool isImportant) async {
    String res = "Some error occured";
    try {
      if (goalName != '') {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(snap['goalId'])
            .update({
          'goalName': goalName,
          'isImportant': isImportant,
        });
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//adds a step to the goal from the goal details screen
  Future<String> addStepToGoal(
    dynamic snap,
    String stepName,
    int index,
  ) async {
    String res = "Some error occured";
    String stepId = const Uuid().v4();
    try {
      if (stepName != '') {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(snap['goalId'])
            .collection('Steps')
            .doc(stepId)
            .set({
          "stepName": stepName,
          "stepId": stepId,
          "index": index,
          "goalId": snap['goalId'],
          "isCompleted": false,
        });
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//changes iscompleted in a step when checkbox is clicked
  Future<String> changeStepCompleted(dynamic snap, bool? isCompleted) async {
    String res = "Some error occured";
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals')
          .doc(snap['goalId'])
          .collection('Steps')
          .doc(snap['stepId'])
          .update({
        'isCompleted': isCompleted,
      });

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//checks if the goal is competed by looking at toal steps and completed steps
  Future<String> checkGoalCompleted(String goalId) async {
    String res = "Some error occured";
    try {
      QuerySnapshot totalSteps = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals')
          .doc(goalId)
          .collection('Steps')
          .get();
      QuerySnapshot completedSteps = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals')
          .doc(goalId)
          .collection('Steps')
          .where('isCompleted', isEqualTo: true)
          .get();

      if (totalSteps.docs.length <= completedSteps.docs.length) {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(goalId)
            .update({"isCompleted": true});
      } else {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(goalId)
            .update({"isCompleted": false});
      }

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//deletes a goal from the database
  Future<String> deleteGoal(String goalId) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals')
          .doc(goalId)
          .delete();

      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//deletes a step from the database
  Future<String> deleteStep(dynamic snap) async {
    String res = "Some error occurred";
    try {
      QuerySnapshot stepsDocs = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals')
          .doc(snap['goalId'])
          .collection('Steps')
          .get();

      if (stepsDocs.docs.length <= 1) {
        _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(snap['goalId'])
            .delete();
        res = "Deleted Goal";
      } else {
        _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(snap['goalId'])
            .collection('Steps')
            .doc(snap['stepId'])
            .delete();
        res = "Deleted Step";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//makes goal completed
  Future<String> goalIsCompleted(dynamic snap) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals')
          .doc(snap['goalId'])
          .update({'isCompleted': true});
      res == "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//makes goal not completed
  Future<String> goalNotCompleted(dynamic snap) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals')
          .doc(snap['goalId'])
          .update({'isCompleted': false});
      res == "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //edit step name
  Future<String> editStepName(dynamic snap, String stepName) async {
    String res = "Some error occurred";
    try {
      if (stepName != '') {
        _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Goals')
            .doc(snap['goalId'])
            .collection('Steps')
            .doc(snap['stepId'])
            .update({'stepName': stepName});
        res == "success";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //goal important toggle
  Future<String> goalImportant(dynamic snap, bool? bool) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals')
          .doc(snap['goalId'])
          .update({"isImportant": bool});

      res == "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //goal important toggle
  Future<String> deleteUser() async {
    String res = "Some error occurred";
    try {
      _firestore.collection('Users').doc(_auth.currentUser!.uid).delete();
      res == "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //goal important toggle
  Future<String> changeUsername(String username, BuildContext context) async {
    String res = "Some error occurred";
    try {
      if (username != '') {
        _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .update({'username': username});
        res == "success";
        Navigator.of(context).pop();
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //goal important toggle
  Future<String> clearHistory(BuildContext context) async {
    String res = "Some error occurred";
    try {
      var habits = _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Habits');
      var habitsnapshots = await habits.get();
      for (var doc in habitsnapshots.docs) {
        await doc.reference.delete();
      }
      var goals = _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Goals');
      var goalSnapshots = await goals.get();
      for (var doc in goalSnapshots.docs) {
        await doc.reference.delete();
      }

      var dates = _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Dates');
      var dateSnapshots = await dates.get();
      for (var doc in dateSnapshots.docs) {
        await doc.reference.delete();
      }
      FirestoreMethods().checkDate();

      res == "success";
      Navigator.of(context).pop();
      showSnackBar('History Cleared!', context);
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
