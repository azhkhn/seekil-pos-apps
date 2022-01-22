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
      child: Obx(
        () => TextFormField(
          key: Key(controller.searchInput.value),
          cursorColor: ColorConstant.DEF,
          initialValue: controller.searchInput.value,
          onFieldSubmitted: controller.handleSearchBar,
          textInputAction: TextInputAction.search,
          onChanged: controller.onChangeSearchInput,
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: Colors.grey[200],
            hintText: 'Cari Nama Pelanggan',
            hintStyle: TextStyle(fontSize: 14.0),
            suffixIconConstraints: BoxConstraints(minWidth: 40.0),
            prefixIconConstraints: BoxConstraints(minWidth: 40.0),
            prefixIcon: Icon(Icons.search, color: ColorConstant.DEF),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            suffixIcon: controller.searchInput.value.isNotEmpty
                ? GestureDetector(
                    onTap: controller.resetSearchBar,
                    child: Icon(Icons.close_rounded, color: ColorConstant.DEF),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
