import 'package:teklifyap/services/models/item.dart';

class Offer {
  int? id;
  String? title;
  String? date;
  bool status = false;
  String? userName;
  String? receiverName;
  double? profitRate;
  List<Item>? items;

  Offer(
      {this.id,
      this.title,
      this.date,
      this.status = false,
      this.userName,
      this.receiverName,
      this.profitRate,
      this.items});

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    status = json['status'];
    userName = json['userName'];
    receiverName = json['receiverName'];
    profitRate = json['profitRate'];
    if (json['items'] != null) {
      items = <Item>[];
      json['items'].forEach((v) {
        items!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['status'] = status;
    data['userName'] = userName;
    data['receiverName'] = receiverName;
    data['profitRate'] = profitRate;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
