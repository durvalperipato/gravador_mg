import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gravador_mg/repository/DirectoryST.dart';
import 'package:gravador_mg/repository/DirectorySiliconLab.dart';
import 'package:gravador_mg/viewmodel/home_page_modelview.dart';
import 'package:gravador_mg/viewmodel/new_config_modelview.dart';

class ShellModelView extends ChangeNotifier {
  static refreshSTPorts(HomePageViewModel model) {
    _commandST(model, refresh: true);
  }

  static refreshSiliconLabsPorts(HomePageViewModel model) {
    _commandSiliconLab(model, refresh: true);
  }

  static Future<void> shellSTToVerifyPorts(NewConfigViewModel model) async {
    _commandST(model);
  }

  static Future<void> shellSiliconLabsToVerifyPorts(
      NewConfigViewModel model) async {
    _commandSiliconLab(model);
  }

  static Future<ProcessResult> recordST(List<String> params) {
    return Process.run(
      DirectoryST.pathProgramST() /* 'stvp/STVP_CmdLine.exe' */,
      params,
    );
  }

  static Future<ProcessResult> recordSiliconLabs(List<String> params) =>
      Process.run(
        DirectorySiliconLab.pathProgramSiliconLab() /* 'efm8load.exe' */,
        params,
      );

  static _commandST(dynamic model, {bool refresh = false}) async {
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
      if (!refresh) {
        model.lenghtSlots.text = index.toString();
      }
      model.slots = model.slots;
    });
  }

  static _commandSiliconLab(dynamic model, {bool refresh = false}) async {
    int index = 0;

    await Process.run('chgport', []).then((process) {
      List<String> _ports = [];
      _ports = process.stdout.split('\n');
      model.slots['config'] = {};
      _ports.where((element) => element.contains('Silab')).forEach((element) {
        index++;
        model.slots['config']['SLOT $index'] = {
          'port': element.split(" ").first,
          'active': true,
        };
      });
      if (!refresh) {
        model.lenghtSlots.text = index.toString();
      }
      model.slots = model.slots;
    });
  }
}
