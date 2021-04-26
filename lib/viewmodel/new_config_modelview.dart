import 'dart:convert';
import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/cupertino.dart';
import 'package:gravador_mg/model/config.dart';
import 'package:gravador_mg/repository/DirectoryRepository.dart';

class NewConfigViewModel extends ChangeNotifier {
  TextEditingController _lenghtSlots = TextEditingController(text: '0');
  TextEditingController _reference = TextEditingController();
  TextEditingController _hexFile = TextEditingController();
  String _program = 'SILICON LABS';

  Map<String, dynamic> _slots = {};

  bool valueCheckBox = true;

  get slots => _slots;
  get lenghtSlots => _lenghtSlots;
  get reference => _reference;
  get hexFile => _hexFile;

  set program(String text) {
    _program = text;
  }

  setNewConfig() {
    Config newConfig = Config(slots, hexFile.text, reference.text, _program);
    File file = File(DirectoryRepository.filesDirectory.path +
        '\\' +
        '${reference.text}.json');

    file.writeAsStringSync(jsonEncode(newConfig));
  }

  onClickCheckBox() {
    valueCheckBox = !valueCheckBox;
    notifyListeners();
  }

  submitSlots(String value) {
    if (value.isNotEmpty &&
        int.tryParse(value) > 0 &&
        int.tryParse(value) < 30) {
      int _length = int.parse(value);
      slots.clear();
      for (int index = 1; index <= _length; index++) {
        slots['SLOT $index'] = {
          'port': 'PORT$index',
          'active': true,
        };
        notifyListeners();
      }
    }
  }

  openFile() {
    final result = OpenFilePicker()
      ..defaultExtension = 'efm8'
      ..filterSpecification = {'Program (*.efm8)': '*.efm8'}
      ..title = 'Selecione o arquivo';
    final file = result.getFile();
    if (file != null) {
      if (file.path.isNotEmpty) {
        hexFile.text = file.path /* .split("\\").last */;
        reference.text =
            hexFile.text.split("\\").last.split(".").first.toUpperCase();
      }
    }
  }

  hasValueInAllFields() => hexFile.text.isNotEmpty &&
          reference.text.isNotEmpty &&
          lenghtSlots.text.isNotEmpty
      ? true
      : false;
}
