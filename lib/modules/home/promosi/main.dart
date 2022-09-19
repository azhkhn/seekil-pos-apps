import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/promo_model.dart';
import 'package:seekil_back_office/modules/home/promosi/controller.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class PromotionPage extends StatelessWidget {
  PromotionPage({Key? key}) : super(key: key);
  final controller = Get.put(PromoController());
  final WordTransformation wt = WordTransformation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Promosi'),
      floatingActionButton: AuthHelper.isSuperAdmin()
          ? FloatingActionButton(
              onPressed: _showBottomSheetAddPromo,
              backgroundColor: ColorConstant.DEF,
              child: Icon(Icons.add_rounded),
            )
          : null,
      body: Stack(
        children: [
          Obx(
            () => Visibility(
              visible: controller.isLoading.isTrue,
              child: LoadingIndicator(),
            ),
          ),
          controller.obx(
            (state) {
              return RefreshIndicator(
                onRefresh: controller.fetchPromoList,
                child: ListView.separated(
                  padding: EdgeInsets.all(16.0),
                  itemCount: state.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    PromoModel item = state[index];
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0),
                              ),
                              Switch(
                                activeColor: ColorConstant.DEF,
                                value: controller.valueSwitchPromo(item.status),
                                onChanged: (value) {
                                  controller.onChangeSwitchPromo(
                                      value, index, item);
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Kode promo: ${item.code!}'),
                              SizedBox(width: 4.0),
                              WidgetHelper.badgeText('${item.discount!}%'),
                            ],
                          ),
                          Text(item.description!.trim()),
                          SizedBox(height: 4.0),
                          if (item.endDate != null)
                            Text(
                              'Valid thru: ${wt.dateFormatter(date: item.endDate!)}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          SizedBox(height: 4.0),
                          if (item.selfPrice != null)
                            Text(
                              wt.currencyFormat(item.selfPrice),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            onEmpty: _onEmptyList(),
          )
        ],
      ),
    );
  }

  Widget _onEmptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Tidak ada data promo',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tap tombol ',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Icon(Icons.add_circle),
            Text(
              ' untuk buat promosi baru',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showBottomSheetAddPromo() {
    PromoModel model = new PromoModel();
    Get.bottomSheet(
      BottomSheet(
        onClosing: () => Get.back(),
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        builder: (context) {
          return Form(
            key: controller.addPromoFormKey,
            child: Container(
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
                        Text(
                          'Tambah Promo',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  MyFormField(
                    label: 'Nama Promo',
                    isMandatory: true,
                    textFieldValidator: (value) {
                      if (value == null || value == '') {
                        return 'Nama promo harus diisi';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      model.name = value;
                    },
                  ),
                  MyFormField(
                    label: 'Kode Promo',
                    isMandatory: true,
                    textFieldValidator: (value) {
                      if (value == null || value == '') {
                        return 'Kode promo harus diisi';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      model.code = value;
                    },
                  ),
                  MyFormField(
                    label: 'Diskon (%)',
                    isMandatory: true,
                    textInputType: TextInputType.number,
                    textFieldValidator: (value) {
                      if (value == null || value == '') {
                        return 'Diskon harus diisi';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      model.discount = int.parse(value);
                    },
                  ),
                  MyFormField(
                    label: 'Deskripsi',
                    isMandatory: true,
                    textFieldValidator: (value) {
                      if (value == null || value == '') {
                        return 'Deskripsi harus diisi';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      model.description = value;
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _startDateSelection(context, model),
                        SizedBox(width: 16.0),
                        _endDateSelection(context, model),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Status',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Text('*', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Obx(
                          () => Switch(
                            value: controller.addPromoSwitchValue.value,
                            activeColor: ColorConstant.DEF,
                            onChanged: (value) {
                              controller.addPromoSwitchValue.value = value;
                              if (value) {
                                model.status = 1;
                              } else {
                                model.status = 0;
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MyFormField(
                      label: 'Nominal Promo',
                      textInputType: TextInputType.number,
                      onChanged: (value) {
                        model.selfPrice = int.parse(value);
                      },
                    ),
                  ),
                  Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () => controller.onAddPromo(model),
                      child: Text(
                        'Tambah',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: ColorConstant.DEF,
                        padding: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showBottomSheetEditServices(item) {
    PromoModel model = new PromoModel();
    Get.bottomSheet(
      BottomSheet(
        onClosing: () => Get.back(),
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.close_rounded),
                        onTap: () {
                          controller.resetDateValue();
                          Get.back();
                        },
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Edit Promo',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                MyFormField(
                  label: 'Nama Promo',
                  isMandatory: true,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Nama promo harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model.name = value;
                  },
                ),
                MyFormField(
                  label: 'Kode Promo',
                  isMandatory: true,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Kode promo harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model.code = value;
                  },
                ),
                MyFormField(
                  label: 'Diskon (%)',
                  isMandatory: true,
                  textInputType: TextInputType.number,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Diskon harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model.discount = int.parse(value);
                  },
                ),
                MyFormField(
                  label: 'Deskripsi',
                  isMandatory: true,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Deskripsi harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model.description = value;
                  },
                ),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: ColorConstant.DEF,
                      padding: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: ColorConstant.ERROR,
                      padding: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      isDismissible: false,
    );
  }

  Widget _startDateSelection(BuildContext context, PromoModel model) =>
      Expanded(
        child: GestureDetector(
          onTap: () async {
            DateTime? pickedDateTime = await controller.selectDate(context);
            controller.onSelectedDate(pickedDateTime, 'start_date');
            model.startDate = pickedDateTime.toString();
          },
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
      );

  Widget _endDateSelection(BuildContext context, PromoModel model) => Expanded(
        child: GestureDetector(
          onTap: () async {
            DateTime? pickedDateTime = await controller.selectDate(context);
            controller.onSelectedDate(pickedDateTime, 'end_date');
            model.endDate = pickedDateTime.toString();
          },
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
      );
}
