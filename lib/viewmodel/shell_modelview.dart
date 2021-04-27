import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gravador_mg/viewmodel/new_config_modelview.dart';

class ShellModelView extends ChangeNotifier {
  static Future<void> shellSTToVerifyPorts(NewConfigViewModel model) async {
    int index = 0;

    List<String> _devicesLocation = [];
    await Process.run(
        "wmic path CIM_LogicalDevice where \"Caption like 'USB Mass Storage Device'\" get DeviceID",
        []).then((process) {
      process.stdout.toString().split('\n').forEach((element) {
        if (element.startsWith('USB') && element.contains('PID_3744')) {
          _devicesLocation.add(element.split('\\').last.trim());
        }
      });
      model.slots['config'] = {};
      _devicesLocation.toSet().toList().forEach((element) {
        index++;
        model.slots['config']['SLOT $index'] = {
          'port':
              '${index - 1}', //+ element.split('&').last, ESTE COMANDO PEGA O NUMERO DA PORTA
          'active': true,
        };
      });
      model.lenghtSlots.text = index.toString();
      model.slots = model.slots;
    });
  }

  static Future<void> shellSiliconLabsToVerifyPorts(
      NewConfigViewModel model) async {
    int index = 0;

    await Process.run('chgport', []).then((process) {
      List<String> _ports = [];
      _ports = process.stdout.split('\n');
      model.lenghtSlots.text = index.toString();
      model.slots['config'] = {};
      _ports.where((element) => element.contains('Silab')).forEach((element) {
        index++;
        model.slots['config']['SLOT $index'] = {
          'port': element.split(" ").first,
          'active': true,
        };
      });
      model.lenghtSlots.text = index.toString();
      model.slots = model.slots;
    });
  }

  static Future<ProcessResult> recordST(List<String> params) {
    return Process.run(
      'stvp/STVP_CmdLine.exe',
      params,
    );
  }

  static Future<ProcessResult> recordSiliconLabs(List<String> params) =>
      Process.run(
        'efm8load.exe',
        params,
      );
}
