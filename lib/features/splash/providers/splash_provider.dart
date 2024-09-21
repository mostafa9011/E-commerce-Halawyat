import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/models/popup_model.dart';
import 'package:flutter_grocery/features/order/domain/models/offline_payment_model.dart';
import 'package:flutter_grocery/features/splash/domain/reposotories/splash_repo.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/utill/functions/show_pop_up_dialog.dart';
import 'package:provider/provider.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  int _pageIndex = 0;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _cookiesShow = true;
  List<OfflinePaymentModel?>? _offlinePaymentModelList;

  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  int get pageIndex => _pageIndex;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get cookiesShow => _cookiesShow;
  List<OfflinePaymentModel?>? get offlinePaymentModelList =>
      _offlinePaymentModelList;
  PopupModel? popupModel;

  Future<bool> initConfig() async {
    ApiResponseModel apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      isSuccess = true;

      if (Get.context != null) {
        final AuthProvider authProvider =
            Provider.of<AuthProvider>(Get.context!, listen: false);

        if (authProvider.getGuestId() == null && !authProvider.isLoggedIn()) {
          authProvider.addOrUpdateGuest();
        }
      }

      if (!kIsWeb) {
        if (!Provider.of<AuthProvider>(Get.context!, listen: false)
            .isLoggedIn()) {
          await Provider.of<AuthProvider>(Get.context!, listen: false)
              .updateFirebaseToken();
        }
      }

      notifyListeners();
    } else {
      isSuccess = false;
      showCustomSnackBarHelper(apiResponse.error.toString(), isError: true);
    }
    return isSuccess;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  String? getLanguageCode() {
    return splashRepo!.sharedPreferences!.getString(AppConstants.languageCode);
  }

  bool showIntro() {
    return splashRepo!.showIntro();
  }

  void disableIntro() {
    splashRepo!.disableIntro();
  }

  void cookiesStatusChange(String? data) {
    if (data != null) {
      splashRepo!.sharedPreferences!
          .setString(AppConstants.cookingManagement, data);
    }
    _cookiesShow = false;
    notifyListeners();
  }

  bool getAcceptCookiesStatus(String? data) =>
      splashRepo!.sharedPreferences!
              .getString(AppConstants.cookingManagement) !=
          null &&
      splashRepo!.sharedPreferences!
              .getString(AppConstants.cookingManagement) ==
          data;

  Future<void> getOfflinePaymentMethod(bool isReload) async {
    if (_offlinePaymentModelList == null || isReload) {
      _offlinePaymentModelList = null;
    }
    if (_offlinePaymentModelList == null) {
      ApiResponseModel apiResponse =
          await splashRepo!.getOfflinePaymentMethod();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _offlinePaymentModelList = [];

        apiResponse.response?.data.forEach((v) {
          _offlinePaymentModelList?.add(OfflinePaymentModel.fromJson(v));
        });
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
      notifyListeners();
    }
  }

  Future<void> getpopupImage() async {
    ApiResponseModel apiResponse = await splashRepo!.getpopupImage();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      List<dynamic> response = apiResponse.response!.data;
      if (response.isNotEmpty) {
        for (var element in response) {
          popupModel = PopupModel.fromJson(element);
        }
      }
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

}
