import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';

class AllOrderSearchBar extends StatelessWidget {
  AllOrderSearchBar({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        cursorColor: ColorConstant.DEF,
        controller: controller.searchController,
        onFieldSubmitted: controller.handleSearchBar,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          suffixIconConstraints: BoxConstraints(minWidth: 32),
          isDense: true,
          prefixIcon: Icon(Icons.search),
          prefixIconConstraints: BoxConstraints(minWidth: 32),
          hintText: 'Cari Nama Pelanggan',
          hintStyle: TextStyle(fontSize: 14.0),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          suffixIcon: controller.searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: controller.resetSearchBar,
                  child: Icon(Icons.close_rounded),
                )
              : null,
        ),
      ),
    );
  }
}
