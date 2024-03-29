



import 'package:generate_pdf_invoice_example/page/form_screen.dart';
import 'package:generate_pdf_invoice_example/page/invoice_info_page.dart';
import 'package:generate_pdf_invoice_example/page/splash_page.dart';
import 'package:get/get.dart';
part './routes.dart';

abstract class AppPages {

  static final pages = [
    GetPage(name: Routes.SPLASH, page:()=> SplashPage(),),
    GetPage(name: Routes.INVOICE_FORM, page:()=> InvoiceInfoPage(),),
    GetPage(name: Routes.FORM_SCREEN, page:()=> FormScreen(),),
    
  ];
}