import 'dart:io';

import 'package:gravador_mg/viewmodel/new_config_modelview.dart';

class ShellModelView {
  static Future<void> shellSTToVerifyPorts(NewConfigViewModel model) async {
    int index = 0;

    model.slots.clear();

    List<String> _devicesLocation = [];
    await Process.run(
        "wmic path CIM_LogicalDevice where \"Caption like 'USB Mass Storage Device'\" get DeviceID",
        []).then((process) {
      process.stdout.toString().split('\n').forEach((element) {
        if (element.startsWith('USB') && element.contains('PID_3744')) {
          _devicesLocation.add(element.split('\\').last.trim());
        }
      });
      _devicesLocation.toSet().toList().forEach((element) {
        index++;
        model.slots['SLOT $index'] = {
          'port': 'PORT' + element.split('&').last,
          'active': true,
        };
      });
    });
  }

  static Future<void> shellSiliconLabsToVerifyPorts(
      NewConfigViewModel model) async {
    int index = 0;

    model.slots.clear();
    await Process.run('chgport', []).then((process) {
      List<String> _ports = [];
      _ports = process.stdout.split('\n');
      model.lenghtSlots.text = index.toString();
      _ports.where((element) => element.contains('Silab')).forEach((element) {
        index++;
        model.slots['SLOT $index'] = {
          'port': element.split(" ").first,
          'active': true,
        };
        model.lenghtSlots.text = index.toString();
      });
    });
  }
}
