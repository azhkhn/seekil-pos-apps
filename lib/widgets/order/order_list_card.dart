import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_detail.model.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class OrderListCard extends StatefulWidget {
  OrderListCard({Key? key, required this.data, this.isRefreshed})
      : super(key: key);

  final OrderListModel data;
  final ValueChanged<bool>? isRefreshed;

  @override
  State<OrderListCard> createState() => _OrderListCardState();
}

class _OrderListCardState extends State<OrderListCard> {
  final WordTransformation wt = WordTransformation();
  final OrderUtils orderUtils = OrderUtils();
  late Future<List<dynamic>> _paymentMethod, _orderStatus;

  @override
  void initState() {
    super.initState();
    _paymentMethod = MasterDataModel.fetchMasterPaymentMethod();
    _orderStatus = MasterDataModel.fetchMasterStatus();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _valueStyle(bool isBold) {
      if (isBold) {
        return TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
      } else {
        return TextStyle(color: Colors.black);
      }
    }

    return GestureDetector(
      onTap: () => Get.toNamed('/order/${widget.data.orderId}')!.then(
        (value) {
          if (value != null && value == true) {
            SnackbarHelper.show(
                title: 'Info',
                message: GeneralConstant.ORDER_UPDATED,
                withBottomNavigation: true);
            widget.isRefreshed!(value);
          }
        },
      ),
      child: Card(
        elevation: 2.0,
        child: Stack(
          children: [
            // Positioned(
            //     child: Container(
            //   width: 5.0,
            //   height: 28.0,
            //   color: OrderUtils()
            //       .determineColorByOrderStatus(widget.data.orderStatusId),
            // )),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wt.dateFormatter(date: widget.data.orderDate),
                            style: _valueStyle(false)
                                .copyWith(color: Colors.grey, fontSize: 13.0),
                          ),
                          Text(
                            widget.data.orderId,
                            textAlign: TextAlign.left,
                            style:
                                _valueStyle(true).copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _showModalEditOrder(widget.data),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.mode_edit_outline_outlined,
                            size: 20.0,
                            color: Colors.grey,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.data.customerName,
                            style: _valueStyle(true),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '(${widget.data.qty} Item)',
                            style:
                                _valueStyle(false).copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      WidgetHelper.badgeText(
                        widget.data.orderType,
                        badgeColor: ColorConstant.DEF,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        wt.currencyFormat(widget.data.total),
                        style: _valueStyle(true),
                      ),
                      WidgetHelper.badgeText(
                        widget.data.paymentStatus as String,
                        textColor: Colors.white,
                        badgeColor:
                            widget.data.paymentStatus as String == 'Lunas'
                                ? Colors.green
                                : Colors.red,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdateOrder(dynamic formDataJson) async {
    try {
      // Close snackbar form
      Get.back();
      // Show loading indicator
      // setState(() {
      //   showLoading = true;
      // });
      await OrderDetailModel.updateOrder(widget.data.orderId, formDataJson);
      // Back to previous screen
      widget.isRefreshed!(true);
    } catch (error) {
      SnackbarHelper.show(
        title: GeneralConstant.ERROR_TITLE,
        message: error.toString(),
      );
    } finally {
      // Close loading indicator
      // setState(() {
      //   showLoading = false;
      // });
    }
  }

  void _showModalEditOrder(OrderListModel data) {
    OrderDetailForEditModel formData = OrderDetailForEditModel(
      orderStatusId: data.orderStatusId,
      paymentMethodId: data.paymentMethodId,
      paymentStatus: data.paymentStatusName,
    );

    Get.bottomSheet(
      BottomSheet(
        onClosing: () => Get.back(),
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 24.0),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.close_rounded),
                      onTap: () => Get.back(),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Edit Transaksi - ${data.customerName}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _orderStatus,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var orderStatusList = snapshot.data as List<dynamic>;
                    return MyFormField(
                      label: 'Status Transaksi',
                      type: FormFieldType.DROPDOWN,
                      dropdownCurrentValue: formData.orderStatusId,
                      dropdownItems: orderStatusList,
                      onChanged: (dynamic value) {
                        formData.orderStatusId = value as int;
                      },
                    );
                  }
                  return MyFormField(label: 'Status Transaksi');
                },
              ),
              FutureBuilder(
                future: _paymentMethod,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var paymentMethodList = snapshot.data as List<dynamic>;
                    return MyFormField(
                      label: 'Metode Pembayaran',
                      type: FormFieldType.DROPDOWN,
                      dropdownCurrentValue: formData.paymentMethodId,
                      dropdownItems: paymentMethodList,
                      onChanged: (dynamic value) {
                        formData.paymentMethodId = value as int;
                      },
                    );
                  }
                  return MyFormField(label: 'Metode Pembayaran');
                },
              ),
              MyFormField(
                label: 'Status Pembayaran',
                type: FormFieldType.DROPDOWN,
                dropdownCurrentValue: formData.paymentStatus,
                dropdownItems: GeneralConstant.orderPaymentStatus,
                onChanged: (dynamic value) => formData.paymentStatus = value,
              ),
              Container(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () => _onUpdateOrder(formData.toJson()),
                  child: Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10.0),
                    primary: ColorConstant.DEF,
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
