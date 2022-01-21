import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/order_detail.model.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/modules/order/detail/views/customer_section.dart';
import 'package:seekil_back_office/modules/order/detail/views/detail_section.dart';
import 'package:seekil_back_office/modules/order/detail/views/items_section.dart';
import 'package:seekil_back_office/modules/order/detail/views/payment_section.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/utilities/helper/bluetooth_helper.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class OrderDetail extends StatefulWidget {
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  late Future<OrderDetailModel> _orderData;
  late Future<List<dynamic>> _paymentMethod, _orderStatus;
  late Future<Map<String, dynamic>> _itemsList;
  bool showLoading = false;

  final box = GetStorage();
  final orderId = Get.parameters['order_id'] as String;

  WordTransformation wordTransformation = WordTransformation();
  OrderUtils orderUtils = OrderUtils();
  BluetoothHelper bluetoothHelper = BluetoothHelper();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Map<String, dynamic> formDataJson = {
    'order_status_id': null,
    'payment_method_id': null,
    'payment_status': null
  };

  @override
  void initState() {
    super.initState();
    _orderData = OrderDetailModel.fetchOrderDetail(orderId);
    _paymentMethod = MasterDataModel.fetchMasterPaymentMethod();
    _orderStatus = MasterDataModel.fetchMasterStatus();
    _itemsList = OrderListModel.fetchOrderItems(orderId);
  }

  TextStyle _titleStyle = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black54);
  TextStyle _valueStyle = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper.appBar('Detail Transaksi'),
        body: Stack(
          children: [
            FutureBuilder(
                future: Future.wait([_orderData, _itemsList]),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return LoadingIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List data = snapshot.data as List;
                        OrderDetailModel orderDataItem = data[0];
                        Map<String, dynamic> itemsList = data[1];

                        formDataJson['order_status_id'] =
                            orderDataItem.orderStatus;
                        formDataJson['payment_method_id'] =
                            orderDataItem.paymentMethod;
                        formDataJson['payment_status'] =
                            orderDataItem.paymentStatus;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  DetailSection(
                                    titleStyle: _titleStyle,
                                    valueStyle: _valueStyle,
                                    wordTransformation: wordTransformation,
                                    data: orderDataItem,
                                  ),
                                  CustomerSection(
                                    titleStyle: _titleStyle,
                                    valueStyle: _valueStyle,
                                    wordTransformation: wordTransformation,
                                    data: orderDataItem,
                                  ),
                                  ItemsSection(itemsList),
                                  PaymentSection(
                                    itemsList: itemsList,
                                    titleStyle: _titleStyle,
                                    valueStyle: _valueStyle,
                                    data: orderDataItem,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20.0,
                                        offset: Offset(0, 15.0))
                                  ]),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showModalEditOrder(orderDataItem),
                                      child: Container(
                                        width: Get.width,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: ColorConstant.DEF,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                            child: Text(
                                          'Edit Transaksi',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        )),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        _showModalSendMessage(orderDataItem),
                                    child: Container(
                                      padding: EdgeInsets.all(7.0),
                                      margin: EdgeInsets.only(left: 8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white54,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Center(
                                        child: Icon(
                                          Icons.menu_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            // FooterSection(
                            //     titleStyle: _titleStyle, valueStyle: _valueStyle)
                          ],
                        );
                      }
                      return Container();
                  }
                }),
            if (showLoading) LoadingIndicator()
          ],
        ));
  }

  void _onUpdateOrder() async {
    try {
      // Close snackbar form
      Get.back();
      // Show loading indicator
      setState(() {
        showLoading = true;
      });
      await OrderDetailModel.updateOrder(orderId, formDataJson);
      // Back to previous screen
      Get.back(result: true);
    } catch (error) {
      SnackbarHelper.show(
          title: GeneralConstant.ERROR_TITLE, message: error.toString());
    } finally {
      // Close loading indicator
      setState(() {
        showLoading = false;
      });
    }
  }

  void _showModalEditOrder(data) {
    Get.bottomSheet(
      BottomSheet(
          onClosing: () => Get.back(),
          enableDrag: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          )),
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
                          Text('Edit Transaksi',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
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
                              onChanged: (dynamic value) {
                                formDataJson['order_status_id'] = value as int;
                              },
                              dropdownCurrentValue: data?.orderStatus,
                              dropdownItems: orderStatusList);
                        }
                        return MyFormField(
                          label: 'Status Transaksi',
                        );
                      },
                    ),
                    FutureBuilder(
                      future: _paymentMethod,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var paymentMethodList =
                              snapshot.data as List<dynamic>;
                          return MyFormField(
                              label: 'Metode Pembayaran',
                              type: FormFieldType.DROPDOWN,
                              onChanged: (dynamic value) {
                                formDataJson['payment_method_id'] =
                                    value as int;
                              },
                              dropdownCurrentValue: data?.paymentMethod,
                              dropdownItems: paymentMethodList);
                        }
                        return MyFormField(
                          label: 'Metode Pembayaran',
                        );
                      },
                    ),
                    MyFormField(
                      label: 'Status Pembayaran',
                      type: FormFieldType.DROPDOWN,
                      onChanged: (dynamic value) {
                        formDataJson['payment_status'] = value;
                      },
                      dropdownCurrentValue: data.paymentStatus,
                      dropdownItems: GeneralConstant.orderPaymentStatus,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: _onUpdateOrder,
                        child: Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10.0),
                            primary: ColorConstant.DEF,
                            textStyle: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              )),
      isScrollControlled: true,
    );
  }

  void Function()? onSendInvoice(dynamic data) {
    Get.back();
    if (AuthHelper.isSuperAdmin()) {
      orderUtils.launchWhatsapp(
          number: data?.whatsapp, message: orderUtils.sendInvoice());
    } else {
      orderUtils.launchWhatsapp(
          number: '6282127051607', message: orderUtils.sendInvoice());
    }
  }

  void Function()? onPrintInvoice() {
    BluetoothDevice? bluetoothDevice =
        box.read(StorageKeyConstant.SELECTED_BLUETOOTH);

    if (bluetoothDevice != null) {
      bluetoothHelper.onPrintOrder();
      SnackbarHelper.show(
          title: 'Info',
          message: 'Invoice sedang dicetak ke ${bluetoothDevice.name}',
          withBottomNavigation: true);
    } else {
      SnackbarHelper.show(
          title: GeneralConstant.ERROR_TITLE,
          message: GeneralConstant.BLUETOOTH_NOT_CONNECTED,
          mainButtonTitle: 'Pengaturan',
          mainButtonAction: () => Get.toNamed(AppRoutes.bluetoothPage),
          withBottomNavigation: true);
    }
  }

  void _showModalSendMessage(dynamic data) {
    Get.bottomSheet(
      BottomSheet(
          onClosing: () => Get.back(),
          enableDrag: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
          )),
          builder: (context) => Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 24.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(Icons.close, color: Colors.grey),
                        ),
                        SizedBox(width: 8.0),
                        Text('Lainnya',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Cetak Invoice',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      Get.back();
                      onPrintInvoice();
                    },
                  ),
                  ListTile(
                    title: Text('Kirim Invoice',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () => onSendInvoice(data),
                  ),
                  ListTile(
                    title: Text('Hapus Transaksi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    onTap: _showDeleteTransactionConfirmation,
                  ),
                ],
              )),
    );
  }

  void _showDeleteTransactionConfirmation() {
    Get.back();
    Get.dialog(
        AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin menghapus transaksi ini?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Batal', style: TextStyle(color: ColorConstant.DEF)),
            ),
            ElevatedButton(
              child: Text('Ya, hapus',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: _onDeleteTransaction,
              style: ElevatedButton.styleFrom(primary: ColorConstant.DEF),
            ),
          ],
        ),
        barrierDismissible: false);
  }

  void _onDeleteTransaction() async {
    Get.back();
    try {
      setState(() {
        showLoading = true;
      });
      await OrderListModel.deleteOrderByOrderId(orderId);
      setState(() {
        showLoading = false;
      });
      Get.back(result: true);
    } catch (error) {
      setState(() {
        showLoading = false;
      });
      SnackbarHelper.show(
          title: GeneralConstant.ERROR_TITLE, message: error.toString());
    }
  }
}
