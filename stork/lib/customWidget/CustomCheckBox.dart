import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {Key key,
      @required this.onTap,
      @required this.isChecked,
      @required this.label})
      : super(key: key);

  final Function onTap;
  final bool isChecked;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isChecked
                ? Icon(
              Icons.check_circle_outline_outlined,
              color: Theme.of(context).primaryColor,
            )
                : Icon(
              Icons.radio_button_unchecked_outlined,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.subtitle1),
            ),
          ],
        ),
      ),
    );
  }
}
