import 'package:flutter/material.dart';
import 'package:gravador_mg/viewmodel/home_page_modelview.dart';

class HomePageStyles {
  HomePageStyles._();

  static double textFontSize(HomePageViewModel model, {bool title = false}) {
    double min = 10;
    double med = 15;
    double max = 30;
    if (!title) {
      min = 7;
      med = 10;
      max = 20;
    }
    return model.slots['config'].length > 7 && model.slots['config'].length < 11
        ? med
        : model.slots['config'].length >= 11
            ? min
            : max;
  }

  static Color colorSlot(HomePageViewModel model, String slot) =>
      model.slots['config'][slot]['active']
          ? model.slots['config'][slot]['color']
          : Colors.grey[200];

  static BoxDecoration get backgroundColorHomePage => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[300],
            Colors.grey[300],
            Colors.grey[200],
            Colors.grey[200],
            Colors.grey[100],
          ],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
      );

  static BoxDecoration get innerShadowing => BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(-2, -2),
              blurRadius: 2,
            ),
            BoxShadow(
              color: Colors.white70,
              offset: Offset(2, 2),
              blurRadius: 2,
            ),
          ]);

  static SizedBox get blankWidthSpace => SizedBox(
        width: 30,
      );
  static SizedBox get blankHeightSpace => SizedBox(
        height: 30,
      );
}
