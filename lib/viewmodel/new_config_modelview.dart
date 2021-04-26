import 'package:flutter/cupertino.dart';
import 'package:gravador_mg/model/config.dart';

class NewConfigViewModel extends ChangeNotifier {
  Config newConfig;

  NewConfigViewModel();

  String get hex => newConfig.hex;
  String get program => newConfig.program;
  String get ref => newConfig.ref;

  set config(Config newConfig) {
    this.newConfig = newConfig;
    notifyListeners();
  }
}
