import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nopcart_flutter/model/ProductDetailsResponse.dart';
import 'package:nopcart_flutter/utils/extensions.dart';

class SpecificationAttributeItem extends StatelessWidget {
  final SpecificationAttr attribute;

  const SpecificationAttributeItem({Key key, @required this.attribute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );

    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(attribute.name ?? '', style: titleStyle),
        ),
        Expanded(
            flex: 7,
            child: HtmlWidget(attribute.values?.safeFirst()?.valueRaw ?? ''),
        ),
      ],
    );
  }
}
