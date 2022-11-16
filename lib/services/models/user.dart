class User {
  int? _id;
  String? _name;
  String? _surname;
  String? _email;

  User({int? id, String? name, String? surname, String? email}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (surname != null) {
      _surname = surname;
    }
    if (email != null) {
      _email = email;
    }
  }

  int? get id => _id;

  String? get name => _name;

  String? get surname => _surname;

  String? get email => _email;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _surname = json['surname'];
    _email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['surname'] = _surname;
    data['email'] = _email;
    return data;
  }
}
