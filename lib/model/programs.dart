class ProgramsPath {
  final String pathST;
  final String pathSiliconLabs;

  ProgramsPath(this.pathST, this.pathSiliconLabs);

  ProgramsPath.fromJson(Map<String, dynamic> json)
      : pathST = json['ST'],
        pathSiliconLabs = json['SILICON LABS'];

  Map<String, dynamic> toJson() => {
        'programs': {
          'ST': pathST,
          'SILICON LABS': pathSiliconLabs,
        }
      };
}
