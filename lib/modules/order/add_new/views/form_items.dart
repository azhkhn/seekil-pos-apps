import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_add_new.model.dart';
import 'package:seekil_back_office/models/order_item.model.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class OrderAddNewItemsSection extends StatefulWidget {
  const OrderAddNewItemsSection(this.orderAddNewModel,
      {Key? key, required this.onSavedFormItems})
      : super(key: key);
  final OrderAddNewModel orderAddNewModel;
  final Function onSavedFormItems;

  @override
  _OrderAddNewItemsSectionState createState() =>
      _OrderAddNewItemsSectionState();
}

class _OrderAddNewItemsSectionState extends State<OrderAddNewItemsSection> {
  List<dynamic>? itemsList = [];
  List<Map<String, dynamic>> itemValues = [];
  late Future<List<dynamic>> servicesList;
  dynamic servicesCurrentValue;

  @override
  void initState() {
    super.initState();
    servicesList = MasterDataModel.fetchMasterServices();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Items',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                      onPressed: _showFormNewItem,
                      icon: Icon(Icons.add_rounded))
                ],
              ),
              Divider(height: 8.0, color: Colors.grey),
              if (itemsList != null && itemsList!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: itemsList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(itemsList?[index]['item_name'],
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              Text(
                                itemsList?[index]['services_name'].join(', '),
                              ),
                              SizedBox(height: 4.0),
                              if (itemsList?[index]['note'] != null)
                                Text(itemsList?[index]['note'],
                                    style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 4.0),
                              Text(
                                  WordTransformation().currencyFormat(
                                      itemsList?[index]['subtotal']),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                          GestureDetector(
                            onTap: () {
                              itemsList?.removeAt(index);
                              setState(() {});
                            },
                            child:
                                Icon(Icons.delete_rounded, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              if (itemsList!.isEmpty)
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Belum ada item',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16.0),
                  ),
                )),
            ],
          ),
        ));
  }

  _showFormNewItem() {
    OrderItemModel orderItemModel = new OrderItemModel();
    final formItemsKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tambah item baru'),
            scrollable: true,
            actionsPadding: EdgeInsets.only(bottom: 16.0),
            content: Form(
              key: formItemsKey,
              child: Column(
                children: [
                  MyFormField(
                    label: 'Nama Item',
                    isMandatory: true,
                    textFieldValidator: (value) {
                      if (value == null || value == '') {
                        return 'Nama Item harus diisi';
                      }
                    },
                    onChanged: (dynamic value) {
                      orderItemModel.itemName = value;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Layanan',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        FutureBuilder(
                            future: servicesList,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<dynamic> data =
                                    snapshot.data as List<dynamic>;
                                return MultiSelectDialogField(
                                  selectedColor: ColorConstant.DEF,
                                  searchable: true,
                                  title: Text('Cari Layanan'),
                                  height: Get.height / 2,
                                  cancelText: Text(
                                    'Batal',
                                    style: TextStyle(
                                      color: ColorConstant.DEF,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  confirmText: Text(
                                    'Simpan',
                                    style: TextStyle(
                                      color: ColorConstant.DEF,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  items: data
                                      .map((e) => MultiSelectItem(e, e['name']))
                                      .toList(),
                                  onConfirm: (List<dynamic> values) {
                                    orderItemModel.servicesId = values;
                                  },
                                  searchHint: 'Cari',
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Layanan harus dipilih';
                                    }
                                  },
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  buttonText: Text(
                                    'Pilih Layanan',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  buttonIcon:
                                      Icon(Icons.keyboard_arrow_down_rounded),
                                );
                              }
                              return MultiSelectDialogField(
                                items: [],
                                onConfirm: (List<dynamic> values) {
                                  orderItemModel.servicesId = values;
                                },
                                searchable: true,
                                decoration:
                                    BoxDecoration(color: Colors.black12),
                                title: Text('Pilih Layanan'),
                                buttonText: Text('Pilih Layanan'),
                                buttonIcon:
                                    Icon(Icons.keyboard_arrow_down_rounded),
                              );
                            })
                      ],
                    ),
                  ),
                  // MyFormField(
                  //   label: 'Catatan',
                  //   onChanged: (dynamic value) {
                  //     orderItemModel.note = value;
                  //   },
                  // ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Batal', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(primary: ColorConstant.DEF),
              ),
              TextButton(
                child: Text('Tambah',
                    style: TextStyle(
                        color: ColorConstant.DEF, fontWeight: FontWeight.bold)),
                onPressed: () => _onSaved(orderItemModel, formItemsKey),
              ),
            ],
          );
        });
  }

  void _onSaved(
      OrderItemModel orderItemModel, GlobalKey<FormState> formItemsKey) {
    if (formItemsKey.currentState!.validate()) {
      itemsList?.add(orderItemModel.toJson());
      widget.orderAddNewModel.items = itemsList;
      Get.back();
      widget.onSavedFormItems();
    }
  }
}
