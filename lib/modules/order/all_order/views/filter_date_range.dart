import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';

class AllOrderFilterDateRange extends StatelessWidget {
  AllOrderFilterDateRange(this.modalFilter, {Key? key}) : super(key: key);
  final void Function() modalFilter;
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rentang Waktu',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: controller.filterDateList.length,
            itemBuilder: (context, index) => Obx(
              () {
                var lists = controller.filterDateList[index];
                return RadioListTile(
                  value: lists,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: ColorConstant.DEF,
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: controller.gvFilterDate.value,
                  selected: controller.gvFilterDate.value == lists,
                  onChanged: (dynamic value) {
                    if (value['value'] == 'custom')
                      _customDateFilter();
                    else
                      controller.onChangedDate(value);
                  },
                  title: Text(
                    lists['name'] as String,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _customDateFilter() {
    Get.back();
    Get.bottomSheet(
      BottomSheet(
        onClosing: () {
          Get.back();
          modalFilter();
        },
        backgroundColor: Colors.white,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.0),
            topLeft: Radius.circular(24.0),
          ),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child: Wrap(
            children: [
              _customDateFilterTitle(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _startDateSelection(),
                    SizedBox(width: 16.0),
                    _endDateSelection(),
                  ],
                ),
              ),
              _buttonApply()
            ],
          ),
        ),
      ),
    );
  }

  Widget _customDateFilterTitle() => Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            padding: EdgeInsets.all(4.0),
            onPressed: () {
              Get.back();
              modalFilter();
            },
          ),
          SizedBox(width: 4.0),
          Text(
            'Atur Rentang Waktu',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18.0,
            ),
          )
        ],
      );

  Widget _startDateSelection() => Expanded(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 64.0,
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dari',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      '01 Jan 2022',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.date_range_outlined,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      );

  Widget _endDateSelection() => Expanded(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 64.0,
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sampai',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      '10 Jan 2022',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.date_range_outlined,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      );

  Widget _buttonApply() => Container(
        width: Get.width,
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Pasang'),
          style: ElevatedButton.styleFrom(
            primary: ColorConstant.DEF,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
