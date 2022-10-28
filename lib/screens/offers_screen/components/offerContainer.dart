import 'package:flutter/material.dart';

class OfferContainer extends StatefulWidget {
  const OfferContainer(
      {Key? key,
      required this.offerTitle,
      required this.offerDate,
      required this.onListTileTap,
      required this.onDelete})
      : super(key: key);

  final String offerTitle;
  final String offerDate;
  final VoidCallback onListTileTap;
  final VoidCallback onDelete;

  @override
  State<OfferContainer> createState() => _OfferContainerState();
}

class _OfferContainerState extends State<OfferContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white60,
        child: ListTile(
          onTap: widget.onListTileTap,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.local_offer),
            ],
          ),
          title: Text(widget.offerTitle),
          subtitle: Text(widget.offerDate),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.grey,
            onPressed: widget.onDelete,
          ),
        ),
      ),
    );
  }
}
