import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String habitId;
  final String habitName;
  final int count;
  final int goal;
  final bool isCompleted;
  final bool isImportant;
  final dynamic dateAdded;

  const Habit({
    required this.habitId,
    required this.habitName,
    required this.count,
    required this.goal,
    required this.isCompleted,
    required this.isImportant,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
        "habitId": habitId,
        "habitName": habitName,
        "count": count,
        "goal": goal,
        "dateAdded": dateAdded,
        "isCompleted": isCompleted,
        "isImportant": isImportant
      };

  static Habit fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Habit(
        habitId: snapshot['habitId'],
        habitName: snapshot['habitName'],
        count: snapshot['count'],
        goal: snapshot['goal'],
        isCompleted: snapshot['isCompleted'],
        dateAdded: snapshot['dateAdded'],
        isImportant: snap['isImportant']);
  }
}
