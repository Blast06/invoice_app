import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../controllers/SplashController.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final sp = Get.put(SplashController());
  late RiveAnimationController _controller;
  @override
  void initState() {
    super.initState();
    // _controller = SimpleAnimation('idle', autoplay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              /// Para fines practicos usarremos esta animacion
              /// disponible en linea.
              child: RiveAnimation.asset(
                'assets/splash4.riv',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'loading_txt'.tr,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
