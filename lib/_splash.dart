import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '_global_data_stream.dart';
import '_globals.dart';
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/splash/logo.gif'),
            const SizedBox(height: 1),
            Text('INSPIRED BY - UKK IUS WOLVES'.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ]),
    );
  }
}
