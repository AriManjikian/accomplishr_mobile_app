import 'package:flutter/material.dart';

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      alignment: Alignment.topCenter,
      child: Text(content),
    ),
  ));
}
