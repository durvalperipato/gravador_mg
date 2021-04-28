import 'package:gravador_mg/repository/DirectoryRepository.dart';
import 'package:gravador_mg/utils/variables.dart';

class DirectoryST {
  static String pathProgramST() =>
      DirectoryRepository.pathPrograms[programST] ?? "";
}
