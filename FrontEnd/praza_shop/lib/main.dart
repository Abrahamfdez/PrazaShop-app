import 'package:flutter/material.dart';
import 'package:praza_shop/screens/Auth/login_page.dart';
import 'package:praza_shop/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final api = ApiService('https://prazashop-app.onrender.com');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PrazaShop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(api: api),
    );
  }
}

