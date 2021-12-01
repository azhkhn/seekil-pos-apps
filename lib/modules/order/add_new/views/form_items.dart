import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
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
              if (itemsList!.isNotEmpty)
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

    void _onSaved() {
      itemsList?.add(orderItemModel.toJson());
      widget.orderAddNewModel.items = itemsList;
      Get.back();
      widget.onSavedFormItems();
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tambah item baru'),
            scrollable: true,
            content: Column(
              children: [
                MyFormField(
                  label: 'Nama Item',
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
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      FutureBuilder(
                          future: servicesList,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> data =
                                  snapshot.data as List<dynamic>;
                              return MultiSelectDialogField(
                                items: data
                                    .map((e) => MultiSelectItem(e, e['name']))
                                    .toList(),
                                onConfirm: (List<dynamic> values) {
                                  orderItemModel.servicesId = values;
                                },
                                searchable: true,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                title: Text('Cari Layanan'),
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
                              decoration: BoxDecoration(color: Colors.black12),
                              title: Text('Pilih Layanan'),
                              buttonText: Text('Pilih Layanan'),
                              buttonIcon:
                                  Icon(Icons.keyboard_arrow_down_rounded),
                            );
                          })
                    ],
                  ),
                ),
                MyFormField(
                  label: 'Catatan',
                  onChanged: (dynamic value) {
                    orderItemModel.note = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: _onSaved,
                child: Text('Tambah'),
              ),
            ],
          );
        });
  }
}
