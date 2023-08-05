import 'package:accomplishr_mobile_app/screens/habit_details_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitTile extends StatelessWidget {
  final dynamic snap;
  const HabitTile({super.key, required this.snap});

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
                      '${snap["habitName"]}',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${snap["count"]} / ${snap["goal"]}',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade600,
                    value: snap['count'] / snap['goal'] > 1
                        ? 1
                        : snap['count'] / snap['goal'],
                    color: greenColor,
                    minHeight: 15,
                  ),
                )
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
