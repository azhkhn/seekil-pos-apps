import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';
import 'package:seekil_back_office/widgets/filter_button.dart';

class AllOrderFilterSection extends StatelessWidget {
  AllOrderFilterSection({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(
          spacing: 4.0,
          children: [
            Obx(() => Visibility(
                  visible: controller.checkQueryParams().isNotEmpty,
                  child: GestureDetector(
                    onTap: controller.resetQueryParam,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: Border.all(color: Colors.black54)),
                      child: Center(
                          child: Icon(
                        Icons.close,
                        color: Colors.black54,
                      )),
                    ),
                  ),
                )),
            _orderStatus(),
            _paymentStatus(),
            _paymentMethod(),
            _date(),
          ],
        ),
      ),
    );
  }

  void modalFilter({
    required String title,
    required RxList filterList,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    Get.bottomSheet(
      BottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.0),
            topLeft: Radius.circular(24.0),
          ),
        ),
        onClosing: () => Get.back(),
        builder: (context) => Container(
          padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
          child: Wrap(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close_rounded,
                      size: 24.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              ListView.separated(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: filterList.length,
                separatorBuilder: (context, index) {
                  return Divider(height: 2.0, color: Colors.grey);
                },
                itemBuilder: (context, index) => itemBuilder(context, index),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _orderStatus() => Obx(() => FilterButton(
        text: controller.filterOrderStatusTitle.value,
        isSelected: controller.filterOrderStatusTitle.value !=
            GeneralConstant.FILTER_ONGOING_TRANSACTION_DEFAULT,
        onTap: () {
          modalFilter(
            title: 'Status Transaksi',
            filterList: controller.filterOrderStatusList,
            itemBuilder: (context, index) => Obx(() {
              var lists = controller.filterOrderStatusList[index];
              var orderStatus =
                  controller.objectFilter.value['order_status_id'];
              return RadioListTile(
                value: lists,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: orderStatus,
                selected: orderStatus == lists['id'].toString(),
                onChanged: (dynamic value) {
                  controller.onChangedOrderStatus(value);
                },
                title: Text(lists['name'] as String,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black)),
              );
            }),
          );
        },
      ));

  Widget _date() => Obx(() => FilterButton(
        text: controller.filterDateTitle.value,
        isSelected: controller.filterDateTitle.value !=
            GeneralConstant.FILTER_ORDER_DATE_DEFAULT,
        onTap: () {
          modalFilter(
            title: 'Tanggal Transaksi',
            filterList: controller.filterDateList,
            itemBuilder: (context, index) => Obx(() {
              var lists = controller.filterDateList[index];
              return Column(
                children: [
                  RadioListTile(
                    value: lists,
                    controlAffinity: ListTileControlAffinity.trailing,
                    groupValue: controller.gvFilterDate,
                    selected: controller.gvFilterDate == lists,
                    onChanged: (dynamic value) {
                      controller.onChangedDate(value);
                    },
                    title: Text(lists['name'] as String,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black)),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.isCustomDate.isTrue,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              onTap: () {},
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: 'Mulai Dari',
                                labelStyle: TextStyle(
                                  decorationStyle: TextDecorationStyle.solid,
                                  fontSize: 16.0,
                                ),
                              ),
                            )),
                            SizedBox(width: 24.0),
                            Expanded(
                                child: TextFormField(
                              onTap: () {},
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: 'Sampai',
                                labelStyle: TextStyle(
                                  decorationStyle: TextDecorationStyle.solid,
                                  fontSize: 16.0,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
          );
        },
      ));

  Widget _paymentStatus() => Obx(() => FilterButton(
        text: controller.filterPaymentStatusTitle.value,
        isSelected: controller.filterPaymentStatusTitle.value !=
            GeneralConstant.FILTER_PAYMENT_STATUS_DEFAULT,
        onTap: () {
          modalFilter(
            title: 'Status Pembayaran',
            filterList: controller.filterPaymentStatusList,
            itemBuilder: (context, index) => Obx(() {
              var lists = controller.filterPaymentStatusList[index];
              var paymentStatus =
                  controller.objectFilter.value['payment_status'];
              return RadioListTile(
                value: lists,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: paymentStatus,
                selected: paymentStatus == lists['value'],
                onChanged: (dynamic value) {
                  controller.onChangedPaymentStatus(value);
                },
                title: Text(lists['name'] as String,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black)),
              );
            }),
          );
        },
      ));

  Widget _paymentMethod() => Obx(() => FilterButton(
        text: controller.filterPaymentMethodTitle.value,
        isSelected: controller.filterPaymentMethodTitle.value !=
            GeneralConstant.FILTER_PAYMENT_METHOD_DEFAULT,
        onTap: () {
          modalFilter(
            title: 'Status Pembayaran',
            filterList: controller.filterPaymentMethodList,
            itemBuilder: (context, index) => Obx(() {
              var lists = controller.filterPaymentMethodList[index];
              var paymentMethod =
                  controller.objectFilter.value['payment_method_id'];
              return RadioListTile(
                value: lists,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: paymentMethod,
                selected: paymentMethod == lists['id'].toString(),
                onChanged: (dynamic value) {
                  controller.onChangedPaymentMethod(value);
                },
                title: Text(lists['name'] as String,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black)),
              );
            }),
          );
        },
      ));
}
