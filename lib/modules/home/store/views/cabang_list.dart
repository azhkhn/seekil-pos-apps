import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/store_model.dart';
import 'package:seekil_back_office/repository/store_repository.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCabangList extends StatefulWidget {
  const StoreCabangList({Key? key}) : super(key: key);

  @override
  State<StoreCabangList> createState() => _StoreCabangListState();
}

class _StoreCabangListState extends State<StoreCabangList>
    with AutomaticKeepAliveClientMixin {
  late Future<List<StoreModel>> storeList;

  @override
  void initState() {
    super.initState();
    fetchStoreList();
  }

  Future<void> fetchStoreList() async {
    storeList = StoreRepository.fetchMasterStore();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: storeList,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return LoadingIndicator();
          case ConnectionState.done:
            if (snapshot.hasData) {
              List<StoreModel> data = snapshot.data as List<StoreModel>;
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: data.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8.0);
                },
                itemBuilder: (context, index) {
                  StoreModel item = data[index];
                  return GestureDetector(
                    onTap: () => _showDetailStore(item),
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
                                  item.staging!,
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
                                  'http://maps.google.com/?q=Seekil Cuci Sepatu dan Apparel Cirebon';
                              await canLaunch(url)
                                  ? launch(url)
                                  : Fluttertoast.showToast(
                                      msg:
                                          'Terjadi Kesalahan saat membuka peta');
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                const BorderSide(
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

  void _showDetailStore(StoreModel item) {
    WidgetHelper.bottomSheet(
      this.context,
      onClosing: () => Get.back(),
      title: 'Detail Cabang',
      child: Form(
        child: Column(
          children: [
            MyFormField(label: 'Cabang'),
            MyFormField(label: 'Alamat'),
            WidgetHelper.bottomSheetButton(onPressed: () {}, title: 'Simpan'),
          ],
        ),
      ),
    );
  }
}
