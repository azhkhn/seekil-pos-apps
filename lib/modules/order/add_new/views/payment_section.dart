import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_add_new.model.dart';
import 'package:seekil_back_office/models/promo_model.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class OrderAddNewPaymentSection extends StatefulWidget {
  const OrderAddNewPaymentSection(
    this.orderAddNewModel, {
    Key? key,
    required this.isUsePoint,
    required this.onChangeUsePoint,
    required this.onChangeOngkosKirim,
    required this.onChangeDownPayment,
    required this.onChangePromo,
    required this.onChangeEstimate,
    required this.promoList,
  }) : super(key: key);

  final OrderAddNewModel orderAddNewModel;
  final bool isUsePoint;
  final ValueChanged<bool> onChangeUsePoint;
  final ValueChanged<dynamic> onChangeOngkosKirim;
  final ValueChanged<dynamic> onChangeDownPayment;
  final ValueChanged<dynamic> onChangePromo;
  final ValueChanged<dynamic> onChangeEstimate;
  final Future<List<PromoModel>?> promoList;

  @override
  _OrderAddNewPaymentSectionState createState() =>
      _OrderAddNewPaymentSectionState();
}

class _OrderAddNewPaymentSectionState extends State<OrderAddNewPaymentSection> {
  OrderUtils orderUtils = OrderUtils();
  WordTransformation wt = WordTransformation();

  late Future<List<dynamic>> paymentMethod;
  dynamic promoCurrentValue;

  @override
  void initState() {
    super.initState();
    paymentMethod = MasterDataModel.fetchMasterPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    // int customerPoint = 0;
    // if (widget.orderAddNewModel.points != null)
    //   customerPoint = widget.orderAddNewModel.points!;

    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MyFormField(
                  label: 'Estimasi Pengerjaan (Hari)',
                  isMandatory: true,
                  textInputType: TextInputType.number,
                  initialValue: widget.orderAddNewModel.estimate.toString(),
                  onChanged: widget.onChangeEstimate,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Estimasi Pengerjaan harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: MyFormField(
                    label: 'Ongkos Kirim',
                    textInputType: TextInputType.number,
                    onChanged: widget.onChangeOngkosKirim),
              ),
            ],
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
                      List<PromoModel> data = snapshot.data as List<PromoModel>;
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
                        onChanged: widget.onChangePromo,
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
                            widget.orderAddNewModel.promoId = item['id'] as int;
                          });
                        },
                        items: []);
                  },
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: FutureBuilder(
                future: paymentMethod,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> data = snapshot.data as List<dynamic>;
                    return MyFormField(
                      label: 'Metode Pembayaran',
                      isMandatory: true,
                      type: FormFieldType.DROPDOWN,
                      dropdownItems: data,
                      dropdowndValidator: (value) {
                        if (value == null || value == '') {
                          return 'Metode Pembayaran harus dipilih';
                        }
                        return null;
                      },
                      onChanged: (dynamic value) {
                        setState(() {
                          widget.orderAddNewModel.paymentMethodId =
                              value as int;
                        });
                      },
                    );
                  }
                  return MyFormField(
                    label: 'Metode Pembayaran',
                    isMandatory: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        widget.orderAddNewModel.paymentMethodId = value as int;
                      });
                    },
                  );
                },
              )),
              SizedBox(width: 16.0),
              Expanded(
                child: MyFormField(
                  label: 'Status Pembayaran',
                  isMandatory: true,
                  type: FormFieldType.DROPDOWN,
                  dropdowndValidator: (value) {
                    if (value == null || value == '') {
                      return 'Status Pembayaran harus dipilih';
                    }
                    return null;
                  },
                  dropdownItems: [
                    {'id': 'lunas', 'name': 'Lunas'},
                    {'id': 'belum_lunas', 'name': 'Belum Lunas'},
                  ],
                  onChanged: (dynamic value) {
                    setState(() {
                      widget.orderAddNewModel.paymentStatus = value;
                    });
                  },
                ),
              )
            ],
          ),
          MyFormField(
            label: 'Uang Muka (DP)',
            textInputType: TextInputType.number,
            onChanged: widget.onChangeDownPayment,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Gunakan $customerPoint point',
          //         style: TextStyle(
          //             fontWeight: FontWeight.bold, color: Colors.grey)),
          //     Row(
          //       children: [
          //         Text('[-${wt.currencyFormat(customerPoint)}]',
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold, color: Colors.grey)),
          //         Switch(
          //           value: widget.isUsePoint,
          //           onChanged: widget.onChangeUsePoint,
          //           activeColor: ColorConstant.DEF,
          //         )
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
