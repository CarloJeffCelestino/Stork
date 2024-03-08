import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/RoundButton.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/model/ProductDetailsResponse.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/utils/styles.dart';

class ItemGroupProduct extends StatefulWidget {
  final ProductDetails item;
  final Widget price;
  final Function(int cartType) onClick;

  const ItemGroupProduct(
      {Key key,
      @required this.item,
      @required this.price,
      @required this.onClick})
      : super(key: key);

  @override
  _ItemGroupProductState createState() => _ItemGroupProductState(item, price, onClick);
}

class _ItemGroupProductState extends State<ItemGroupProduct> {
  final ProductDetails data;
  final Widget price;
  final Function(int cartType) onClick;

  _ItemGroupProductState(this.data, this.price, this.onClick);

  @override
  Widget build(BuildContext context) {
    var quantityButton = Row(
      children: [
        RoundButton(
          icon: Icon(
            Icons.remove,
            size: 18.0,
          ),
          radius: 35,
          onClick: () {
            setState(() {
              if (data.addToCart.enteredQuantity > 1)
                data.addToCart.enteredQuantity--;
            });
          },
        ),
        SizedBox(width: 15),
        Text('${data.addToCart.enteredQuantity}'),
        SizedBox(width: 15),
        RoundButton(
          icon: Icon(
            Icons.add,
            size: 18.0,
          ),
          radius: 35,
          onClick: () {
            setState(() {
              data.addToCart.enteredQuantity++;
            });
          },
        ),
        SizedBox(width: 15),
        IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: Color(0xFFFF476E),
            size: 26,
          ),
          onPressed: () => onClick(2),
        ),
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            size: 26,
          ),
          onPressed: () => onClick(1),
        )
      ],
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          ProductDetailsPage.routeName,
          arguments: ProductDetailsScreenArguments(
            id: data.id,
            name: data.name,
            productDetails: data,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CpImage(
                  url: data.defaultPictureModel.imageUrl,
                  width: 120,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 3, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3),
                      Text(
                        data.name,
                        style: Styles.productNameTextStyle(context),
                      ),
                      price,
                      SizedBox(height: 6),
                      quantityButton,
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
