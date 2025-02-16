import 'package:flutter/material.dart';

class Dimensions {
  final BuildContext context;
  final double screenWidth;
  final double screenHeight;
  final double contentWidth1;
  final double contentWidth2;
  final double globalMargin1;
  final double globalMargin2;
  final double buttonHeight1;
  final double buttonHeight2;
  final double buttonHeight3;
  final double buttonHeight4;
  final double textSize1;
  final double textSize2;
  final double textSize3;
  final double textSize4;
  final double cornerRadius1;
  final double cornerRadius2;
  final double cornerRadius3;
  final double cornerRadius4;

  Dimensions({
    required this.context,
    required this.screenWidth,
    required this.screenHeight,
    required this.contentWidth1,
    required this.contentWidth2,
    required this.globalMargin1,
    required this.globalMargin2,
    required this.buttonHeight1,
    required this.buttonHeight2,
    required this.buttonHeight3,
    required this.buttonHeight4,
    required this.textSize1,
    required this.textSize2,
    required this.textSize3,
    required this.textSize4,
    required this.cornerRadius1,
    required this.cornerRadius2,
    required this.cornerRadius3,
    required this.cornerRadius4,
  });

  /// Factory constructor to calculate values based on the screen size.
  factory Dimensions.of(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final contentWidth1 = screenWidth * 0.86;
    final contentWidth2 = screenWidth * 0.94;

    final globalMargin1 = screenWidth * 0.07;
    final globalMargin2 = screenWidth * 0.03;

    final buttonHeight1 = screenHeight / 16;
    final buttonHeight2 = screenHeight / 18;
    final buttonHeight3 = screenHeight / 20;
    final buttonHeight4 = screenHeight / 28;

    final textSize1 = screenWidth / 8;
    final textSize2 = screenWidth / 18;
    final textSize3 = screenWidth / 22;
    final textSize4 = screenWidth / 32;

    final double cornerRadius1 = screenWidth / 30;
    final double cornerRadius2 = screenWidth / 32;
    final double cornerRadius3 = screenWidth / 34;
    final double cornerRadius4 = screenWidth / 36;

    return Dimensions(
      context: context,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      contentWidth1: contentWidth1,
      contentWidth2: contentWidth2,
      globalMargin1: globalMargin1,
      globalMargin2: globalMargin2,
      buttonHeight1: buttonHeight1,
      buttonHeight2: buttonHeight2,
      buttonHeight3: buttonHeight3,
      buttonHeight4: buttonHeight4,
      textSize1: textSize1,
      textSize2: textSize2,
      textSize3: textSize3,
      textSize4: textSize4,
      cornerRadius1: cornerRadius1,
      cornerRadius2: cornerRadius2,
      cornerRadius3: cornerRadius3,
      cornerRadius4: cornerRadius4,
    );
  }
}
