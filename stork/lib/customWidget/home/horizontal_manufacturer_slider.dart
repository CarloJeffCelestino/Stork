import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/home/manufacturer_box.dart';
import 'package:nopcart_flutter/customWidget/home/product_box_header.dart';
import 'package:nopcart_flutter/model/home/ManufacturersResponse.dart';

class HorizontalManufacturerSlider extends StatelessWidget {
  final String title;

  final List<ManufacturerData> manufacturersList;

  HorizontalManufacturerSlider(this.title, this.manufacturersList);

  void goToProductListPage() {
    // print('Go to product list page.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductBoxHeader(
          title,
          false,
          false,
          [],
          manufacturerList: manufacturersList ?? [],
        ),
        SizedBox(
          height: 275,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3),
            scrollDirection: Axis.horizontal,
            itemCount: manufacturersList.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(15.0),
                onTap: () {
                  goToProductListPage();
                },
                child: ManufacturerBox(manufacturersList[index]),
              );
            }),
          ),



          //
          // ListView.builder(
          //     shrinkWrap: true,
          //     scrollDirection: Axis.horizontal,
          //     itemCount: manufacturersList?.length ?? 0,
          //     itemBuilder: (BuildContext context, int index) {
          //       return InkWell(
          //         borderRadius: BorderRadius.circular(15.0),
          //         onTap: () {
          //           goToProductListPage();
          //         },
          //         child: ManufacturerBox(manufacturersList[index]),
          //       );
          //     }),
      ],
    );
  }
}
