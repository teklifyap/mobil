class Employee {
  int? id;
  String? name;
  String? surname;
  String? salary;

  Employee({int? id, String? name, String? surname, String? salary}) {
    if (id != null) {
      this.id = id;
    }
    if (name != null) {
      this.name = name;
    }
    if (surname != null) {
      this.surname = surname;
    }
    if (salary != null) {
      this.salary = salary;
    }
  }

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
