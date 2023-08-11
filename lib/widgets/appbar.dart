import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

PreferredSizeWidget myAppBar(String header, String message, AssetImage photo) {
  return AppBar(
    elevation: 50,
    backgroundColor: Colors.black,
    flexibleSpace: ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      header,
                      style: GoogleFonts.workSans(
                          color: whiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      message,
                      style: GoogleFonts.workSans(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: photo,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(110),
      child: Container(),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(60),
        bottomRight: Radius.circular(60),
      ),
    ),
  );
}
