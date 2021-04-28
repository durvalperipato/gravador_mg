import 'dart:convert';
import 'dart:io';

import 'package:gravador_mg/repository/DirectoryRepository.dart';
import 'package:gravador_mg/utils/variables.dart';

class DirectorySiliconLab {
  static String pathProgramSiliconLab() =>
      DirectoryRepository.pathPrograms[programSiliconLab];
}
