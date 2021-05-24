class Config {
  final Map<String, dynamic> slots;
  final String device;
  final String hex;
  final String optionByte;
  final String ref;
  final String program;

  Config(this.slots, this.device, this.hex, this.optionByte, this.ref,
      this.program);

  Config.fromJson(Map<String, dynamic> json)
      : slots = json['config'],
        device = json['device'],
        hex = json['hex'],
        optionByte = json['optionByte'],
        ref = json['ref'],
        program = json['program'];

  Map<String, dynamic> toJson() => {
        'config': slots['config'],
        'device': device,
        'hex': hex,
        'optionByte': optionByte,
        'ref': ref,
        'program': program,
      };
}
