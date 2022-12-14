class Employee {
  int? id;
  String? name;
  String? surname;
  String? salary;

  Employee({this.id, this.name, this.surname, this.salary});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    return data;
  }
}
