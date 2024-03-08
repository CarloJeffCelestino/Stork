import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/estimate_shipping_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomDropdown.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/EstimateShipping.dart';
import 'package:nopcart_flutter/model/EstimateShippingResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/extensions.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class EstimateShippingDialog extends StatefulWidget {
  final EstimateShipping estimateShipping;
  final List<FormValue> formValues;
  final bool estimationForProduct;
  final String preSelectedShippingMethod;

  const EstimateShippingDialog(
      this.estimateShipping,
      this.estimationForProduct,
      this.preSelectedShippingMethod, {
        this.formValues,
        Key key,
      }) : super(key: key);

  @override
  _EstimateShippingDialogState createState() => _EstimateShippingDialogState(this.estimateShipping);
}

class _EstimateShippingDialogState extends State<EstimateShippingDialog>
    with ValidationMixin {
  EstimateShippingBloc _bloc;
  GlobalService _globalService = GlobalService();
  final EstimateShipping estimateShipping;
  final _formKey = GlobalKey<FormState>();

  _EstimateShippingDialogState(this.estimateShipping);

  @override
  void initState() {
    super.initState();
    _bloc = EstimateShippingBloc(
      estimateShipping,
      widget.estimationForProduct,
      widget.formValues ?? [],
      widget.preSelectedShippingMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: InkWell(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              child: Text(_globalService.getString(Const.ESTIMATE_SHIPPING_APPLY)),
              onPressed: () {
                Navigator.of(context).pop(_bloc.selectedMethod);
              },
            ),
          )
        ],
        title: Text('${_globalService.getString(Const.ESTIMATE_SHIPPING_TITLE)}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Country Dropdown
                CustomDropdown<AvailableOption>(
                  onChanged: (country) {
                    estimateShipping.countryId = int.tryParse(country.value) ?? -1;
                    _bloc.fetchStates(country);
                  },
                  onSaved: (newValue) {
                    estimateShipping.countryId = int.tryParse(newValue.value) ?? -1;
                  },
                  validator: (value) {
                    if(value == null || value.value == '0')
                      return _globalService.getString(Const.COUNTRY_REQUIRED);
                    return null;
                  },
                  preSelectedItem: estimateShipping.availableCountries.safeFirstWhere(
                        (element) => element.selected ?? false,
                    orElse: () => estimateShipping.availableCountries?.safeFirst(),
                  ),
                  items: estimateShipping.availableCountries
                      ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                      DropdownMenuItem<AvailableOption>(
                          value: e, child: Text(e.text)))
                      ?.toList() ??
                      List.empty(),
                ),

                // States Dropdown
                StreamBuilder<ApiResponse<List<AvailableOption>>>(
                    stream: _bloc.statesStream,
                    builder: (context, snapshot) {

                      if(snapshot.hasData && snapshot.data.status == Status.COMPLETED) {
                        var statesList = snapshot.data?.data ?? [];
                        return CustomDropdown<AvailableOption>(
                          onChanged: (value) {
                            estimateShipping.stateProvinceId = int.tryParse(value.value) ?? -1;
                          },
                          onSaved: (newValue) {
                            estimateShipping.stateProvinceId = int.tryParse(newValue.value) ?? -1;
                          },
                          validator: (value) {
                            if(value == null || value.value == '-1')
                              return _globalService.getString(Const.STATE_REQUIRED);
                            return null;
                          },
                          preSelectedItem: statesList.safeFirstWhere(
                                (element) => element.selected ?? false,
                            orElse: () => statesList.safeFirst(),
                          ),
                          items: statesList
                              ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                              DropdownMenuItem<AvailableOption>(
                                  value: e, child: Text(e.text)))
                              ?.toList() ??
                              List.empty(),
                        );
                      } else {
                        return CircularProgressIndicator(
                          strokeWidth: 3,
                        );
                      }
                    }
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    autofocus: false,
                    initialValue: estimateShipping.useCity
                        ? estimateShipping.city ?? ''
                        : estimateShipping.zipPostalCode ?? '',
                    textInputAction: TextInputAction.next,
                    decoration: inputDecor(
                        estimateShipping.useCity
                            ? _globalService.getString(Const.CITY)
                            : _globalService.getString(Const.ESTIMATE_SHIPPING_ZIP),
                        false),
                    onSaved: (newValue) {
                      if(estimateShipping.useCity) {
                        estimateShipping.city = newValue;
                      } else {
                        estimateShipping.zipPostalCode = newValue;
                      }
                    },
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return _globalService.getString(
                            estimateShipping.useCity ? Const.CITY : Const.ZIP_REQUIRED
                        );
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 5),

                OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (widget.estimationForProduct) {
                        _bloc.estimateShippingForProduct(
                          estimateShipping,
                          widget.formValues,
                        );
                      } else {
                        _bloc.estimateShippingForCart(estimateShipping);
                      }
                    }
                    removeFocusFromInputField(context);
                  },
                  child: Text(_globalService.getString(Const.CART_ESTIMATE_SHIPPING_BTN)),
                ),

                SizedBox(height: 5),

                StreamBuilder<ApiResponse<EstimateShippingData>>(
                    stream: _bloc.resultStream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        if(snapshot.data.status == Status.COMPLETED) {
                          var options = snapshot.data.data.shippingOptions ?? [];

                          if(options.isEmpty)
                            return Text(_globalService.getString(Const.ESTIMATE_SHIPPING_NO_OPTION));
                          else {
                            return ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: options?.length != null ? options.length - 1 : 0,
                                itemBuilder: (context, index) {
                                  final optionIndex = index + 0;
                                  return CheckboxListTile(
                                    title: Text('${options[optionIndex].name ?? ''} (${options[optionIndex].price ?? ''})'),
                                    subtitle: Text(options[optionIndex].description ?? ''),
                                    value: _bloc.selectedMethod == _bloc.getMethodId(options[optionIndex]),
                                    onChanged: (bool value) {
                                      setState(() {
                                        _bloc.selectedMethod = _bloc.getMethodId(options[optionIndex]);
                                      });
                                    },
                                  );
                                });
                          }

                        } else if(snapshot.data.status == Status.LOADING) {
                          return CircularProgressIndicator();
                        } else { // error
                          return Text(snapshot.data.message);
                        }
                      } else {
                        return Text(_globalService.getString(Const.ESTIMATE_SHIPPING_NO_OPTION));
                      }
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
