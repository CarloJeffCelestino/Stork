import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/return_request_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/ReturnRequestHistoryResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:permission_handler/permission_handler.dart';

class ReturnRequestHistoryScreen extends StatefulWidget {
  static String routeName = '/return-request-history';
  const ReturnRequestHistoryScreen({Key key}) : super(key: key);

  @override
  _ReturnRequestHistoryScreenState createState() => _ReturnRequestHistoryScreenState();
}

class _ReturnRequestHistoryScreenState extends State<ReturnRequestHistoryScreen> {
  GlobalService _globalService = GlobalService();
  ReturnRequestBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ReturnRequestBloc();
    _bloc.fetchReturnRequestHistory();

    _bloc.fileDownloadStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if(event.data.file != null) {
          showSnackBar(context, _globalService.getString(Const.FILE_DOWNLOADED), false);
        } else if(event.data.jsonResponse.data.downloadUrl != null) {
          launchUrl(event.data.jsonResponse.data.downloadUrl);
        }

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
        title: Text(_globalService.getString(Const.ACCOUNT_RETURN_REQUESTS)),
      ),
      body: StreamBuilder<ApiResponse<ReturnReqHistoryData>>(
        stream: _bloc.historyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () =>
                      _bloc.fetchReturnRequestHistory(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(ReturnReqHistoryData data) {
    return ListView.builder(
      itemCount: data?.items?.length ?? 0,
      itemBuilder: (context, index) {
        var item = data.items[index];
        var title = _globalService
            .getString(Const.RETURN_ID)
            .replaceAll('{0}', item.id.toString())
            .replaceAll('{1}', item.returnRequestStatus);
        var subtitle = '${_globalService.getString(Const.RETURNED_ITEM)} ${item.productName} * ${item.quantity}\n'
            '${_globalService.getString(Const.RETURN_REASON)} ${item.returnReason}\n'
            '${_globalService.getString(Const.RETURN_ACTION)}: ${item.returnAction}\n'
            '${_globalService.getString(Const.RETURN_DATE_REQUESTED)} ${getFormattedDate(item.createdOn)}';

        return Card(
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 9,
                      child: Text(title),
                    ),
                    if(item.uploadedFileGuid != null && item.uploadedFileGuid != '00000000-0000-0000-0000-000000000000')
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            var status = await Permission.storage.status;
                            if (!status.isGranted) {
                              await Permission.storage
                                  .request()
                                  .then((value) => {
                                        if (value.isGranted) {
                                          _bloc.downloadFile(
                                              item.uploadedFileGuid)
                                        }
                                      });
                            } else {
                              _bloc.downloadFile(item.uploadedFileGuid);
                            }
                          },
                          child: Icon(Icons.download_sharp),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 5.0,),
              ],
            ),
            subtitle: Text(subtitle),
            onTap: () => Navigator.of(context).pushNamed(
                ProductDetailsPage.routeName,
                arguments: ProductDetailsScreenArguments(
                  id: item.productId, name: item.productName,
                )
            ),
          ),
        );
      },
    );
  }
}
