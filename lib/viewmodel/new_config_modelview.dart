import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/cupertino.dart';
import 'package:gravador_mg/model/config.dart';

class NewConfigViewModel extends ChangeNotifier {
  Config newConfig;

  TextEditingController _lenghtSlots = TextEditingController(text: '0');
  TextEditingController _reference = TextEditingController();
  TextEditingController _hexFile = TextEditingController();
  TextEditingController _program = TextEditingController();

  Map _slots = {};

  /* String get hex => newConfig.hex;
  String get program => newConfig.program;
  String get ref => newConfig.ref; */

  get slots => _slots;
  get lenghtSlots => _lenghtSlots;
  get reference => _reference;
  get hexFile => _hexFile;
  get program => _program;

  setNewConfig(Map slots, String hex, String ref, String program) {
    this.newConfig = Config(slots, hex, ref, program);
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
