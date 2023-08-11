import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/screens/habits_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/widgets/input_field.dart';
import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _habitGoalController = TextEditingController();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  @override
  void dispose() {
    super.dispose();
    _habitGoalController.dispose();
    _habitNameController.dispose();
  }

  Future<String> uploadHabit() async {
    String res = "some error occured";
    try {
      _firestoreMethods.uploadHabit(_habitNameController.text, 0,
          int.parse(_habitGoalController.text), false);
      res = "success";
      Navigator.of(context).pop(MaterialPageRoute(
        builder: (context) {
          return const HabitsScreen();
        },
      ));
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
      ),
      body: Column(
        children: [
          InputField(
              hintText: 'Habit Name',
              textEditingController: _habitNameController,
              textInputType: TextInputType.text),
          InputField(
              hintText: 'Habit goal',
              textEditingController: _habitGoalController,
              textInputType: TextInputType.text),
          TextButton(
              onPressed: () {
                uploadHabit();
              },
              child: const Text('Add Habit'))
        ],
      ),
    );
  }
}
