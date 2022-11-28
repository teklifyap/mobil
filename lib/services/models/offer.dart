import 'package:teklifyap/services/models/item.dart';

class Offer {
  int? _id;
  String? _title;
  String? _date;
  bool _status = false;
  String? _userName;
  String? _receiverName;
  double? _profitRate;
  List<Item>? _items;

  Offer(
      {int? id,
      String? title,
      String? date,
      bool status = false,
      String? userName,
      String? receiverName,
      double? profitRate,
      List<Item>? items}) {
    _status = status;
    if (id != null) {
      _id = id;
    }
    if (title != null) {
      _title = title;
    }
    if (date != null) {
      _date = date;
    }
    if (userName != null) {
      _userName = userName;
    }
    if (receiverName != null) {
      _receiverName = receiverName;
    }
    if (profitRate != null) {
      _profitRate = profitRate;
    }
    if (items != null) {
      _items = items;
    }
  }

  int? get id => _id;

  set id(int? id) => _id = id;

  String? get title => _title;

  set title(String? title) => _title = title;

  String? get date => _date;

  set date(String? date) => _date = date;

  bool get status => _status;

  set status(bool status) => _status = status;

  String? get userName => _userName;

  set userName(String? userName) => _userName = userName;

  String? get receiverName => _receiverName;

  set receiverName(String? receiverName) => _receiverName = receiverName;

  double? get profitRate => _profitRate;

  set profitRate(double? profitRate) => _profitRate = profitRate;

  List<Item>? get items => _items;

  set items(List<Item>? items) => _items = items;

  Offer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _date = json['date'];
    _status = json['status'];
    _userName = json['userName'];
    _receiverName = json['receiverName'];
    _profitRate = json['profitRate'];
    if (json['items'] != null) {
      _items = <Item>[];
      json['items'].forEach((v) {
        _items!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['date'] = _date;
    data['status'] = _status;
    data['userName'] = _userName;
    data['receiverName'] = _receiverName;
    data['profitRate'] = _profitRate;
    if (_items != null) {
      data['items'] = _items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
