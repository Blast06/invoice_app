import 'dart:io';

import 'package:generate_pdf_invoice_example/MyAdmob.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:logger/logger.dart';

import '../AppOpenAdManager.dart';

const TEST = true;

class AdmobController extends GetxController {
  // AdmobInterstitial interstitialAd;
  // late InterstitialAd interstitialAd;

  // late AppOpenAd appOpenAd;

  // final bannerController = BannerAdController();

  String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/3419835294'
      : 'ca-app-pub-3940256099942544/5662855259';

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  Logger logger = Logger();

  @override
  void onInit() async {
    super.onInit();
    
     await loadAd();
    
    logger.i("ADMOB CONTROLLER STARTED");
  }

  void onClose() {
    // bannerController.dispose();
  }

  /// Load an AppOpenAd.
  Future<void> loadAd() async {
    logger.v("ADMOB LOADED 😍😍");
    AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    logger.v("SHOWIFAVAIBLABLE 😍😍");
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }

  String? getAdMobAppId() {
    if (Platform.isIOS) {
      return TEST ? MyAdmob.TEST_app_id_ios : MyAdmob.PROD_app_id_ios;
    } else if (Platform.isAndroid) {
      return TEST ? MyAdmob.TEST_app_id_android : MyAdmob.PROD_app_id_android;
    }
    return null;
  }

  String? getBannerAdId() {
    if (Platform.isIOS) {
      // return ;
      return TEST ? MyAdmob.TEST_banner_id_ios : MyAdmob.PROD_banner_id_ios;
    } else if (Platform.isAndroid) {
      // return ;
      return TEST
          ? MyAdmob.TEST_banner_id_android
          : MyAdmob.PROD_banner_id_android;
    }
    return null;
  }

  // String? getInterstitialAdId() {
  //   if (Platform.isIOS) {
  //     return TEST
  //         ? MyAdmob.TEST_interstitial_id_ios
  //         : MyAdmob.PROD_interstitial_id_ios;
  //   } else if (Platform.isAndroid) {
  //     return TEST
  //         ? MyAdmob.TEST_interstitial_id_android
  //         : MyAdmob.PROD_interstitial_id_android;
  //   }
  //   return null;
  // }

  String? getOpenAdId() {
    if (Platform.isIOS) {
      return TEST ? MyAdmob.TEST_open_ad_id_ios : MyAdmob.PROD_open_ad_id_ios;
    } else if (Platform.isAndroid) {
      return TEST
          ? MyAdmob.TEST_open_ad_id_android
          : MyAdmob.PROD_open_ad_id_android;
    }
    return null;
  }

  // loadInterstitial() {
  //   interstitialAd = InterstitialAd(unitId: getInterstitialAdId());
  //   logger.i("interstitial loading..");

  //   interstitialAd.load();
  // }

  // showInterstitial() async {
  //   if (interstitialAd.isLoaded) {
  //     logger.i("interstitial is loaded");
  //     interstitialAd.show();
  //   }
  // }

  // loadOpenad() {
  //   appOpenAd = AppOpenAd(timeout: Duration(minutes: 30) );

  //   appOpenAd.load(orientation: AppOpenAd.ORIENTATION_PORTRAIT);
  // }

  // showAppOpen() async {
  //   if (!appOpenAd.isAvailable) await appOpenAd.load();
  //   if (appOpenAd.isAvailable) {
  //     await appOpenAd.show();
  //     // Load a new ad right after the other one was closed
  //     appOpenAd.load();
  //   }
  // }

  // showBanner() async {
  //   bannerController.onEvent.listen((e) {
  //     final event = e.keys.first;
  //     // final info = e.values.first;
  //     switch (event) {
  //       case BannerAdEvent.loaded:
  //         // setState(() => _bannerAdHeight = (info as int)?.toDouble());
  //         break;
  //       default:
  //         break;
  //     }
  //   });
  //   bannerController.load();
  // }
}
