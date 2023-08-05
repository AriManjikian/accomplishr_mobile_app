import 'package:accomplishr_mobile_app/screens/goals_screen.dart';
import 'package:accomplishr_mobile_app/screens/home_screen.dart';
import 'package:accomplishr_mobile_app/screens/habits_screen.dart';
import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

class MobileScreenLaoyut extends StatefulWidget {
  const MobileScreenLaoyut({super.key});

  @override
  State<MobileScreenLaoyut> createState() => _MobileScreenLaoyutState();
}

class _MobileScreenLaoyutState extends State<MobileScreenLaoyut> {
  late PageController pageController;
  int index = 1;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: getSelectedWidget(index: index),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: bgColor,
        color: Colors.black,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.check),
            label: 'Habits',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.emoji_events),
            label: 'Goals',
          ),
        ],
        index: 1,
        onTap: (selctedIndex) {
          setState(() {
            index = selctedIndex;
          });
        },
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const HabitsScreen();
        break;
      case 1:
        widget = const HomeScreen();
        break;
      default:
        widget = const GoalsScreen();
        break;
    }
    return widget;
  }
}
