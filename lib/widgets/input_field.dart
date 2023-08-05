import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const InputField(
      {super.key,
      required this.hintText,
      this.isPass = false,
      required this.textEditingController,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: const BorderSide(
            width: 2, color: whiteColor, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: false,
          hintStyle: GoogleFonts.workSans(color: whiteColor),
          contentPadding: const EdgeInsets.all(10)),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
