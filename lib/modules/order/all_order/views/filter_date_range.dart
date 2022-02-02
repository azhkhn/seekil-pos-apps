import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class AllOrderFilterDateRange extends StatelessWidget {
  AllOrderFilterDateRange(this.modalFilter, {Key? key}) : super(key: key);
  final void Function() modalFilter;
  final controller = Get.put(AllOrderController());
  final WordTransformation wt = WordTransformation();

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
                  // ignore: invalid_use_of_protected_member
                  groupValue: controller.gvFilterDate.value,
                  // ignore: invalid_use_of_protected_member
                  selected: controller.gvFilterDate.value == lists,
                  title: _hasSelectedDate(lists),
                  onChanged: (dynamic value) {
                    if (value['value'] == 'custom') {
                      controller.gvFilterDate.value = value;
                      _customDateFilter();
                    } else {
                      controller.resetSelectedDate();
                      controller.onChangedDate(value);
                    }
                  },
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
                    _startDateSelection(context),
                    SizedBox(width: 16.0),
                    _endDateSelection(context),
                  ],
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.isStartDateBeforeEndDate(),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Tanggal awal harus sebelum tanggal akhir',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              _buttonApply()
            ],
          ),
        ),
      ),
      isDismissible: false,
    );
  }

  Widget _customDateFilterTitle() => Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            padding: EdgeInsets.all(4.0),
            onPressed: () {
              if (!controller.hasDateValue()) {
                controller.resetSelectedDate();
              }
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

  Widget _startDateSelection(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: () async {
            controller.showBorderStartDate.value = true;
            DateTime? pickedDateTime = await _selectDate(context);
            controller.onSelectedDate(pickedDateTime, 'start_date');
            controller.showBorderStartDate.value = false;
          },
          child: Obx(
            () => Container(
              height: 64.0,
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                  width: controller.showBorderStartDate.isTrue ? 2.0 : 0.0,
                  color: controller.showBorderStartDate.isTrue
                      ? ColorConstant.DEF
                      : Colors.transparent,
                ),
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
                      Obx(() {
                        String endDate = controller
                            .selectedDateTitle.value['start_date']
                            .toString();
                        DateTime sevenDaysFromNow = DateTime.now();
                        String formatedSevenDaysFromNow =
                            DateFormat('dd MMM y').format(sevenDaysFromNow);
                        bool hasEndDate = endDate != '';
                        return Text(
                          hasEndDate ? endDate : formatedSevenDaysFromNow,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        );
                      }),
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
        ),
      );

  Widget _endDateSelection(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: () async {
            controller.showBorderEndDate.value = true;
            DateTime? pickedDateTime = await _selectDate(context);
            controller.onSelectedDate(pickedDateTime, 'end_date');
            controller.showBorderEndDate.value = false;
          },
          child: Obx(
            () => Container(
              height: 64.0,
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                  width: controller.showBorderEndDate.isTrue ? 2.0 : 0.0,
                  color: controller.showBorderEndDate.isTrue
                      ? ColorConstant.DEF
                      : Colors.transparent,
                ),
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
                      Obx(() {
                        String endDate = controller
                            .selectedDateTitle.value['end_date']
                            .toString();
                        DateTime sevenDaysFromNow =
                            DateTime.now().add(Duration(days: 7));
                        String formatedSevenDaysFromNow =
                            DateFormat('dd MMM y').format(sevenDaysFromNow);
                        bool hasEndDate = endDate != '';
                        return Text(
                          hasEndDate ? endDate : formatedSevenDaysFromNow,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        );
                      }),
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
        ),
      );

  Widget _buttonApply() => Container(
        width: Get.width,
        child: Obx(
          () => ElevatedButton(
            onPressed: !controller.isStartDateBeforeEndDate()
                ? () {
                    Get.back();
                    modalFilter();
                  }
                : null,
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
        ),
      );

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 356)),
      lastDate: DateTime.now().add(Duration(days: 356)),
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (pickedDateTime != null) {
      return pickedDateTime;
    } else {
      return DateTime.now();
    }
  }

  Widget _hasSelectedDate(dynamic lists) {
    var startDate = controller.selectedDateTitle.value['start_date'];
    var endDate = controller.selectedDateTitle.value['end_date'];
    bool isCustomDate = lists['value'] == 'custom';

    if (isCustomDate && startDate != '' && endDate != '') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lists['name'] as String,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$startDate - $endDate',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              fontSize: 15.0,
            ),
          )
        ],
      );
    }

    return Text(
      lists['name'] as String,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
