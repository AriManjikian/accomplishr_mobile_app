import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String goalId;
  final String goalName;
  final dynamic dateAdded;
  final bool isCompleted;
  final bool isImportant;

  const Goal({
    required this.goalId,
    required this.goalName,
    required this.dateAdded,
    required this.isCompleted,
    required this.isImportant,
  });

  Map<String, dynamic> toJson() => {
        "goalId": goalId,
        "goalName": goalName,
        "dateAdded": dateAdded,
        "isCompleted": isCompleted,
        "isImportant": isImportant,
      };

  static Goal fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Goal(
      goalId: snapshot['goalId'],
      goalName: snapshot['goalName'],
      isCompleted: snapshot['isCompleted'],
      dateAdded: snapshot['dateAdded'],
      isImportant: snapshot['isImportant'],
    );
  }
}
