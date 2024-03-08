import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:nopcart_flutter/bloc/barcode_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/model/ProductDetailsResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';

class BarcodeScannerScreen extends StatefulWidget {
  static const routeName = '/barcode_scanner_screen';

  const BarcodeScannerScreen({Key key}) : super(key: key);

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  GlobalService _globalService = GlobalService();
  BarcodeBloc _bloc;
  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
    _bloc = BarcodeBloc();
    scanBarcode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(_globalService.getString(Const.MORE_SCAN_BARCODE)),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => scanBarcode(),
              child: Text(_globalService.getString(Const.MORE_SCAN_BARCODE)),
            ),
            SizedBox(height: 10),
            Text(_scanBarcode),
            SizedBox(height: 10),
            StreamBuilder<ApiResponse<ProductDetails>>(
              stream: _bloc.prodDetailsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: 30,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Wrap(children: [LinearProgressIndicator()]),
                        ),
                      );
                      break;
                    case Status.COMPLETED:
                      gotoProductDetails(snapshot.data.data);

                      return SizedBox(
                        height: 30,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('${snapshot.data.data.name}'),
                        ),
                      );
                      break;
                    case Status.ERROR:
                      return SizedBox(
                        height: 30,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            snapshot.data.message,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      break;
                  }
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// go to product details screen after a little delay
  /// to avoid transaction while setting UI state
  Future<void> gotoProductDetails(ProductDetails product) async {
    await Future.delayed(Duration(milliseconds: 100), () {
      // go to product details page
      Navigator.of(context).pushNamed(
        ProductDetailsPage.routeName,
        arguments: ProductDetailsScreenArguments(
          id: product.id,
          name: product.name,
          productDetails: product,
        ),
      );
    });
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      // print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;

      if (barcodeScanRes != '-1') {
        _bloc.fetchProductByBarcode(barcodeScanRes);
      }
    });
  }
}
