import 'package:dealmart/pages/bottom_nav.dart';
import 'package:dealmart/pages/home_page.dart';
import 'package:dealmart/pages/login_page.dart';
import 'package:dealmart/pages/onbaording_page.dart';
import 'package:dealmart/pages/product_details.dart';
import 'package:dealmart/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dealmart/admin/add_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomNav(),
    );
  }
}
