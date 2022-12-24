import 'package:teklifyap/services/models/employee.dart';

class Worksite {
  int? id;
  String? name;
  String? userName;
  String? date;
  String? offerName;
  String? address;
  double? locationX;
  double? locationY;
  int? offerID;
  List<Employee>? employees;

  Worksite(
      {this.id,
      this.name,
      this.userName,
      this.date,
      this.offerName,
      this.address,
      this.locationX,
      this.locationY,
      this.employees,
      this.offerID});

  Worksite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userName = json['userName'];
    date = json['date'];
    offerName = json['offerName'];
    address = json['address'];
    locationX = json['locationX'];
    locationY = json['locationY'];
    if (json['employees'] != null) {
      employees = <Employee>[];
      json['employees'].forEach((v) {
        employees!.add(Employee.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['userName'] = userName;
    data['date'] = date;
    data['offerName'] = offerName;
    data['address'] = address;
    data['locationX'] = locationX;
    data['locationY'] = locationY;
    if (employees != null) {
      data['employees'] = employees!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '$id, $name, $userName, $date, $offerName, $address, $locationX, $locationY ';
  }
}
