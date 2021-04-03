class Config {
  final Map<String, dynamic> config;
  final String hex;
  final String ref;

  Config(this.config, this.hex, this.ref);

  Config.fromJson(Map<String, dynamic> json)
      : config = json['config'],
        hex = json['hex'],
        ref = json['ref'];

  Map<String, dynamic> toJson() => {
        'config': config,
        'hex': hex,
        'ref': ref,
      };
}
