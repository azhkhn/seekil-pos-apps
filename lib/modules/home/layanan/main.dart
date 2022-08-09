import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/services_list.model.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late Future<List<dynamic>> servicesList;
  final WordTransformation wt = WordTransformation();

  @override
  void initState() {
    super.initState();
    fetchServicesList();
  }

  fetchServicesList() {
    servicesList = MasterDataModel.fetchMasterServices();
    setState(() {});
  }

  void _onAddServices(ServicesListModel model) async {
    try {
      Get.back();
      bool isCreated = await ServicesListModel.createNewServices(model);

      if (isCreated) {
        Fluttertoast.showToast(msg: 'Berhasil tambah layanan');
        fetchServicesList();
      } else {
        Fluttertoast.showToast(msg: 'Gagal tambah layanan');
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
    }
  }

  _onUpdateServices(String id, Map<String, dynamic> data) async {
    try {
      Get.back();
      bool isUpdated = await ServicesListModel.updateServicesById(id, data);

      if (isUpdated) {
        Fluttertoast.showToast(msg: 'Berhasil update layanan');
        fetchServicesList();
      } else {
        Fluttertoast.showToast(msg: 'Gagal update layanan');
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
    }
  }

  _onDeleteServices(String id) async {
    try {
      Get.back();
      bool isDeleted = await ServicesListModel.deleteServicesById(id);

      if (isDeleted) {
        Fluttertoast.showToast(msg: 'Berhasil hapus layanan');
        fetchServicesList();
      } else {
        Fluttertoast.showToast(msg: 'Gagal hapus layanan');
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper.appBar('Layanan'),
        floatingActionButton: AuthHelper.isSuperAdmin()
            ? FloatingActionButton(
                backgroundColor: ColorConstant.DEF,
                onPressed: _showBottomSheetAddServices,
                child: Icon(Icons.add_outlined),
              )
            : null,
        body: FutureBuilder(
          future: servicesList,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return LoadingIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data as List<dynamic>;
                  return ListView.builder(
                    itemCount: data.length,
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      var item = data[index];
                      return InkWell(
                        onTap: () {
                          _showBottomSheetEditServices(item);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(item['name'],
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              item['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              wt.currencyFormat(item['price']),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: Text('Tidak ada data'),
                );
            }
          },
        ));
  }

  void _showBottomSheetAddServices() {
    ServicesListModel model = new ServicesListModel();
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
                        onTap: () => Get.back(),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Tambah Layanan',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                MyFormField(
                  label: 'Nama Layanan',
                  isMandatory: true,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Nama layanan harus diisi';
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
                  label: 'Estimasi (hari)',
                  isMandatory: true,
                  textInputType: TextInputType.number,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Estimasi harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model.estimate = value;
                  },
                ),
                MyFormField(
                  label: 'Harga',
                  isMandatory: true,
                  textInputType: TextInputType.number,
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
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _onAddServices(model),
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
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showBottomSheetEditServices(item) {
    ServicesListModel model = new ServicesListModel();
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
                        onTap: () => Get.back(),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Edit Layanan',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                MyFormField(
                  label: 'Nama Layanan',
                  isMandatory: true,
                  initialValue: item['name'],
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Nama layanan harus diisi';
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
                  initialValue: item['description'],
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
                  label: 'Estimasi (hari)',
                  isMandatory: true,
                  initialValue: item['estimate'],
                  textInputType: TextInputType.number,
                  textFieldValidator: (value) {
                    if (value == null || value == '') {
                      return 'Estimasi harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model.estimate = value;
                  },
                ),
                MyFormField(
                  label: 'Harga',
                  isMandatory: true,
                  initialValue: item['price'].toString(),
                  textInputType: TextInputType.number,
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
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _onUpdateServices(
                      item['id'].toString(),
                      model.toJson(),
                    ),
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
                    onPressed: () => _onDeleteServices(item['id'].toString()),
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
    );
  }
}
