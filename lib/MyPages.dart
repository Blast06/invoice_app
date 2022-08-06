



import 'package:generate_pdf_invoice_example/page/invoice_info_page.dart';
import 'package:generate_pdf_invoice_example/page/splash_page.dart';
import 'package:get/get.dart';
part './routes.dart';

abstract class AppPages {

  static final pages = [
    GetPage(name: Routes.SPLASH, page:()=> InvoiceInfoPage(),),
    GetPage(name: Routes.INVOICE_FORM, page:()=> SplashPage(),),
    
  ];
}