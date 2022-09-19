class OrderItemModel {
  String? itemName;
  List<dynamic>? servicesId;
  int? subtotal;
  String? note;
  int? qty;
  int? discount;
  int? promoId;

  OrderItemModel({
    this.servicesId,
    this.itemName,
    this.subtotal,
    this.note,
    this.qty = 1,
    this.discount,
    this.promoId,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'services_id': servicesId!.isNotEmpty
          ? servicesId?.map((element) => element['id']).toList()
          : null,
      'services_name': servicesId!.isNotEmpty
          ? servicesId?.map((element) => element['name']).toList()
          : null,
      'subtotal': getItemSubtotalFromAddItem(servicesId) * qty!,
      'subtotal_with_discount':
          (getItemSubtotalFromAddItem(servicesId) * (qty ?? 1)) -
              (discount ?? 0),
      'note': note,
      'qty': qty,
      'discount': discount,
      'promo_id': promoId,
    };
  }

  int getItemSubtotalFromAddItem(items) {
    if (items.isNotEmpty) {
      int itemSubtotal;

      dynamic iterateItems = items.reduce((value, element) {
        if (value is int) {
          return value + element['price'];
        } else {
          return value['price'] + element['price'];
        }
      });

      if (iterateItems is int) {
        itemSubtotal = iterateItems;
      } else {
        itemSubtotal = iterateItems['price'];
      }

      return itemSubtotal;
    }

    return 0;
  }
}
