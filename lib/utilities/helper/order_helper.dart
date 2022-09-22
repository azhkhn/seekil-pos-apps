import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/constants/order_status.constant.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/models/order_detail.model.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:url_launcher/url_launcher.dart';

enum messageType { textOnly, invoice }

class OrderUtils {
  final box = GetStorage();
  final WordTransformation wt = WordTransformation();

  int getItemSubtotal(dynamic items) {
    if (items != null && items.length > 0) {
      int itemSubtotal;

      dynamic iterateItems = items.reduce((value, element) {
        if (value is int) {
          return value + element['subtotal_with_discount'];
        } else {
          return value['subtotal_with_discount'] +
              element['subtotal_with_discount'];
        }
      });

      if (iterateItems is int) {
        itemSubtotal = iterateItems;
      } else {
        itemSubtotal = iterateItems['subtotal_with_discount'];
      }

      return itemSubtotal;
    }

    return 0;
  }

  int getTotal({
    int? pickupDeliveryPrice,
    int? potongan,
    items,
    int? points,
    int? downPayment,
  }) {
    int deliveryPrice = pickupDeliveryPrice ?? 0;
    int discount = potongan ?? 0;
    int point = points ?? 0;
    int dp = downPayment ?? 0;

    int totalPayment =
        (getItemSubtotal(items) + deliveryPrice) - discount - point - dp;

    return totalPayment;
  }

  Color determineColorByOrderStatus(int orderStatusCode) {
    switch (orderStatusCode) {
      case OrderStatusConstant.newest:
      case OrderStatusConstant.waitingList:
      case OrderStatusConstant.inProgress:
      case OrderStatusConstant.readyToPickup:
      case OrderStatusConstant.readyToShipment:
      case OrderStatusConstant.onProgressShipment:
        return Colors.orange;
      case OrderStatusConstant.done:
        return Colors.green;
      case OrderStatusConstant.cancel:
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  void launchWhatsapp({String? number, String? message}) async {
    String url = 'https://wa.me/$number/?text=$message';
    await canLaunch(url)
        ? launch(url)
        : SnackbarHelper.show(
            title: GeneralConstant.ERROR_TITLE,
            message: GeneralConstant.CANNOT_OPEN_WHATSAPP);
  }

  String sendInvoice() {
    OrderDetailModel? _orderDetail = box.read(StorageKeyConstant.ORDER_DETAIL);
    Map<String, dynamic> _orderItems = box.read(StorageKeyConstant.ORDER_ITEMS);

    String? invoice = _orderDetail!.orderId;
    String? customerName = _orderDetail.customerName;
    String? customerWhatsapp = _orderDetail.whatsapp!.replaceRange(0, 2, '0');
    String dateTime = wt.dateFormatter(
        date: _orderDetail.orderDate, type: DateFormatType.dateTimeInfo);
    String? estimate = wt.customDateSubstract(
      dateTime: _orderDetail.orderDate,
      dateFormatType: DateFormatType.dateTimeInfo,
      days: _orderDetail.estimate != 0 && _orderDetail.estimate != null
          ? _orderDetail.estimate!
          : 3,
    );
    String? ongkosKirim = wt.currencyFormat(_orderDetail.ongkir);
    String? discount = wt.currencyFormat(_orderDetail.promo);
    String? statusPembayaran = _orderDetail.paymentStatus!.contains('_')
        ? toBeginningOfSentenceCase(
            _orderDetail.paymentStatus!.replaceAll('_', ' '))
        : toBeginningOfSentenceCase(_orderDetail.paymentStatus);
    String subtotal = wt.currencyFormat(getItemSubtotal(_orderItems['list']));
    String? downPayment = wt.currencyFormat(_orderDetail.downPayment);
    String total = wt.currencyFormat(getTotal(
        items: _orderItems['list'] ?? [],
        pickupDeliveryPrice: _orderDetail.ongkir ?? 0,
        potongan: _orderDetail.promo ?? 0));

    String generateItem() {
      return _orderItems['list']
          .map((e) {
            String itemName = e['item_name'].replaceAll('&', 'and').trim();
            String services = e['services']
                .map((s) =>
                    '_${s['name'].replaceAll('&', 'and').trim()}: ${wt.currencyFormat(s['price'])}_\n')
                .toString()
                .trim();
            return '\n*$itemName*\n$services';
          })
          .toString()
          .trimLeft();
    }

    // DATA
    String dTitle =
        'Hi *$customerName*.\nTerima kasih sudah drop sepatu/apparel nya di Seekil, berikut invoice nya:\n\n';
    String dInvoice = 'Invoice: $invoice\n';
    String dWhatsapp = 'Whatsapp: $customerWhatsapp\n\n';
    String dWaktu = 'Tgl Transaksi: $dateTime\n';
    String dEstimate = 'Estimasi Selesai: $estimate\n';
    String dItems =
        '${generateItem().replaceAll('(', '').replaceAll(')', '').replaceAll(',', '').trim()}\n';
    String dSubtotal = 'Subtotal: $subtotal\n';
    String dOngkir = 'Ongkos Kirim: $ongkosKirim\n';
    String dDiskon = 'Diskon: -$discount\n';
    String dDownPayment = 'Uang Muka (DP): $downPayment\n\n';
    String dTotal = '*Total: $total*\n';
    String dStatus = '*_${statusPembayaran!.toUpperCase()}_*\n';
    String dNote = '\nMohon ditunggu untuk cucian nya 😊';
    String separator = '-----------------------------------------\n';
    String downloadCekCucianApps =
        '\n\nDownload aplikasi *Cek Cucian by Seekil* untuk pantau status cucianmu di Seekil\n\n';
    String playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.seekil.cek_cucian';

    return '$dTitle'
        '$dInvoice'
        '$dWhatsapp'
        '$dWaktu'
        '$dEstimate'
        '$separator'
        '$dItems'
        '$separator'
        '$dSubtotal'
        '$dOngkir'
        '$dDiskon'
        '$dDownPayment'
        '$dTotal'
        '$separator'
        '$dStatus'
        '$separator'
        '$dNote'
        '$downloadCekCucianApps'
        '$playStoreUrl';
  }
}
