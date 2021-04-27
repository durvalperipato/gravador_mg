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
          'port': 'PORT' + element.split('&').last,
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

  static Future<ProcessResult> recordST(String id, String hex) {
    return Process.run(
      'stvp/STVP_CmdLine.exe',
      [
        '-BoardName=ST-LINK',
        '-Port=USB',
        '-ProgMode=SWIM',
        '-Device=STM8S001J3',
        '-Tool_ID=$id',
        '-no_loop',
        '-FileProg=$hex',
        '-no_verif',
      ],
    );
  }

  static Future<ProcessResult> recordSiliconLabs(String port, String hex) =>
      Process.run(
        'efm8load.exe',
        ['-p', '$port', '$hex'],
      );
}
