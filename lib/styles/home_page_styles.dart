import 'package:flutter/material.dart';
import 'package:gravador_mg/viewmodel/home_page_modelview.dart';

class HomePageStyles {
  HomePageStyles(_);

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
}
