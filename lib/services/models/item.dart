class Item {
  int? _id;
  String? _name;
  double? _value;
  String? _unit;
  double? _quantity;

  Item({int? id, String? name, double? value, String? unit, double? quantity}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (value != null) {
      _value = value;
    }
    if (unit != null) {
      _unit = unit;
    }
    if (quantity != null) {
      _quantity = quantity;
    }
  }

  int? get id => _id;

  String? get name => _name;

  set name(String? name) => _name = name;

  double? get value => _value;

  set value(double? value) => _value = value;

  String? get unit => _unit;

  double? get quantity => _quantity;

  set quantity(double? quantity) => _quantity = quantity;

  Item.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _value = json['value'];
    _unit = json['unit'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['value'] = _value;
    data['unit'] = _unit;
    data['quantity'] = _quantity;
    return data;
  }
}
