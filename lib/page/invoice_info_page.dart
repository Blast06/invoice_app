import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/FormController.dart';

class InvoiceInfoPage extends GetView<FormController> {
  const InvoiceInfoPage({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('INVOICE_PAGE_TITLE'.tr)),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formFormKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Fill the fields below', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
              const Text('To generate the Invoice',style: TextStyle(fontSize: 17)),
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: controller.validator,
              ),
              TextFormField(
                controller: controller.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: controller.validator,
                obscureText: true,
              ),
              RaisedButton(
                child: Text('Login'),
                onPressed: controller.login,
              )
            ],
          ),
        ),
      ),
    );
  }
}
