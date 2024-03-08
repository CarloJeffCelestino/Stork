import 'package:flutter/material.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ItemAddressList extends StatelessWidget {
  final Address address;
  final void Function(Address address) onEditClicked, onDeleteClicked;

  const ItemAddressList(
      {Key key,
      @required this.address,
      @required this.onEditClicked,
      @required this.onDeleteClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              flex: 10,
              child:
                  Text('${address.firstName ?? ''} ${address.lastName ?? ''}'),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () => onEditClicked(address),
                icon: Icon(Icons.edit_outlined),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete_outline_outlined),
                onPressed: () => onDeleteClicked(address),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getFormattedAddress(address)),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
