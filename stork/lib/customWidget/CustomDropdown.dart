import 'package:flutter/material.dart';
import 'package:nopcart_flutter/utils/styles.dart';

class CustomDropdown<T> extends StatelessWidget {

  final T preSelectedItem;
  final List<DropdownMenuItem<T>> items;
  final void Function(T value) onChanged;
  final void Function(T value) onSaved;
  final String Function(T value) validator;

  const CustomDropdown(
      {Key key,
      @required this.preSelectedItem,
      @required this.items,
      @required this.onChanged,
      this.onSaved,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        /*decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey)),*/
        child: DropdownButtonFormField<T>(
          value: preSelectedItem,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
          ),
          icon: Icon(
            Icons.arrow_drop_down_sharp,
            color: Styles.textColor(context),
          ),
          iconSize: 28,
          isExpanded: true,
          style: Theme.of(context).textTheme.subtitle2,
          onChanged: (value) {
            FocusScope.of(context).requestFocus(FocusNode());
            if (onChanged != null)
              onChanged(value);
          },
          onSaved: (newValue) => onSaved != null ? onSaved(newValue) : () {},
          validator: (value) => validator != null ? validator(value) : null,
          items: items,
        ),
      ),
    );
  }
}
