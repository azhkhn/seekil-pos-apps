import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/partnership_model.dart';
import 'package:seekil_back_office/repository/partnership_repository.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDropPointList extends StatefulWidget {
  const StoreDropPointList({Key? key}) : super(key: key);

  @override
  State<StoreDropPointList> createState() => _StoreDropPointListState();
}

class _StoreDropPointListState extends State<StoreDropPointList>
    with AutomaticKeepAliveClientMixin {
  late Future<List<PartnershipModel>> dropPointList;

  @override
  void initState() {
    super.initState();
    fetchDropPointList();
  }

  Future<void> fetchDropPointList() async {
    dropPointList = PartnershipRepository.fetchMasterPartnership();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: dropPointList,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return LoadingIndicator();
          case ConnectionState.done:
            if (snapshot.hasData) {
              List<PartnershipModel> data =
                  snapshot.data as List<PartnershipModel>;
              return ListView.separated(
                itemCount: data.length,
                padding: const EdgeInsets.all(16.0),
                separatorBuilder: (context, index) => SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  PartnershipModel item = data[index];
                  return GestureDetector(
                    onTap: () => _showDetailDropPoint(item),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        // boxShadow: [
                        //   BoxShadow(blurRadius: 20.0, offset: Offset(0, 15.0))
                        // ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  item.address!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          OutlinedButton(
                            onPressed: () async {
                              String url =
                                  'http://maps.google.com/?q=${item.name}';
                              await canLaunch(url)
                                  ? launch(url)
                                  : Fluttertoast.showToast(
                                      msg:
                                          'Terjadi Kesalahan saat membuka peta');
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: ColorConstant.DEF,
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Peta",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstant.DEF,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            );
        }
      },
    );
  }

  void _showDetailDropPoint(PartnershipModel item) {
    WidgetHelper.bottomSheet(
      this.context,
      onClosing: () => Get.back(),
      title: 'Detail Drop Point',
      child: Form(
        child: Column(
          children: [
            MyFormField(label: 'Nama'),
            MyFormField(label: 'Whatsapp'),
            MyFormField(label: 'Alamat'),
            MyFormField(
              label: 'Potongan',
              textInputType: TextInputType.number,
            ),
            MyFormField(label: 'Jadikan sebagai drop point'),
            WidgetHelper.bottomSheetButton(onPressed: () {}, title: 'Simpan'),
          ],
        ),
      ),
    );
  }
}
