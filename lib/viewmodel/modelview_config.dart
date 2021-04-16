import 'package:gravador_mg/model/config.dart';

class ModelViewConfig {
  final Config config;

  ModelViewConfig(this.config);

  String get hex => config.hex;
  String get program => config.program;
  String get ref => config.ref;
}
