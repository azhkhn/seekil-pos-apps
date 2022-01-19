import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';
import 'package:seekil_back_office/modules/home/views/card_current_month.dart';
import 'package:seekil_back_office/modules/home/views/card_staff.dart';
import 'package:seekil_back_office/modules/home/views/content_staff.dart';
import 'package:seekil_back_office/modules/home/views/others.dart';
import 'package:seekil_back_office/modules/home/views/store_feature.dart';
import 'package:seekil_back_office/modules/home/views/user_header.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WordTransformation wt = WordTransformation();
  late Future<Map<String, dynamic>> data;
  final box = GetStorage();
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();
    initialFetchMasterData();
  }

  Future<void> initialFetchMasterData() async {
    setState(() {
      data = ExpenditureModel.fetchCashFlowCurrentMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorConstant.DEF,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light),
        ),
        body: RefreshIndicator(
            onRefresh: initialFetchMasterData,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  Container(
                    height: kToolbarHeight * 3,
                    color: ColorConstant.DEF,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeGreetings(_onLogout),
                      if (AuthHelper.isStaff()) HomeCardStaff(data),
                      if (AuthHelper.isSuperAdmin()) HomeCardCurrentMonth(data),
                      if (AuthHelper.isSuperAdmin()) HomeStoreFeature(),
                      if (AuthHelper.isSuperAdmin()) HomeOthers(),
                      if (AuthHelper.isStaff()) HomeContentStaff()
                    ],
                  ),
                  if (_showLoading)
                    Container(
                      height: Get.height,
                      width: Get.width,
                      alignment: Alignment.center,
                      child: LoadingIndicator(),
                    )
                ],
              ),
            )));
  }

  void _onLogout() async {
    try {
      Get.back();
      setState(() {
        _showLoading = !_showLoading;
      });
      await Future.delayed(Duration(milliseconds: 500));
      GetStorage().remove(StorageKeyConstant.USER_LOGGED_IN);
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
    } finally {
      setState(() {
        _showLoading = !_showLoading;
      });
    }
  }
}
