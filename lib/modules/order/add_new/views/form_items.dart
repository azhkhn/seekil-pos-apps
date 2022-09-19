import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_add_new.model.dart';
import 'package:seekil_back_office/models/order_item.model.dart';
import 'package:seekil_back_office/models/promo_model.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class OrderAddNewItemsSection extends StatefulWidget {
  const OrderAddNewItemsSection(
    this.orderAddNewModel, {
    Key? key,
    required this.onSavedFormItems,
    required this.promoList,
  }) : super(key: key);
  final OrderAddNewModel orderAddNewModel;
  final Function onSavedFormItems;
  final Future<List<PromoModel>?> promoList;

  @override
  _OrderAddNewItemsSectionState createState() =>
      _OrderAddNewItemsSectionState();
}

class _OrderAddNewItemsSectionState extends State<OrderAddNewItemsSection> {
  List<dynamic>? itemsList = [];
  List<Map<String, dynamic>> itemValues = [];
  late Future<List<dynamic>> servicesList;
  dynamic servicesCurrentValue;
  final WordTransformation wt = WordTransformation();
  final OrderUtils orderUtils = OrderUtils();
  dynamic promoCurrentValue;

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
                      onPressed: () => _showFormNewItem(context),
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
                    var item = itemsList?[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['item_name'],
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              if (item['note'] != null)
                                Text(item['note'],
                                    style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 4.0),
                              Text(
                                '(X${item['qty']}) ${item['services_name'].join(', ')}',
                              ),
                              SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Text(
                                    WordTransformation()
                                        .currencyFormat(item['subtotal']),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      decoration:
                                          item['subtotal_with_discount'] !=
                                                  item['subtotal']
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  if (item['subtotal_with_discount'] !=
                                      item['subtotal'])
                                    Text(
                                        WordTransformation().currencyFormat(
                                            item['subtotal_with_discount']),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold)),
                                ],
                              ),
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

  _showFormNewItem(BuildContext context) {
    OrderItemModel orderItemModel = new OrderItemModel();
    final formItemsKey = GlobalKey<FormState>();

    WidgetHelper.bottomSheet(
      context,
      onClosing: () => Get.back(),
      title: 'Tambah Item',
      child: Form(
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
                return null;
              },
              onChanged: (dynamic value) {
                orderItemModel.itemName = value;
              },
            ),
            MyFormField(
              label: 'Qty',
              isMandatory: true,
              textInputType: TextInputType.number,
              initialValue: orderItemModel.qty.toString(),
              textFieldValidator: (value) {
                if (value == null || value == '') {
                  return 'Qty minimal 1';
                }
                return null;
              },
              onChanged: (dynamic value) {
                if (value == null || value == '') {
                  orderItemModel.qty = 1;
                } else {
                  orderItemModel.qty = int.parse(value);
                }
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
                          List<dynamic> data = snapshot.data as List<dynamic>;
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
                              return null;
                            },
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            buttonText: Text(
                              'Pilih Layanan',
                              style: TextStyle(color: Colors.grey),
                            ),
                            buttonIcon: Icon(Icons.keyboard_arrow_down_rounded),
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
                          buttonIcon: Icon(Icons.keyboard_arrow_down_rounded),
                        );
                      })
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Promo',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  FutureBuilder(
                    future: widget.promoList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<PromoModel> data =
                            snapshot.data as List<PromoModel>;
                        return DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10.0),
                          ),
                          value: promoCurrentValue,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          isExpanded: true,
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (dynamic item) {
                            List<dynamic>? items = orderItemModel.servicesId;
                            int discount = item.discount;
                            int subtotalItem = orderItemModel
                                    .getItemSubtotalFromAddItem(items) *
                                (orderItemModel.qty ?? 1);

                            double totalDiscount =
                                (subtotalItem * discount) / 100;

                            orderItemModel.promoId = item.id as int;
                            orderItemModel.discount = totalDiscount.toInt();
                          },
                          items: data.map<DropdownMenuItem>((PromoModel item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Row(
                                children: [
                                  Text(item.code!),
                                  SizedBox(width: 4.0),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                        color: ColorConstant.SUCCESS,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))),
                                    child: Text('${item.discount!}%',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10.0),
                          ),
                          value: promoCurrentValue,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          isExpanded: true,
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (dynamic item) {
                            setState(() {
                              widget.orderAddNewModel.promoId =
                                  item['id'] as int;
                            });
                          },
                          items: []);
                    },
                  ),
                ],
              ),
            ),
            WidgetHelper.bottomSheetButton(
              onPressed: () => _onSaved(orderItemModel, formItemsKey),
              title: 'Simpan',
            )
          ],
        ),
      ),
    );
  }

  void _onSaved(
      OrderItemModel orderItemModel, GlobalKey<FormState> formItemsKey) {
    if (formItemsKey.currentState!.validate()) {
      itemsList?.add(orderItemModel.toJson());
      widget.orderAddNewModel.items = itemsList;

      int qty = 0;

      for (var item in itemsList!) {
        qty += item['qty'] as int;
      }

      widget.orderAddNewModel.qty = (widget.orderAddNewModel.qty ?? 0) + qty;
      Get.back();
      widget.onSavedFormItems();
    }
  }
}
