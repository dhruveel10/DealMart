import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dealmart/pages/home_page.dart';
import 'package:dealmart/pages/order_page.dart';
import 'package:dealmart/pages/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late HomePage homePage;
  late OrderPage orderPage;
  late ProfilePage profilePage;
  int currentIndex = 0;

  @override
  void initState() {
    homePage = HomePage();
    orderPage = OrderPage();
    profilePage = ProfilePage();
    pages = [homePage, orderPage, profilePage];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Color(0xfff2f2f2),
        color: Colors.black,
        animationDuration: Duration(milliseconds: 200),
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
