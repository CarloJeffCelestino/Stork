import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/downloadable_prod_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/DownloadableProductResponse.dart';
import 'package:nopcart_flutter/model/UserAgreementResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadableProductScreen extends StatefulWidget {
  static const routeName = '/downloadable-product';

  const DownloadableProductScreen({Key key}) : super(key: key);

  @override
  _DownloadableProductScreenState createState() => _DownloadableProductScreenState();
}

class _DownloadableProductScreenState extends State<DownloadableProductScreen> {
  DownloadableProductBloc _bloc;
  GlobalService _globalService = GlobalService();

  _DownloadableProductScreenState();

  @override
  void initState() {
    super.initState();
    _bloc = DownloadableProductBloc();
    _bloc.fetchDownloadableProducts();

    _bloc.sampleDownloadStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if(event.data.file != null) {
          showSnackBar(context, _globalService.getString(Const.FILE_DOWNLOADED), false);
        } else if(event.data.jsonResponse?.data?.downloadUrl != null) {
          launchUrl(event.data.jsonResponse.data.downloadUrl);
        }
        // hasUseAgreement is handled inside bloc

      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.agreementStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        showUserAgreementDialog(event.data);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(_globalService.getString(Const.ACCOUNT_DOWNLOADABLE_PRODUCTS)),
      ),
      body: StreamBuilder<ApiResponse<DownloadableProductData>>(
        stream: _bloc.productStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data?.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchDownloadableProducts(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(DownloadableProductData data) {
    if(data == null)
      return SizedBox.shrink();

    return Stack(
      children: [
        ListView.builder(
          itemCount: (data.items?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (index < data.items?.length ?? 0) {
              return listItem(data.items[index]);
            } else {
              return SizedBox(height: 50);
            }
          },
        ),

        if(data.items?.isEmpty == true)
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _globalService.getString(Const.COMMON_NO_DATA),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget listItem(DownloadableProductItem item) {

    return Card(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 9,
                child: Text(
                  item.productName ?? '',
                ),
              ),
              if (item.downloadId != null && item.downloadId != 0)
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      var status = await Permission.storage.status;
                      if (!status.isGranted) {
                        await Permission.storage.request().then((value) => {
                          if (value.isGranted) {_bloc.downloadFile(item.orderItemGuid ?? '', 'null')}
                        });
                      } else {
                        _bloc.downloadFile(item.orderItemGuid ?? '', 'null');
                      }
                    },
                    child: Icon(Icons.download_rounded),
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_globalService.getString(Const.ORDER_NUMBER)}: ${item.customOrderNumber ?? ''}'),
              Text('${_globalService.getString(Const.ORDER_DATE)}: ${getFormattedDate(item.createdOn)}'),
            ],
          ),
        ),
      ),
    );
  }

  void showUserAgreementDialog(UserAgreementData data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_globalService.getString(Const.DOWNLOADABLE_USER_AGREEMENT)),
          content: Text(data?.userAgreementText ?? ''),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _bloc.downloadFile(data?.orderItemGuid ?? '', 'true');
                },
                child: Text(_globalService.getString(Const.DOWNLOADABLE_I_AGREE))
            ),
          ],
        );
      },
    );
  }
}
