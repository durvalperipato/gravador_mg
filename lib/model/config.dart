class Config {
  final Map<String, dynamic> slots;
  final String hex;
  final String ref;
  final String program;

  Config(this.slots, this.hex, this.ref, this.program);

  Config.fromJson(Map<String, dynamic> json)
      : slots = json['config'],
        hex = json['hex'],
        ref = json['ref'],
        program = json['program'];

  Map<String, dynamic> toJson() => {
        'config': slots['config'],
        'hex': hex,
        'ref': ref,
        'program': program,
      };
}
