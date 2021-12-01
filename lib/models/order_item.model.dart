class OrderItemModel {
  String? itemName;
  List<dynamic>? servicesId;
  int? subtotal;
  String? note;

  OrderItemModel({this.servicesId, this.itemName, this.subtotal, this.note});

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'services_id': servicesId!.isNotEmpty
          ? servicesId?.map((element) => element['id']).toList()
          : null,
      'services_name': servicesId!.isNotEmpty
          ? servicesId?.map((element) => element['name']).toList()
          : null,
      'subtotal': getItemSubtotal(servicesId),
      'note': note
    };
  }

  int getItemSubtotal(items) {
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
