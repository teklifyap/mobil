class Item {
  int? _id;
  String? _name;
  String? _value;
  String? _unit;
  String? _quantity;

  Item({int? id, String? name, String? value, String? unit, String? quantity}) {
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

  String? get value => _value;

  set value(String? value) => _value = value;

  String? get unit => _unit;

  String? get quantity => _quantity;

  set quantity(String? quantity) => _quantity = quantity;

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
