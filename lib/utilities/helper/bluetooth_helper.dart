import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/models/order_detail.model.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class BluetoothHelper {
  WordTransformation wt = WordTransformation();
  OrderUtils orderUtils = OrderUtils();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final box = GetStorage();

  void onPrintOrder() {
    OrderDetailModel? _orderDetail = box.read(StorageKeyConstant.ORDER_DETAIL);
    Map<String, dynamic> _orderItems = box.read(StorageKeyConstant.ORDER_ITEMS);

    String currentDate = wt.dateFormatter(
        date: _orderDetail!.orderDate, type: DateFormatType.dateTimeInfo);
    int? ongkosKirim = _orderDetail.ongkir ?? 0;
    int? discount = _orderDetail.promo ?? 0;
    int itemSubtotal = orderUtils.getItemSubtotal(_orderItems['list']);
    int total = orderUtils.getTotal(
        items: _orderItems['list'] ?? [],
        pickupDeliveryPrice: _orderDetail.ongkir ?? 0,
        potongan: _orderDetail.promo ?? 0);

    bluetooth.printImage(box.read(StorageKeyConstant.LOGO_PATH));
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printLeftRight('Nama', _orderDetail.customerName, 1);
    bluetooth.printLeftRight(
        'Whatsapp', '${_orderDetail.whatsapp!.replaceRange(0, 2, '0')}', 1);
    bluetooth.printLeftRight('Waktu', currentDate, 1);
    bluetooth.printCustom('--------------------------------', 1, 2);

    if (_orderItems['list'] != null) {
      for (var item in _orderItems['list'] ?? []) {
        bluetooth.printCustom(item['item_name'], 1, 0);

        for (var service in item['services']) {
          bluetooth.printLeftRight(service['name'] as String,
              wt.currencyFormat(service['price']), 1);
        }
      }
    }

    bluetooth.printCustom('--------------------------------', 1, 2);
    bluetooth.printLeftRight('Subtotal', wt.currencyFormat(itemSubtotal), 1);
    bluetooth.printLeftRight('Ongkos Kirim', wt.currencyFormat(ongkosKirim), 1);
    bluetooth.printLeftRight('Diskon', '-${wt.currencyFormat(discount)}', 1);
    bluetooth.printLeftRight('Total', wt.currencyFormat(total), 1);
    bluetooth.printCustom('--------------------------------', 1, 2);
    bluetooth.printCustom(
        '### ${_orderDetail.paymentStatus!.toUpperCase()} ###', 1, 1);
    bluetooth.printCustom('--------------------------------', 1, 2);
    bluetooth.printCustom("Terima kasih banyak :)", 1, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.paperCut();
  }

  initSavetoPath() async {
    String? isLogoExists = box.read(StorageKeyConstant.LOGO_PATH);
    if (isLogoExists == null) {
      File file = await getImageFileFromAssets('logo.jpeg');
      File compressedFile = await FlutterNativeImage.compressImage(file.path,
          targetHeight: 100, targetWidth: 200);
      box.write(StorageKeyConstant.LOGO_PATH, compressedFile.path);
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
