import 'package:accomplishr_mobile_app/widgets/individual_bar.dart';

class BarData {
  final int firstValue;
  final int secondValue;
  final int thirdValue;
  final int fourthValue;
  final int fifthValue;
  final int sixthValue;
  final int seventhValue;

  BarData({
    required this.firstValue,
    required this.secondValue,
    required this.thirdValue,
    required this.fourthValue,
    required this.fifthValue,
    required this.sixthValue,
    required this.seventhValue,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: firstValue),
      IndividualBar(x: 1, y: secondValue),
      IndividualBar(x: 2, y: thirdValue),
      IndividualBar(x: 3, y: fourthValue),
      IndividualBar(x: 4, y: fifthValue),
      IndividualBar(x: 5, y: sixthValue),
      IndividualBar(x: 6, y: seventhValue),
    ];
  }
}
