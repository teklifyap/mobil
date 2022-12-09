class User {
  int? id;
  String? name;
  String? surname;
  String? email;

  User({this.id, this.name, this.surname, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['email'] = email;
    return data;
  }
}
