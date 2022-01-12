import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/order_add_new.model.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class OrderAddNewFooterSection extends StatelessWidget {
  OrderAddNewFooterSection(this.orderAddNewModel, this.formKey, {Key? key})
      : super(key: key);
  final WordTransformation wt = WordTransformation();
  final OrderUtils orderUtils = OrderUtils();
  final OrderAddNewModel orderAddNewModel;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 20.0, offset: Offset(0, 15.0))]),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Bayar',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                  wt.currencyFormat(orderUtils.getTotal(
                      items: orderAddNewModel.items,
                      potongan: orderAddNewModel.potongan,
                      // points: isUsePoint ? orderAddNewModel.points : 0,
                      pickupDeliveryPrice:
                          orderAddNewModel.pickupDeliveryPrice)),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
            ],
          )),
          ElevatedButton(
              onPressed: _onSaveForm,
              style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0),
                  primary: ColorConstant.DEF,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)))),
              child: Text('Buat Pesanan',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          //     )),
        ],
      ),
    );
  }

  void _onSaveForm() async {
    if (formKey.currentState!.validate()) {
      try {
        Get.dialog(LoadingIndicator());
        await orderAddNewModel.createOrder(orderAddNewModel.toJson());
        Get.back();
        Get.back(result: true);
      } catch (error) {
        SnackbarHelper.show(
            title: GeneralConstant.ERROR_TITLE, message: error.toString());
      }
    }
  }
}
