import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/habit_details_screen.dart';
import '../utils/colors.dart';

class GoalTile extends StatelessWidget {
  final dynamic snap;
  const GoalTile({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: grayColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${snap["goalName"]}',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return HabitDetailsScreen(
              snap: snap,
            );
          },
        ));
      },
    );
  }
}
