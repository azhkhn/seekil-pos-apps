import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';
import 'package:seekil_back_office/modules/expenditure/fixed_monthly/controller.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/expenditure/empty_list.dart';
import 'package:seekil_back_office/widgets/expenditure/error_list.dart';
import 'package:seekil_back_office/widgets/expenditure/expenditure_list.dart';
import 'package:seekil_back_office/widgets/expenditure/loading_list.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class ExpenditureFixedMonthly extends StatelessWidget {
  ExpenditureFixedMonthly({Key? key}) : super(key: key);
  final controller = Get.put(ExpenditureFixedMonthlyController());
  final WordTransformation wt = WordTransformation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper.appBar('Pengeluaran Tetap Bulanan'),
        floatingActionButton: FloatingActionButton(
          onPressed: _modalFormAdd,
          backgroundColor: ColorConstant.DEF,
          child: Icon(Icons.add_rounded),
        ),
        body: Stack(
          children: [
            RefreshIndicator(
                onRefresh: controller.fetchFixedMonthlyData,
                child: controller.obx(
                  (state) => ExpenditureList(
                    state['list'],
                    onEdit: (ExpenditureModel item) {
                      _editForm(item);
                    },
                  ),
                  onLoading: ExpenditureLoadingList(),
                  onEmpty: ExpenditureEmptyList(),
                  onError: (error) => ExpenditureErrorList(
                    error: error,
                  ),
                )),
            Obx(() => Visibility(
                visible: controller.isLoading.isTrue,
                child: LoadingIndicator()))
          ],
        ));
  }

  void _modalFormAdd() {
    ExpenditureModel model = new ExpenditureModel();

    Get.dialog(
        AlertDialog(
          title: Text('Tambah data pengeluaran'),
          content: Form(
            key: controller.formKey,
            child: Wrap(
              children: [
                MyFormField(
                  label: 'Nama',
                  isMandatory: true,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Nama harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model.name = value;
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
                MyFormField(
                  label: 'Harga',
                  isMandatory: true,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Harga harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model.price = int.parse(value);
                  },
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Batal', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(primary: ColorConstant.DEF),
            ),
            TextButton(
              onPressed: () => controller.onSavedForm(model),
              child: Text('Simpan',
                  style: TextStyle(
                      color: ColorConstant.DEF, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        barrierDismissible: false);
  }

  void _editForm(ExpenditureModel item) {
    Map<String, dynamic> formDataJson = {
      'name': item.name,
      'description': item.description,
      'price': item.price,
    };

    Get.bottomSheet(
      BottomSheet(
          onClosing: () => Get.back(),
          enableDrag: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          )),
          builder: (context) => Container(
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
                          Text('Edit',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    MyFormField(
                      label: 'Nama',
                      initialValue: formDataJson['name'],
                      onChanged: (value) => formDataJson['name'] = value,
                    ),
                    MyFormField(
                      label: 'Deskripsi',
                      initialValue: formDataJson['description'],
                      onChanged: (value) => formDataJson['description'] = value,
                    ),
                    MyFormField(
                      label: 'Harga',
                      initialValue: formDataJson['price'].toString(),
                      textInputType: TextInputType.number,
                      onChanged: (value) => formDataJson['price'] = value,
                    ),
                    Container(
                      width: Get.width,
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () => controller.onUpdateItem(
                            item.id.toString(), formDataJson),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                        ),
                      ),
                    ),
                    Container(
                      width: Get.width,
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            controller.onDeleteItem(item.id.toString()),
                        child: Text(
                          'Hapus',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: ColorConstant.ERROR_BORDER,
                          padding: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
      isScrollControlled: true,
    );
  }
}
