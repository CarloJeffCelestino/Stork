import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/address_bloc.dart';
import 'package:nopcart_flutter/customWidget/AddressForm.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/CustomAttributeManager.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';

class AddOrEditAddressScreen extends StatefulWidget {
  static const routeName = '/address-add-edit';
  final AddOrEditAddressScreenArgs args;

  const AddOrEditAddressScreen({Key key, @required this.args}) : super(key: key);

  @override
  _AddOrEditAddressScreenState createState() => _AddOrEditAddressScreenState(args);
}

class _AddOrEditAddressScreenState extends State<AddOrEditAddressScreen> {
  final AddOrEditAddressScreenArgs args;
  GlobalService _globalService = GlobalService();
  AddressBloc _bloc;
  CustomAttributeManager attributeManager;
  final _addressFormKey = GlobalKey<FormState>();

  _AddOrEditAddressScreenState(this.args);

  @override
  void initState() {
    super.initState();
    _bloc = AddressBloc();

    if(args.isEditMode) {
      _bloc.fetchExistingAddress(args.addressId);
    } else {
      _bloc.fetchNewAddressForm();
    }

    _bloc.statesListStream.listen((event) {
      if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    _bloc.saveAddressStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if(event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if(event?.data?.message?.isNotEmpty == true) {
          showSnackBar(context, event.data.message, false);
          Navigator.of(context).pop(AppConstants.keyRefreshContent);
        }
      } else {
        DialogBuilder(context).hideLoader();
        if(event.message?.isNotEmpty == true)
          showSnackBar(context, event.message, true);
      }
    });

    attributeManager = CustomAttributeManager(
      context: context,
      onClick: (priceAdjNeeded) {
        setState(() {
          // updating UI to show selected attribute values
        });
      },
    );
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
        title: Text(_globalService.getString(Const.ACCOUNT_CUSTOMER_ADDRESS)),
      ),
      body: StreamBuilder<ApiResponse<Address>>(
        stream: _bloc.addressStream,
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
                  onRetryPressed: () {
                    if(args.isEditMode) {
                      _bloc.fetchExistingAddress(args.addressId);
                    } else {
                      _bloc.fetchNewAddressForm();
                    }
                  },
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(Address data) {

    var btnSave = CustomButton(
      label: _globalService.getString(Const.SAVE_BUTTON).toUpperCase(),
      onClick: () {

        removeFocusFromInputField(context);

        String errMsg = attributeManager.checkRequiredAttributes(data.customAddressAttributes);
        if(errMsg.isNotEmpty) {
          showSnackBar(context, errMsg, true);
        } else {
          if (_addressFormKey.currentState.validate()) {
            _addressFormKey.currentState.save();

            if (args.isEditMode) {
              _bloc.editAddress(
                args.addressId,
                data,
                attributeManager.getSelectedAttributes(AppConstants.addressAttributePrefix),
              );
            } else {
              _bloc.saveNewAddress(
                data,
                attributeManager.getSelectedAttributes(AppConstants.addressAttributePrefix),
              );
            }
          }
        }
      },
      shape: ButtonShape.RoundedTop,
    );

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AddressForm(
                  key: _addressFormKey,
                  address: data,
                  onDropdownItemSelected: (value, isCountry) {
                    if(isCountry) {
                      // load state
                      _bloc.selectedCountry = value;
                      _bloc.fetchStatesByCountryId(int.tryParse(value.value) ?? -1);
                    } else {
                      _bloc.selectedState = value;
                    }
                  },
                  preselectedCountry: _bloc.selectedCountry,
                  preselectedState: _bloc.selectedState,
                  attributeManager: attributeManager,
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: btnSave,
        )
      ],
    );
  }
}

class AddOrEditAddressScreenArgs {
  final bool isEditMode;
  final num addressId;

  AddOrEditAddressScreenArgs({@required this.isEditMode, @required this.addressId});
}
