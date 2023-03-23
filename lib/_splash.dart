import 'package:flutter/material.dart';

import '_global_data.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future startAnimation(context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  title: '',
                  globalData: GlobalData(),
                  globalDataStream: GlobalDataStream(),
                )));
  }

  @override
  void initState() {
    super.initState();
    startAnimation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/splash/logo.gif')),
    );
  }
}
