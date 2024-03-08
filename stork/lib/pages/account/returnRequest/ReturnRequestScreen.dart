import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/return_request_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/CustomDropdown.dart';
import 'package:nopcart_flutter/customWidget/RoundButton.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/ReturnRequestResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ReturnRequestScreen extends StatefulWidget {
  static String routeName = '/return-request-form';
  final ReturnRequestScreenArgs args;
  const ReturnRequestScreen({Key key, @required this.args}) : super(key: key);

  @override
  _ReturnRequestScreenState createState() => _ReturnRequestScreenState();
}

class _ReturnRequestScreenState extends State<ReturnRequestScreen>
  with ValidationMixin {
  GlobalService _globalService = GlobalService();
  ReturnRequestBloc _bloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = ReturnRequestBloc();
    _bloc.fetchReturnRequestFormData(widget.args.orderId);

    _bloc.messageStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if(event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if(event.data?.isNotEmpty == true) {
          showSnackBar(context, event.data, false);
        }

        // refresh previous screen
        Navigator.of(context).pop(true);
      } else {
        DialogBuilder(context).hideLoader();
        if(event.message?.isNotEmpty == true)
          showSnackBar(context, event.message, true);
      }
    });

    _bloc.fileUploadStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        _bloc.fileGuid = event.data.downloadGuid ?? '';
        showSnackBar(context, _globalService.getString(Const.COMMON_DONE), false);
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
        title: Text(_globalService.getString(Const.ORDER_RETURN_ITEMS)),
      ),
      body: StreamBuilder<ApiResponse<ReturnRequestData>>(
        stream: _bloc.formStream,
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
                      _bloc.fetchReturnRequestFormData(widget.args.orderId),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(ReturnRequestData data) {
    var btnSubmit = CustomButton(
        label: _globalService
            .getString(Const.RETURN_REQ_SUBMIT)
            .toUpperCase(),
        shape: ButtonShape.RoundedTop,
        onClick: () {
          if (_formKey.currentState.validate())
            _bloc.submitForm(data);
        });

    return Form(
      key: _formKey,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: defaultPadding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_globalService.getString(Const.RETURN_REQ_TITLE_WHICH_ITEM)),
                  SizedBox(height: 10),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: data.items?.length ?? 0,
                    itemBuilder: (context, index) {
                      return listItem(data.items[index]);
                    },
                  ),
                  SizedBox(height: 10),
                  Text(_globalService.getString(Const.RETURN_REQ_TITLE_WHY)),
                  CustomDropdown<AvailableReturn>(
                    preSelectedItem: _bloc.selectedReason,
                    items: data.availableReturnReasons?.map<DropdownMenuItem<AvailableReturn>>((AvailableReturn value) {
                      return DropdownMenuItem<AvailableReturn>(
                        value: value,
                        child: Text(value.name ?? ''),
                      );
                    })?.toList() ?? [],
                    onChanged: (value) {},
                    onSaved: (value) {
                      data.returnRequestReasonId = value.id ?? 0;
                    },
                    validator: (value) {
                      if(value.id == -1)
                        return _globalService.getString(Const.RETURN_REQ_REASON);
                      return null;
                    },
                  ),
                  CustomDropdown<AvailableReturn>(
                    preSelectedItem: _bloc.selectedAction,
                    items: data.availableReturnActions?.map<DropdownMenuItem<AvailableReturn>>((AvailableReturn value) {
                      return DropdownMenuItem<AvailableReturn>(
                        value: value,
                        child: Text(value.name ?? ''),
                      );
                    })?.toList() ?? [],
                    onChanged: (value) {},
                    onSaved: (value) {
                      data.returnRequestActionId = value.id ?? 0;
                    },
                    validator: (value) {
                      if(value.id == -1)
                        return _globalService.getString(Const.RETURN_REQ_ACTION);
                      return null;
                    },
                  ),
                  if(data.allowFiles)
                    ...[
                      Text(_globalService.getString(Const.RETURN_REQ_UPLOAD)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              FilePickerResult result = await FilePicker.platform.pickFiles();

                              if(result != null) {
                                PlatformFile file = result.files.single;

                                // update UI
                                setState(() {
                                  _bloc.selectedFileName = file.name;
                                });

                                _bloc.uploadFile(file.path);
                              }
                            },
                            child: Text(
                                _globalService.getString(Const.RETURN_REQ_UPLOAD_FILE)),
                          ),
                          SizedBox(width: 10),
                          if(_bloc.selectedFileName.isNotEmpty)
                            Flexible(
                            child: Text(
                              _bloc.selectedFileName,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontSize: 14),
                            ),
                          )
                      ],
                      )
                    ],
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 2,
                    autofocus: false,
                    validator: (value) => null,
                    onChanged: (value) => data.comments = value,
                    initialValue: data.comments ?? '',
                    textInputAction: TextInputAction.done,
                    decoration: inputDecor(Const.RETURN_REQ_COMMENTS, false),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [Expanded(child: btnSubmit)],
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem(ReturnRequestProduct item) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        title: Text('${item.productName}\n${item.unitPrice}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(_globalService.getString(Const.RETURN_REQ_RETURN_QTY)),
            SizedBox(height: 10),
            Row(
              children: [
                RoundButton(
                  icon: Icon(
                    Icons.remove,
                    size: 18.0,
                  ),
                  radius: 35,
                  onClick: () {
                    setState(() {
                      if (_bloc.quantityMap[item.id] > 0)
                        _bloc.quantityMap[item.id] = _bloc.quantityMap[item.id] - 1;
                    });
                  },
                ),
                SizedBox(width: 15),
                Text('${_bloc.quantityMap[item.id]}'),
                SizedBox(width: 15),
                RoundButton(
                  icon: Icon(
                    Icons.add,
                    size: 18.0,
                  ),
                  radius: 35,
                  onClick: () {
                    setState(() {
                      if(_bloc.quantityMap[item.id] < item.quantity) {
                        _bloc.quantityMap[item.id] = _bloc.quantityMap[item.id] + 1;
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ReturnRequestScreenArgs {
  final num orderId;

  ReturnRequestScreenArgs(this.orderId);
}
