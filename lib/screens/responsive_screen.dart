import 'package:accomplishr_mobile_app/responsive/mobile_screen_layout.dart';
import 'package:accomplishr_mobile_app/responsive/responsive_screen_layout.dart';
import 'package:accomplishr_mobile_app/responsive/web_screen_layout.dart';
import 'package:flutter/material.dart';

class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLaoyut(),
        webScreenLayout: WebScreenLayout());
  }
}
