import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';

class AllOrderSearchBar extends StatelessWidget {
  AllOrderSearchBar({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 24.0),
      child: TextFormField(
        cursorColor: ColorConstant.DEF,
        controller: controller.searchController,
        onFieldSubmitted: controller.handleSearchBar,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          isDense: true,
          prefixIcon: Icon(Icons.search),
          prefixIconConstraints: BoxConstraints(minWidth: 32),
          hintText: 'Cari nama pelanggan',
          hintStyle: TextStyle(fontSize: 14.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIconConstraints: BoxConstraints(minWidth: 32),
          suffixIcon: controller.searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: controller.resetSearchBar,
                  child: Icon(Icons.close_rounded),
                )
              : null,
          suffixIconColor: controller.searchController.text.isNotEmpty
              ? Colors.black54
              : null,
        ),
      ),
    );
  }
}
