import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/CustomCheckBox.dart';
import 'package:nopcart_flutter/customWidget/CustomDropdown.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/SearchResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/extensions.dart';

class AdvSearchBottomSheet extends StatelessWidget {
  final SearchData model;
  final GlobalService _globalService = GlobalService();
  AdvSearchBottomSheet(this.model, {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: StatefulBuilder(
        builder: (builderContext, setState) {
          return SingleChildScrollView(
            child: Wrap(
                children: [
                  CustomCheckBox(
                    label: _globalService.getString(Const.ADVANCED_SEARCH),
                    isChecked: model.advSearchSelected,
                    onTap: () {
                      setState(() {
                        model.advSearchSelected = !model.advSearchSelected;
                      });
                    },
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 100),
                        child: Text(_globalService.getString(Const.SEARCH_CATEGORY)),
                      ),
                      SizedBox(
                        width: 220,
                        child: Transform.scale(
                          scale: 0.85,
                          child: CustomDropdown<AvailableOption>(
                            preSelectedItem: model.availableCategories?.safeFirstWhere(
                              (category) => (int.tryParse(category.value) ?? 0) == (model.categoryId ?? 0),
                              orElse: () => model.availableCategories?.safeFirst(),
                            ),
                            items: model.availableCategories?.map<DropdownMenuItem<AvailableOption>>((e) =>
                                DropdownMenuItem<AvailableOption>(
                                    value: e, child: Text(e.text)))
                                ?.toList() ??
                                List.empty(),
                            onChanged: (value) {
                              model.categoryId = int.tryParse(value.value) ?? 0;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  CustomCheckBox(
                    label: _globalService.getString(Const.AUTOMATICALLY_SEARCH_SUBCATEGORIES),
                    isChecked: model.searchInSubcategory,
                    onTap: () {
                      setState(() {
                        model.searchInSubcategory = !model.searchInSubcategory;
                      });
                    },
                  ),

                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 100),
                        child: Text(_globalService.getString(Const.SEARCH_MANUFACTURER)),
                      ),
                      SizedBox(
                        width: 220,
                        child: Transform.scale(
                          scale: 0.85,
                          child: CustomDropdown<AvailableOption>(
                            preSelectedItem: model.availableManufacturers?.safeFirstWhere(
                              (manufacturer) => (int.tryParse(manufacturer.value) ?? 0) == (model.manufacturerId ?? 0),
                              orElse: () => model.availableManufacturers?.safeFirst(),
                            ),
                            items: model.availableManufacturers?.map<DropdownMenuItem<AvailableOption>>((e) =>
                                DropdownMenuItem<AvailableOption>(
                                    value: e, child: Text(e.text)))
                                ?.toList() ??
                                List.empty(),
                            onChanged: (value) {
                              model.manufacturerId = int.tryParse(value.value) ?? 0;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  if((model.allowVendorSearch ?? false) == true)
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 100),
                          child: Text(_globalService.getString(Const.SEARCH_VENDOR)),
                        ),
                        SizedBox(
                          width: 220,
                          child: Transform.scale(
                            scale: 0.85,
                            child: CustomDropdown<AvailableOption>(
                              preSelectedItem: model.availableVendors?.safeFirstWhere(
                                (vendor) => (int.tryParse(vendor.value) ?? 0) == (model.vendorId ?? 0),
                                orElse: () => model.availableVendors?.safeFirst(),
                              ),
                              items: model.availableVendors?.map<DropdownMenuItem<AvailableOption>>((e) =>
                                  DropdownMenuItem<AvailableOption>(
                                      value: e, child: Text(e.text)))
                                  ?.toList() ??
                                  List.empty(),
                              onChanged: (value) {
                                model.vendorId = int.tryParse(value.value) ?? 0;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                  CustomCheckBox(
                    label: _globalService.getString(Const.SEARCH_IN_PRODUCT_DISCRIPTIONS),
                    isChecked: model.searchInDescription,
                    onTap: () {
                      setState(() {
                        model.searchInDescription = !model.searchInDescription;
                      });
                    },
                  ),
                ]
            ),
          );
        },
      ),
    );
  }
}
