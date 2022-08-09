class AuthModel {
  String? username;
  String? level;
  String? name;
  int? target;

  AuthModel({
    required this.username,
    required this.level,
    required this.name,
    this.target,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'level': this.level,
      'name': this.name,
      'target': this.target,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      username: map['username'],
      level: map['level'],
      name: map['name'],
      target: map['target'],
    );
  }
}
