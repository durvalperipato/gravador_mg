class Config {
  final Map<String, dynamic> config;
  final String hex;
  final String ref;
  final String program;

  Config(this.config, this.hex, this.ref, this.program);

  Config.fromJson(Map<String, dynamic> json)
      : config = json['config'],
        hex = json['hex'],
        ref = json['ref'],
        program = json['program'];

  Map<String, dynamic> toJson() => {
        'config': config,
        'hex': hex,
        'ref': ref,
        'program': program,
      };
}
