import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generate_pdf_invoice_example/bindings/FormBindings.dart';
import 'package:generate_pdf_invoice_example/page/pdf_page.dart';
import 'package:generate_pdf_invoice_example/page/splash_page.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'MyPages.dart';
import 'Translations.dart';
import 'controllers/AdmobController.dart';
import 'page/invoice_info_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  MobileAds.instance.initialize();

  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // await MobileAds.initialize(
  //   bannerAdUnitId: MyAdmob.getBannerAdId(),
  //   interstitialAdUnitId: MyAdmob.getInterstitialAdId(),
  //   appOpenAdUnitId: MyAdmob.getOpenAdId(),
  // );
  // await MobileAds.requestTrackingAuthorization();
  // RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("34FEAA5868007783EAE019607349D798"))
  // MobileAds.setTestDeviceIds(['34FEAA5868007783EAE019607349D798']);
  // Get.put(AdmobController());
  Get.lazyPut(() => AdmobController());

  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // Admob.requestTrackingAuthorization();
  //
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.greenAccent,
  // ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Invoice';

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        locale: Get.deviceLocale,
        translations: MyTransalations(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: SplashPage(),
        getPages: [
           GetPage(name: Routes.SPLASH, page:()=> SplashPage(),),
           GetPage(name: Routes.INVOICE_FORM, page:()=> InvoiceInfoPage(), binding: FormBinding()),
        ],
      );
}

//TODO:
//when adding just one item it throws the error "please add items"

// verify when pressing generate invoice if total sum let's say is 110(item1 of 60 and item2 of 50) it throws the error "total expected can not be higher than
//total paid even if total sum its the same amount, it still throws the error or if it's higher