import 'package:billing_project/screens/billing_screen.dart';
import 'package:billing_project/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppText.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BillingScreen(),
    );
  }
}
