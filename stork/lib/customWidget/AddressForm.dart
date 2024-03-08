import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/CustomDropdown.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/CustomAttributeManager.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';

class AddressForm extends StatelessWidget with ValidationMixin {
  final Address address;
  final AvailableOption preselectedCountry, preselectedState;
  final void Function(AvailableOption value, bool isCountry) onDropdownItemSelected;
  final GlobalService _globalService = GlobalService();
  final CustomAttributeManager attributeManager;

  AddressForm(
      {@required Key key,
      @required this.address,
      this.preselectedCountry,
      this.preselectedState,
      @required this.onDropdownItemSelected,
      @required this.attributeManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tfFirstName = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        return (value == null || value.isEmpty)
            ? _globalService.getString(Const.FIRST_NAME)
            : null;
      },
      onChanged: (value) => address.firstName = value,
      initialValue: address.firstName,
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
      onChanged: (value) => address.lastName = value,
      initialValue: address.lastName,
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
      onChanged: (value) => address.email = value,
      initialValue: address.email,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.EMAIL, true),
    );

    final tfCompany = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (address.companyEnabled &&
            address.companyRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.COMPANY);
        }
        return null;
      },
      onChanged: (value) => address.company = value,
      initialValue: address.company,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(
          Const.COMPANY, address.companyEnabled && address.companyRequired),
    );

    final tfStreet1 = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (address.streetAddressEnabled &&
            address.streetAddressRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.STREET_ADDRESS);
        }
        return null;
      },
      onChanged: (value) => address.address1 = value,
      initialValue: address.address1,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.STREET_ADDRESS,
          address.streetAddressEnabled && address.streetAddressRequired),
    );

    final tfStreet2 = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (address.streetAddress2Enabled &&
            address.streetAddress2Required &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.STREET_ADDRESS_2);
        }
        return null;
      },
      onChanged: (value) => address.address2 = value,
      initialValue: address.address2,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.STREET_ADDRESS_2,
          address.streetAddress2Enabled && address.streetAddress2Required),
    );

    final tfZip = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (value) {
        if (address.zipPostalCodeEnabled &&
            address.zipPostalCodeRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.ZIP_CODE);
        }
        return null;
      },
      onChanged: (value) => address.zipPostalCode = value,
      initialValue: address.zipPostalCode,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.ZIP_CODE,
          address.zipPostalCodeEnabled && address.zipPostalCodeRequired),
    );

    final tfCounty = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (address.countyEnabled &&
            address.countyRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.ADDRESS_COUNTY);
        }
        return null;
      },
      onChanged: (value) => address.county = value,
      initialValue: address.county,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.ADDRESS_COUNTY,
          address.countyEnabled && address.countyRequired),
    );

    final tfCity = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (address.cityEnabled &&
            address.cityRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.CITY);
        }
        return null;
      },
      onChanged: (value) => address.city = value,
      initialValue: address.city,
      textInputAction: TextInputAction.next,
      decoration:
      inputDecor(Const.CITY, address.cityEnabled && address.cityRequired),
    );

    final tfPhone = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (address.phoneEnabled &&
            address.phoneRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.PHONE);
        }
        return null;
      },
      onChanged: (value) => address.phoneNumber = value,
      initialValue: address.phoneNumber,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(
          Const.PHONE, address.phoneEnabled && address.phoneRequired),
    );

    final tfFax = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (address.faxEnabled &&
            address.faxRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.FAX);
        }
        return null;
      },
      onChanged: (value) => address.faxNumber = value,
      initialValue: address.faxNumber,
      textInputAction: TextInputAction.next,
      decoration:
      inputDecor(Const.FAX, address.faxEnabled && address.faxRequired),
    );

    return Form(
      key: key,
      child: Column(
        children: [
          SizedBox(height: 10),
          tfFirstName,
          tfLastName,
          tfEmail,
          if (address.countryEnabled) getCountryDropdown(address),
          if (address.stateProvinceEnabled) getStatesDropdown(address),
          if (address.phoneEnabled) tfPhone,
          if (address.faxEnabled) tfFax,
          if (address.streetAddressEnabled) tfStreet1,
          if (address.streetAddress2Enabled) tfStreet2,
          if (address.zipPostalCodeEnabled) tfZip,
          if (address.countyEnabled) tfCounty,
          if (address.cityEnabled) tfCity,
          if (address.companyEnabled) tfCompany,
          attributeManager.populateCustomAttributes(address.customAddressAttributes),
        ],
      ),
    );
  }

  getCountryDropdown(Address formData) {

    return CustomDropdown(
      preSelectedItem: preselectedCountry,
      items: formData.availableCountries?.map<DropdownMenuItem<AvailableOption>>((AvailableOption value) {
        return DropdownMenuItem<AvailableOption>(
          value: value,
          child: Text(value.text ?? ''),
        );
      })?.toList() ?? [],
      onChanged: (value) => onDropdownItemSelected(value, true),
      onSaved: (value) {
        formData.countryId = int.tryParse(value.value) ?? 0;

        address.countryId = int.tryParse(value.value) ?? 0;
      },
      validator: (value) {
        if(formData.countryEnabled && (value == null || value.value == '0'))
          return _globalService.getString(Const.COUNTRY_REQUIRED);
        return null;
      },
    );
  }

  getStatesDropdown(Address formData) {
    return CustomDropdown(
      preSelectedItem: preselectedState,
      items: formData.availableStates?.map<DropdownMenuItem<AvailableOption>>((AvailableOption value) {
        return DropdownMenuItem<AvailableOption>(
          value: value,
          child: Text(value.text ?? ''),
        );
      })?.toList() ?? [],
      onChanged: (value) => onDropdownItemSelected(value, false),
      onSaved: (value) {
        formData.stateProvinceId = int.tryParse(value.value) ?? 0;
      },
      validator: (value) {
        if(formData.stateProvinceEnabled && value == null)
          return _globalService.getString(Const.STATE_REQUIRED);
        return null;
      },
    );
  }
}
