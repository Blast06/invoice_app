

import 'package:get/get.dart';

import '../controllers/FormController.dart';

class FormBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FormController());
  }
}