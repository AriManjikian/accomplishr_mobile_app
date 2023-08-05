import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitDetailsScreen extends StatelessWidget {
  final dynamic snap;
  const HabitDetailsScreen({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Habit Name: ${snap["habitName"]}',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        )
        // Padding(
        //   padding: const EdgeInsets.all(30.0),
        //   child: const Divider(
        //     height: 20,
        //     thickness: 5,
        //     endIndent: 0,
        //     color: Colors.black,
        //   ),
        // ),
        );
  }
}
