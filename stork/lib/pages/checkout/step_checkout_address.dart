import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/checkout_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/CustomDropdown.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/SaveBillingResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/address/add_edit_address_screen.dart';
import 'package:nopcart_flutter/pages/account/address/address_list_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/CustomAttributeManager.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/extensions.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class StepCheckoutAddress extends StatefulWidget {
  final GetBillingData billingData;
  final CheckoutBloc bloc;
  final ShippingAddressModel shippingAddress;

  StepCheckoutAddress(Key key, this.bloc, {this.billingData, this.shippingAddress}) : super(key: key);

  @override
  _StepCheckoutAddressState createState() =>
      _StepCheckoutAddressState(bloc: bloc, billingData: billingData, shippingAddress: shippingAddress);
}

class _StepCheckoutAddressState extends State<StepCheckoutAddress>
    with ValidationMixin {

  GlobalService _globalService = GlobalService();
  final GetBillingData billingData;
  final ShippingAddressModel shippingAddress;
  final CheckoutBloc bloc;
  CustomAttributeManager attributeManager;
  bool isBilling;
  GlobalKey<FormState> _formKey;
  final _billingFormKey = GlobalKey<FormState>();
  final _shippingFormKey = GlobalKey<FormState>();

  var isSelected = [true, false];

  _StepCheckoutAddressState({this.bloc, this.billingData, this.shippingAddress}) {
    isBilling = billingData != null;
    _formKey = isBilling ? _billingFormKey : _shippingFormKey;
  }

  @override
  void initState() {
    super.initState();

    /*if (billingData?.disableBillingAddressCheckoutStep == true &&
        billingData?.billingAddress?.existingAddresses?.isNotEmpty == true) {
      // TODO save first billing address & goto save shipping step
    } else {
    }*/

    if(!isBilling) {
      bloc.existingShippingAddress = [...shippingAddress.existingAddresses];
      bloc.existingShippingAddress.add(Address(
        id: -1,
      )); // New address option to show on dropdown menu

      bloc.showNewShippingAddress = shippingAddress?.existingAddresses?.isEmpty == true;
      bloc.storePickup = false;
      bloc.selectedExistingShippingAddress = shippingAddress?.existingAddresses?.isNotEmpty == true ?
      bloc.selectedExistingShippingAddress != null ? bloc.selectedExistingShippingAddress : shippingAddress?.existingAddresses?.first : null;

      bloc.pickupPointAddress = [...shippingAddress?.pickupPointsModel?.pickupPoints ?? []];
      bloc.selectedPickupAddress = shippingAddress?.pickupPointsModel?.pickupPoints?.isNotEmpty == true ?
          shippingAddress?.pickupPointsModel?.pickupPoints?.first : null;

      bloc.selectedCountry = shippingAddress.shippingNewAddress?.availableCountries?.safeFirst();
    }

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
  Widget build(BuildContext context) {
    isSelected[0] = billingData!=null;
    isSelected[1] = shippingAddress!=null;

    Future.delayed(Duration.zero, () {
      if((bloc.selectedExistingBillingAddress?.id ?? -1) !=-1) {
        bloc.saveBillingAddress(newAddress: false);
      } else {
        // form validation
          if (_formKey.currentState == null) {
            Navigator.of(context).popAndPushNamed(
              AddOrEditAddressScreen.routeName,
              arguments: AddOrEditAddressScreenArgs(isEditMode: false, addressId: -1),
            );

            // showSnackBar(context, '', isError);
            // Navigator.of(context).pop();


          } else if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          String errMsg = attributeManager.checkRequiredAttributes(
              billingData.billingAddress.billingNewAddress.customAddressAttributes
          );
          if(errMsg.isNotEmpty) {
            showSnackBar(context, errMsg, true);
          } else {
            bloc.saveBillingAddress(
              newAddress: true,
              address: billingData.billingAddress.billingNewAddress,
              formValue: attributeManager.getSelectedAttributes('address_attribute'),
            );
          }
        }
      }
    });

    var topButtons = Container(
      child: ToggleButtons(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
                child:
                Text(_globalService.getString(Const.BILLING_ADDRESS_TAB))),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
                child:
                Text(_globalService.getString(Const.SHIPPING_ADDRESS_TAB))),
          ),
        ],
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
            buttonIndex < isSelected.length;
            buttonIndex++) {
              if (buttonIndex == index) {
                isSelected[buttonIndex] = true;
              } else {
                isSelected[buttonIndex] = false;
              }
            }
            // set current step
            switch (index) {
              case 0:
                break;
              case 1:
                break;
            }
          });
        },
        isSelected: isSelected,
        textStyle: TextStyle(fontSize: 15),
        color: Styles.textColor(context),
        selectedColor: Theme.of(context).primaryColor,
        fillColor: isDarkThemeEnabled(context) ? Colors.grey[800] : Colors.grey[100],
        renderBorder: false,
      ),
      decoration: BoxDecoration(
        color: isDarkThemeEnabled(context) ? Colors.grey[800] : Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: isDarkThemeEnabled(context) ? Colors.grey[800] : Colors.grey[300],
            blurRadius: 8,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
    );

    Widget temp;

    // TODO save first billing address & goto save shipping step
    // billingData.disableBillingAddressCheckoutStep == true &&
    //     billingData.billingAddress?.existingAddresses?.isNotEmpty == true

    if (isBilling) {
      temp = SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (billingData?.billingAddress?.shipToSameAddressAllowed == true)
                CheckboxListTile(
                  value: bloc.shipToSameAddress,
                  title: Text(_globalService.getString(Const.SHIP_TO_SAME_ADDRESS)),
                  onChanged: (bool isSelected) { setState(() {
                    bloc.shipToSameAddress = isSelected;
                  }); },
                ),
              billingAddressDropDown(),
              if (bloc.showNewBillingAddress)
                newAddressForm(billingData.billingAddress.billingNewAddress),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: CustomButton(
                    label: _globalService.getString(Const.CONTINUE).toUpperCase(),
                    onClick: () {
                      if((bloc.selectedExistingBillingAddress?.id ?? -1) !=-1) {
                        bloc.saveBillingAddress(newAddress: false);
                      } else {
                        // form validation
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          String errMsg = attributeManager.checkRequiredAttributes(
                              billingData.billingAddress.billingNewAddress.customAddressAttributes
                          );
                          if(errMsg.isNotEmpty) {
                            showSnackBar(context, errMsg, true);
                          } else {
                            bloc.saveBillingAddress(
                                newAddress: true,
                                address: billingData.billingAddress.billingNewAddress,
                                formValue: attributeManager.getSelectedAttributes('address_attribute'),
                            );
                          }
                        }
                      }
                    },
                  )),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    } else {
      temp = SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (shippingAddress?.displayPickupInStore == true &&
                  shippingAddress?.pickupPointsModel?.allowPickupInStore ==
                      true)
                CheckboxListTile(
                  value: bloc.storePickup,
                  title: Text(_globalService.getString(Const.CHECKOUT_PICKUP_FROM_STORE)),
                  onChanged: (bool isSelected) { setState(() {
                    bloc.storePickup = isSelected;
                    if (isSelected)
                      bloc.showNewShippingAddress = false;
                  }); },
                ),
              bloc.storePickup ? pickupPointDropDown() : shippingAddressDropDown(),
              if (bloc.showNewShippingAddress)
                newAddressForm(shippingAddress?.shippingNewAddress),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: CustomButton(
                    label: _globalService.getString(Const.CONTINUE).toUpperCase(),
                    onClick: () {
                      if(!bloc.storePickup &&
                          (bloc.selectedExistingShippingAddress?.id ?? -1) ==-1) {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          String errMsg = attributeManager.checkRequiredAttributes(
                              shippingAddress.shippingNewAddress.customAddressAttributes
                          );
                          if(errMsg.isNotEmpty) {
                            showSnackBar(context, errMsg, true);
                          } else {
                            bloc.saveShippingAddress(
                              isNewAddress: true,
                              address: shippingAddress.shippingNewAddress,
                              formValue: attributeManager.getSelectedAttributes('address_attribute'),
                            );
                          }
                        }
                      } else {
                        bloc.saveShippingAddress(
                          isNewAddress: false,
                        );
                      }
                    },
                  )),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    }

    return Visibility(
      child: Column(
        children: [
          topButtons,
          temp,
        ],
      ),
      visible: false,
    );
  }

  Widget billingAddressDropDown() {

    return CustomDropdown<Address>(
      preSelectedItem: bloc.existingBillingAddress[0],
      items:bloc.existingBillingAddress.map<DropdownMenuItem<Address>>((Address value) {
        return DropdownMenuItem<Address>(
          value: value,
          child: value.id == -1
              ? Text(_globalService.getString(Const.NEW_ADDRESS))
              : Text(
                  '${value.firstName ?? ''} ${value.lastName ?? ''}, ${value.city ?? ''} ${value.countryName ?? ''}'.trim(),
                  overflow: TextOverflow.ellipsis,
                ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          bloc.showNewBillingAddress = value.id == -1;
          if(bloc.selectedExistingBillingAddress == null)
            bloc.selectedExistingBillingAddress = value;
        });
      },
    );
  }

  Widget shippingAddressDropDown() {
    return CustomDropdown<Address>(
      preSelectedItem: bloc.existingShippingAddress.safeFirst(),
      items: bloc?.existingShippingAddress?.map<DropdownMenuItem<Address>>((Address value) {
        return DropdownMenuItem<Address>(
          value: value,
          child: value.id == -1
                  ? Text(_globalService.getString(Const.NEW_ADDRESS))
                  : Text(
                      '${value.firstName ?? ''} ${value.lastName ?? ''}, ${value.email ?? ''}'.trim(),
                      overflow: TextOverflow.ellipsis,
                    ),
            );
      })?.toList() ?? [],
      onChanged: (value) {
        setState(() {
          bloc.showNewShippingAddress = value.id == -1;
          if(bloc.selectedExistingShippingAddress == null)
            bloc.selectedExistingShippingAddress = value;
        });
      },
      validator: (value) {
        /*if (formData.countyEnabled && (value == null || value.value == '0'))
          return _globalService.getString(Const.COUNTRY_REQUIRED);*/
        return null;
      },
      onSaved: (newValue) {
        /*_bloc.selectedCountry = newValue;
        formData.countryId = int.tryParse(newValue.value);*/
      },
    );
  }

  Widget pickupPointDropDown() {
    return CustomDropdown<PickupPoint>(
      preSelectedItem: bloc.pickupPointAddress?.safeFirst(),
      items: bloc?.pickupPointAddress
              ?.map<DropdownMenuItem<PickupPoint>>((PickupPoint value) {
            return DropdownMenuItem<PickupPoint>(
              value: value,
              child: Text(
                '${value.name ?? ''}, ${value.address ?? ''}, ${value.city ?? ''} ${value.countryName ?? ''}'.trim(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          })?.toList() ??
          [],
      onChanged: (value) {
        setState(() {
          bloc.selectedPickupAddress = value;
        });
      },
      onSaved: (newValue) {
        /*_bloc.selectedCountry = newValue;
        formData.countryId = int.tryParse(newValue.value);*/
      },
      validator: (value) {
        /*if (formData.countyEnabled && (value == null || value.value == '0'))
          return _globalService.getString(Const.COUNTRY_REQUIRED);*/
        return null;
      },
    );
  }

  Widget newAddressForm(Address formData) {
    final tfFirstName = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        return (value == null || value.isEmpty)
            ? _globalService.getString(Const.FIRST_NAME)
            : null;
      },
      onChanged: (value) => formData.firstName = value,
      initialValue: formData.firstName,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.FIRST_NAME, true),
    );

    final tfLastName = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        return (value == null || value.isEmpty)
            ? _globalService.getString(Const.LAST_NAME)
            : null;
      },
      onChanged: (value) => formData.lastName = value,
      initialValue: formData.lastName,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.LAST_NAME, true),
    );

    final tfEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty || !isValidEmailAddress(value)) {
          return _globalService.getString(Const.EMAIL);
        }
        return null;
      },
      onChanged: (value) => formData.email = value,
      initialValue: formData.email,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.EMAIL, true),
    );

    final tfCompany = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.companyEnabled &&
            formData.companyRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.COMPANY);
        }
        return null;
      },
      onChanged: (value) => formData.company = value,
      initialValue: formData.company,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(
          Const.COMPANY, formData.companyEnabled && formData.companyRequired),
    );

    final tfStreet1 = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.streetAddressEnabled &&
            formData.streetAddressRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.STREET_ADDRESS);
        }
        return null;
      },
      onChanged: (value) => formData.address1 = value,
      initialValue: formData.address1,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.STREET_ADDRESS,
          formData.streetAddressEnabled && formData.streetAddressRequired),
    );

    final tfStreet2 = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.streetAddress2Enabled &&
            formData.streetAddress2Required &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.STREET_ADDRESS_2);
        }
        return null;
      },
      onChanged: (value) => formData.address2 = value,
      initialValue: formData.address2,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.STREET_ADDRESS_2,
          formData.streetAddress2Enabled && formData.streetAddress2Required),
    );

    final tfZip = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (value) {
        if (formData.zipPostalCodeEnabled &&
            formData.zipPostalCodeRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.ZIP_CODE);
        }
        return null;
      },
      onChanged: (value) => formData.zipPostalCode = value,
      initialValue: formData.zipPostalCode,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.ZIP_CODE,
          formData.zipPostalCodeEnabled && formData.zipPostalCodeRequired),
    );

    final tfCounty = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.countyEnabled &&
            formData.countyRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.ADDRESS_COUNTY);
        }
        return null;
      },
      onChanged: (value) => formData.county = value,
      initialValue: formData.county,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.ADDRESS_COUNTY,
          formData.countyEnabled && formData.countyRequired),
    );

    final tfCity = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.cityEnabled &&
            formData.cityRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.CITY);
        }
        return null;
      },
      onChanged: (value) => formData.city = value,
      initialValue: formData.city,
      textInputAction: TextInputAction.next,
      decoration:
      inputDecor(Const.CITY, formData.cityEnabled && formData.cityRequired),
    );

    final tfPhone = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (formData.phoneEnabled &&
            formData.phoneRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.PHONE);
        }
        return null;
      },
      onChanged: (value) => formData.phoneNumber = value,
      initialValue: formData.phoneNumber,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(
          Const.PHONE, formData.phoneEnabled && formData.phoneRequired),
    );

    final tfFax = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (formData.faxEnabled &&
            formData.faxRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.FAX);
        }
        return null;
      },
      onChanged: (value) => formData.faxNumber = value,
      initialValue: formData.faxNumber,
      textInputAction: TextInputAction.next,
      decoration:
      inputDecor(Const.FAX, formData.faxEnabled && formData.faxRequired),
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          tfFirstName,
          tfLastName,
          tfEmail,
          if (formData.countryEnabled) getCountryDropdown(formData),
          if (formData.stateProvinceEnabled) getStatesDropdown(formData),
          if (formData.phoneEnabled) tfPhone,
          if (formData.faxEnabled) tfFax,
          if (formData.streetAddressEnabled) tfStreet1,
          if (formData.streetAddress2Enabled) tfStreet2,
          if (formData.zipPostalCodeEnabled) tfZip,
          if (formData.countyEnabled) tfCounty,
          if (formData.cityEnabled) tfCity,
          if (formData.companyEnabled) tfCompany,
          attributeManager.populateCustomAttributes(formData.customAddressAttributes),
        ],
      ),
    );
  }

  getCountryDropdown(Address formData) {
    return CustomDropdown<AvailableOption>(
      preSelectedItem: bloc.selectedCountry,
      items: formData.availableCountries?.map<DropdownMenuItem<AvailableOption>>((AvailableOption value) {
        return DropdownMenuItem<AvailableOption>(
          value: value,
          child: Text(value.text ?? ''),
        );
      })?.toList() ?? [],
      onChanged: (value) {
        setState(() {
          bloc.selectedCountry = value;
          formData.countryId = int.tryParse(value.value) ?? 0;
          bloc.fetchStatesByCountryId(formData.countryId);
        });
      },
      onSaved: (value) {
        formData.countryId = int.tryParse(value.value) ?? 0;
      },
      validator: (value) {
        if(formData.countryEnabled && (value == null || value.value == '0'))
          return _globalService.getString(Const.COUNTRY_REQUIRED);
        return null;
      },
    );
  }

  getStatesDropdown(Address formData) {
    return StreamBuilder<ApiResponse<List<AvailableOption>>>(
      stream: bloc.statesListStream,
      initialData: bloc.statesDropdownInitialData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return CircularProgressIndicator();
              break;
            case Status.COMPLETED:
              var list = snapshot.data.data;

              return CustomDropdown<AvailableOption>(
                preSelectedItem: list.safeFirst(),
                items: list?.map<DropdownMenuItem<AvailableOption>>((AvailableOption value) {
                  return DropdownMenuItem<AvailableOption>(
                    value: value,
                    child: Text(value.text ?? ''),
                  );
                })?.toList() ?? [],
                onChanged: (value) {
                  setState(() {
                    // bloc.selectedCountry = value;
                    formData.stateProvinceId = int.tryParse(value.value) ?? 0;
                  });
                },
                onSaved: (value) {
                  formData.stateProvinceId = int.tryParse(value.value) ?? 0;
                },
                validator: (value) {
                  if(formData.stateProvinceEnabled && value == null)
                    return _globalService.getString(Const.STATE_REQUIRED);
                  return null;
                },
              );
              break;
            case Status.ERROR:
              return SizedBox.shrink();
              break;
          }
        }
        return SizedBox.shrink();
      },
    );
  }
}
