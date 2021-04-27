class CommandST {
  List<String> params = [];

  CommandST.fromJson(Map<String, dynamic> json) : params = json['params'];

  Map<String, dynamic> toJson() => {'params': params};
}
