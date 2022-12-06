class Employee {
  int? _id;
  String? _name;
  String? _surname;
  String? _salary;

  Employee({int? id, String? name, String? surname, String? salary}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (surname != null) {
      _surname = surname;
    }
    if (salary != null) {
      _salary = salary;
    }
  }

  int? get id => _id;

  set no(int? no) => _id = id;

  String? get name => _name;

  set name(String? name) => _name = name;

  String? get surname => _surname;

  set surname(String? surname) => _surname = surname;

  String? get salary => _salary;

  set salary(String? salary) => _salary = salary;

  Employee.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _surname = json['surname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['surname'] = _surname;
    return data;
  }
}
