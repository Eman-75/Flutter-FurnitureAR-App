import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'product_list.dart';
import 'orders_list.dart';
import 'profile.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int myIndex = 0;
  List<Widget> widgetList =  [
    Dashboard(),
    ProductList(),
    OrderList(),
    Profile()
  ];
  Widget Insights_Card(IconData icon, int value, String text) {
    return Container(
      margin: EdgeInsets.all(15),
      width: 155,
      height: 120,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color.fromRGBO(24, 59, 29, 1), width: 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          Text(
            '${value}',
            style: TextStyle(
                fontSize: 26, fontFamily: 'font1', fontWeight: FontWeight.bold),
          ),
          Text(
            '${text}',
            style: TextStyle(fontFamily: 'font1', fontSize: 13),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(238, 242, 225, 1),
          body: IndexedStack(
            children: widgetList,
            index: myIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: myIndex,
            onTap: (index) {
              setState(() {
                myIndex = index;
              });
            },
            backgroundColor: Color.fromRGBO(24, 59, 29, 1),
            selectedItemColor: Colors.tealAccent,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 35,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.inventory_2_outlined,
                    size: 30,
                  ),
                  label: 'Products'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 30,
                  ),
                  label: 'Orders'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline,
                    size: 30,
                  ),
                  label: 'Profile'
              )
            ],
          ),
        ),
      ),
    );
  }
}