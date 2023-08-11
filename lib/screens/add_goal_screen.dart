import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/screens/goals_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/widgets/input_field.dart';
import 'package:flutter/material.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _goalGoalController = TextEditingController();
  final TextEditingController _goalDescriptionController =
      TextEditingController();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  @override
  void dispose() {
    super.dispose();
    _goalDescriptionController.dispose();
    _goalGoalController.dispose();
    _goalNameController.dispose();
  }

  Future<String> uploadgoal() async {
    String res = "some error occured";
    try {
      _firestoreMethods.uploadHabit(_goalNameController.text, 0,
          int.parse(_goalGoalController.text), false);
      res = "success";
      Navigator.of(context).pop(MaterialPageRoute(
        builder: (context) {
          return const GoalsScreen();
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
              hintText: 'goal Name',
              textEditingController: _goalNameController,
              textInputType: TextInputType.text),
          InputField(
              hintText: 'goal description',
              textEditingController: _goalDescriptionController,
              textInputType: TextInputType.text),
          InputField(
              hintText: 'goal goal',
              textEditingController: _goalGoalController,
              textInputType: TextInputType.text),
          TextButton(
              onPressed: () {
                uploadgoal();
              },
              child: const Text('Add goal'))
        ],
      ),
    );
  }
}
