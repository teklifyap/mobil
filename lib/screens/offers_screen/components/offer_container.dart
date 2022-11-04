import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OfferContainer extends HookWidget {
  const OfferContainer(
      {Key? key,
      required this.offerTitle,
      required this.offerDate,
      required this.onListTileTap,
      required this.trailing})
      : super(key: key);

  final String offerTitle;
  final String offerDate;
  final VoidCallback onListTileTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white60,
        child: ListTile(
          onTap: onListTileTap,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.local_offer),
            ],
          ),
          title: Text(offerTitle),
          subtitle: Text(offerDate),
          trailing: trailing,
        ),
      ),
    );
  }
}
