import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/model/category_tree/CategoryTreeResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:ui' as ui;

class CategoryTree extends StatefulWidget {
  final ApiResponse<CategoryTreeResponse> snapshot;
  CategoryTree(this.snapshot);

  @override
  _CategoryTreeState createState() => _CategoryTreeState();
}

class _CategoryTreeState extends State<CategoryTree> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom -
          (MediaQuery.of(context).orientation == Orientation.portrait ? 105.0 : 57.0),
      child: categoryList(widget.snapshot),
    );
  }

  Future<PaletteGenerator>_updatePaletteGenerator(String url) async {

    if (!kIsWeb) {
      var paletteGenerator = PaletteGenerator.fromImageProvider(
        NetworkImage(url)
      );

      return paletteGenerator;
    }
    else {
      var uri = Uri.parse(url);
      var bytes = await readBytes(uri);
      ui.Codec codec = await ui.instantiateImageCodec(bytes);
      ui.FrameInfo fi = await codec.getNextFrame();

      var paletteGenerator = PaletteGenerator.fromImage(
        fi.image,
      );

      return paletteGenerator;
    }


  }

  Widget categoryList(ApiResponse<CategoryTreeResponse> response) {
    switch (response.status) {
      case Status.LOADING:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10, ),
          child: Loading(loadingMessage: response.data.message),
        );
      case Status.COMPLETED:
        return ListView.builder(
          itemCount: response.data?.data?.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProductListScreen.routeName,
                  arguments: ProductListScreenArguments(
                    type: 'categoryTree',
                    name: response.data?.data[index].name,
                    id: response.data?.data[index].categoryId,
                  ),
                );
              },
              child: Container(
                height: 67,
                width: 350,
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          response.data?.data[index].iconUrl ?? '',
                        ),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 2),
                          blurRadius: 5,
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: categoryListItem(response.data?.data[index], 0),
                  ),
                ),
              ),
            );
          },
        );
      case Status.ERROR:
        return Text(response.data?.message ?? '');
      default:
        return SizedBox.shrink();
    }
  }

  Widget categoryListItem(CategoryTreeResponseData item, int level) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
              FutureBuilder<PaletteGenerator>(
              future: _updatePaletteGenerator(item.iconUrl), // async work
              builder: (BuildContext context, AsyncSnapshot<PaletteGenerator> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return Center(
                      child: CircularProgressIndicator()
                  );
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else {
                      var color = snapshot.data.dominantColor.color;
                      var luminance = color.computeLuminance();

                      return Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: luminance > 0.6
                              ? Colors.black
                              : luminance > 0.5
                              ? Colors.black87
                              : luminance > 0.4
                              ? Colors.white70
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      );
                    }
                }
              }
            ),
            // if(item.subCategories?.isNotEmpty == true)
            //   IconButton(
            //     onPressed: () {
            //       // _bloc.fetchCategoryTree(item.categoryId);
            //       setState(() {
            //         item.isExpanded = !item.isExpanded;
            //       });
            //     },
            //     icon: item.isExpanded
            //         ? Icon(Icons.keyboard_arrow_down_sharp)
            //         : Icon(Icons.chevron_right),
            //   ),
          ],
        ),
        // if(item.isExpanded)
        //   ListView.builder(
        //     primary: false,
        //     shrinkWrap: true,
        //     itemCount: item.subCategories?.length ?? 0,
        //     itemBuilder: (context, index) {
        //       return categoryListItem(item.subCategories[index], level + 1);
        //     },
        //   ),
      ],
    );
  }
}
