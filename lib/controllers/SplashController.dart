import 'package:flutter/material.dart';
import 'package:generate_pdf_invoice_example/AppOpenAdManager.dart';
import 'package:generate_pdf_invoice_example/MyPages.dart';
import 'package:generate_pdf_invoice_example/page/form_screen.dart';
import 'package:generate_pdf_invoice_example/page/invoice_info_page.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../page/pdf_page.dart';
import 'AdmobController.dart';

class SplashController extends GetxController {
  final admob = Get.find<AdmobController>();
  Logger log = Logger();

  bool showInterstitial = false;

  @override
  void onReady() async {
    log.i("onReady of splash controller");

    super.onReady();
    // await admob.loadAd();

    await Future.delayed(Duration(seconds: 5), () {
      // admob.showAdIfAvailable();
      // Get.offAndToNamed(Routes.FORM_SCREEN);
      Get.offAll(FormScreen());
    });
  }

  void onInit() async {
    super.onInit();
    log.i("Init of splash controller");
    // await prepareApi();
    // await admob.loadInterstitial();
  }
}
