import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:seekil_back_office/models/customer_list.model.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_add_new.model.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class OrderAddNewCustomerSection extends StatefulWidget {
  const OrderAddNewCustomerSection(this.orderAddNewModel,
      {Key? key,
      required this.whatsappController,
      required this.customerNameController,
      required this.onChangeCustomerName,
      required this.onSuggestionSelected})
      : super(key: key);
  final OrderAddNewModel orderAddNewModel;
  final TextEditingController whatsappController;
  final TextEditingController customerNameController;
  final ValueChanged<dynamic> onChangeCustomerName;
  final ValueChanged<dynamic> onSuggestionSelected;

  @override
  _OrderAddNewCustomerSectionState createState() =>
      _OrderAddNewCustomerSectionState();
}

class _OrderAddNewCustomerSectionState
    extends State<OrderAddNewCustomerSection> {
  late Future<List<dynamic>> customerList,
      orderType,
      storeLocation,
      dropPointLocation;

  @override
  void initState() {
    super.initState();
    customerList = CustomerListModel.fetchCustomerList('customer');
    orderType = MasterDataModel.fetchMasterType();
    storeLocation = MasterDataModel.fetchMasterStore();
    dropPointLocation = MasterDataModel.fetchMasterPartnership();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Nama Pelanggan',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  TypeAheadFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSuggestionSelected: widget.onSuggestionSelected,
                    loadingBuilder: (context) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Wrap(
                        children: List.generate(
                            3,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyShimmer.rectangular(height: 10.0),
                                      SizedBox(height: 4.0),
                                      MyShimmer.rectangular(
                                        height: 10.0,
                                        width: 180,
                                      )
                                    ],
                                  ),
                                )),
                      ),
                    ),
                    debounceDuration: Duration(microseconds: 100),
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: widget.customerNameController,
                        onChanged: widget.onChangeCustomerName,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10.0),
                        )),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Nama Pelanggan harus diisi';
                      }
                    },
                    itemBuilder: (context, itemData) {
                      final CustomerListModel user =
                          itemData as CustomerListModel;
                      return ListTile(
                        title: Text(user.name,
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(user.whatsapp),
                      );
                    },
                    suggestionsCallback: (pattern) {
                      return CustomerListModel.fetchCustomerList(
                          'customer', pattern);
                    },
                  ),
                ],
              )),
          MyFormField(
            label: 'Whatsapp',
            isMandatory: true,
            controller: widget.whatsappController,
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^0+(?=.)'),
                  replacementString: ''),
              FilteringTextInputFormatter.deny(RegExp(r'^62(?=.)'),
                  replacementString: ''),
              FilteringTextInputFormatter.digitsOnly
            ],
            textFieldValidator: (value) {
              if (value == null || value == '') {
                return 'Whatsapp harus diisi';
              }
            },
            inputDecoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                isDense: true,
                prefixText: '62',
                prefixStyle: TextStyle(color: Colors.black, fontSize: 16.0)),
            onChanged: (newValue) {
              widget.orderAddNewModel.whatsapp = newValue;
              setState(() {});
            },
          ),
          FutureBuilder(
            future: orderType,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> data = snapshot.data as List<dynamic>;
                return MyFormField(
                  label: 'Jenis Order',
                  isMandatory: true,
                  type: FormFieldType.DROPDOWN,
                  dropdowndValidator: (value) {
                    if (value == null || value == '') {
                      return 'Jenis Order harus dipilih';
                    }
                  },
                  dropdownItems: data,
                  onChanged: (dynamic value) {
                    setState(() {
                      widget.orderAddNewModel.orderTypeId = value as int;
                    });
                  },
                );
              }
              return MyFormField(
                label: 'Jenis Order',
                isMandatory: true,
                onChanged: (dynamic value) {
                  setState(() {
                    widget.orderAddNewModel.orderTypeId = value as int;
                  });
                },
              );
            },
          ),
          if (widget.orderAddNewModel.orderTypeId != null &&
              widget.orderAddNewModel.orderTypeId == 1)
            FutureBuilder(
              future: storeLocation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data as List<dynamic>;
                  return MyFormField(
                    label: 'Lokasi Toko',
                    isMandatory: widget.orderAddNewModel.orderTypeId == 1,
                    type: FormFieldType.DROPDOWN,
                    dropdownItems: data,
                    dropdownItemKeyValue: DropdownItemKeyValue(text: 'staging'),
                    dropdowndValidator: (value) {
                      if (widget.orderAddNewModel.orderTypeId == 1) {
                        if (value == null || value == '') {
                          return 'Lokasi Toko harus diisi';
                        }
                      }
                    },
                    onChanged: (dynamic value) {
                      setState(() {
                        widget.orderAddNewModel.storeId = value as int;
                      });
                    },
                  );
                }
                return MyFormField(
                  label: 'Lokasi Toko',
                  onChanged: (dynamic value) {
                    setState(() {
                      widget.orderAddNewModel.storeId = value as int;
                    });
                  },
                );
              },
            ),
          if (widget.orderAddNewModel.orderTypeId != null &&
              widget.orderAddNewModel.orderTypeId == 3)
            FutureBuilder(
              future: dropPointLocation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data as List<dynamic>;
                  return MyFormField(
                    label: 'Lokasi Drop',
                    isMandatory: widget.orderAddNewModel.orderTypeId == 3,
                    type: FormFieldType.DROPDOWN,
                    dropdownItems: data,
                    dropdowndValidator: (value) {
                      if (widget.orderAddNewModel.orderTypeId == 3) {
                        if (value == null || value == '') {
                          return 'Alamat Pengambilan harus diisi';
                        }
                      }
                    },
                    onChanged: (dynamic value) {
                      setState(() {
                        widget.orderAddNewModel.partnershipId = value as int;
                      });
                    },
                  );
                }
                return MyFormField(
                  label: 'Lokasi Drop',
                  onChanged: (dynamic value) {
                    setState(() {
                      widget.orderAddNewModel.partnershipId = value as int;
                    });
                  },
                );
              },
            ),
          if (widget.orderAddNewModel.orderTypeId != null &&
              widget.orderAddNewModel.orderTypeId == 2)
            MyFormField(
              label: 'Alamat Pengambilan',
              isMandatory: widget.orderAddNewModel.orderTypeId == 2,
              textFieldValidator: (value) {
                if (widget.orderAddNewModel.orderTypeId == 2) {
                  if (value == null || value == '') {
                    return 'Alamat Pengambilan harus diisi';
                  }
                }
              },
              onChanged: (dynamic newValue) {
                setState(() {
                  widget.orderAddNewModel.pickupAddress = newValue;
                });
              },
            ),
        ],
      ),
    );
  }
}
