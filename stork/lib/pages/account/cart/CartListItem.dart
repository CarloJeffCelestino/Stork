import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nopcart_flutter/customWidget/CustomDropdown.dart';
import 'package:nopcart_flutter/customWidget/RoundButton.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:nopcart_flutter/utils/extensions.dart';

class CartListItem extends StatelessWidget {
  CartListItem({this.item, this.onClick, this.editable});

  final CartItem item;
  final Function(Map<String, String>) onClick;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    var sku = Column(
      children: [
        SizedBox(
          height: 3,
        ),
        Text(
          "${GlobalService().getString(Const.SKU)}: ${item.sku}",
          style: TextStyle(fontSize: 14.0),
        ),
      ],
    );

    var customAttributes = Column(
      children: [
        SizedBox(
          height: 3,
        ),
        HtmlWidget(
          item.attributeInfo ?? '',
        ),
      ],
    );

    String warnings = '';
    if (item.warnings?.isNotEmpty == true) {
      item.warnings.forEach((element) {
        warnings = (warnings + element + '\n');
      });
      warnings.trimRight();
    }

    var quantityButton = Container(
      child: Row(
        children: [
          // RoundButton(radius: 35, icon: icon, onClick: onClick)
            SizedBox(
              width: 16,
              child: IconButton(
                padding: new EdgeInsets.all(0.0),
                onPressed: () => onClick({'action': 'minus'}),
                icon: Icon(
                  Icons.remove,
                  size: 16,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('${item.quantity}', style: TextStyle(fontSize: 16)),
          ),
            SizedBox(
            width: 16,
            child: IconButton(
              padding: new EdgeInsets.all(0.0),
              onPressed: () => onClick({'action': 'plus'}),
              icon: Icon(
                Icons.add,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );

    var allowedQuantityDropdown = CustomDropdown<AvailableOption>(
      onChanged: (value) {
        onClick({'action': 'setQuantity', 'quantity': value.value});
      },
      preSelectedItem: item.allowedQuantities?.safeFirstWhere(
        (element) => element.selected ?? false,
        orElse: () => item.allowedQuantities?.safeFirst(),
      ),
      items: item?.allowedQuantities
              ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                  DropdownMenuItem<AvailableOption>(
                      value: e, child: Text(e.text)))
              ?.toList() ??
          List.empty(),
    );

    return Container(
      child: Column(
        children: [
          Card(
            elevation: editable ? 2 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CpImage(
                      url: item.picture.imageUrl,
                      width: 80,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 3, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 9,
                                child: Text(
                                  item.productName,
                                  style: Styles.productNameTextStyle(context),
                                ),
                              ),
                              //   Flexible(
                              //   flex: 1,
                              //   child: (editable /*&& item.allowItemEditing*/)
                              //       ? InkWell(
                              //           onTap: () => onClick({'action': 'remove'}),
                              //           child: Icon(Icons.close_outlined),
                              //         )
                              //       : SizedBox.shrink(),
                              // )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // Text(
                          //   "${GlobalService().getString(Const.TOTAL)}: ${item.subTotal}\n" +
                          //       "${GlobalService().getString(Const.PRICE)}: ${item.unitPrice}",
                          //   style: Styles.productPriceTextStyle(context),
                          // ),
                          // if (item.sku?.isNotEmpty == true) sku,
                          if (item.attributeInfo?.isNotEmpty == true)
                            customAttributes,
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              if (editable && (item.allowedQuantities ?? []).isEmpty)
                                quantityButton,
                              if (editable && (item.allowedQuantities ?? []).isNotEmpty)
                                allowedQuantityDropdown,
                              if (!editable)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Qty: x${item.quantity}',
                                      style: TextStyle(
                                          fontSize: 14
                                      )
                                  ),
                                ),
                              Spacer(),
                              if (editable)
                                Text(
                                  "${item.subTotal}",
                                  style: Styles.productPriceTextStyle(context),
                                )
                            ],
                          ),

                          if (warnings.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                warnings,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!editable)
            Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 36, right: 8, top: 16, bottom: 16),
                child: Row(
                  children: [
                    Text(
                      "Item Subtotal:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${item.subTotal}",
                      style: Styles.productPriceTextStyle(context),
                    ),
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }
}

