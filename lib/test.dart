import 'dart:ui';

import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/a2liga.png'),
            fit: BoxFit.scaleDown,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 108, 14, 14).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("test")),
        ));
  }
}
