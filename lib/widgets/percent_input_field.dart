import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PercentInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextAlign textAlign;
  const PercentInputField({
    super.key,
    required this.textAlign,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      cursorColor: Colors.black,
      style: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.black12, width: 1)),
          contentPadding: EdgeInsets.all(5),
          constraints: BoxConstraints(maxWidth: 60)),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: textAlign,
      keyboardType: TextInputType.number,
    );
  }
}
