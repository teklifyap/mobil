class Item {
  int? id;
  String? name;
  double? value;
  String? unit;
  double? quantity;

  Item({int? id, String? name, double? value, String? unit, double? quantity}) {
    if (id != null) {
      this.id = id;
    }
    if (name != null) {
      this.name = name;
    }
    if (value != null) {
      this.value = value;
    }
    if (unit != null) {
      this.unit = unit;
    }
    if (quantity != null) {
      this.quantity = quantity;
    }
  }

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    unit = json['unit'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['unit'] = unit;
    data['quantity'] = quantity;
    return data;
  }
}
