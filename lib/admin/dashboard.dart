import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'graph_widget.dart';
import 'package:furniture_ar/categories.dart';
import 'package:furniture_ar/services/dashboard_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalCategories = 0;
  int totalProducts = 0;
  int totalOrders = 0;
  double totalSales = 0.0;

  final DashboardService dashboardService = DashboardService();

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    totalCategories = Catgeories.length;
    totalProducts = await dashboardService.getTotalProducts();
    totalOrders = await dashboardService.getTotalOrders();
    totalSales = await dashboardService.getTotalSales();
    print('Categories count: ${Catgeories.length}');
    setState(() {});
  }

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
    return  SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(238, 242, 225, 1),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                          fontFamily: 'font1',
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                      'Hello Admin,',
                      style: TextStyle(
                          fontFamily: 'font1',
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Insights_Card(
                          Icons.inventory_2_outlined, totalProducts, 'Total Products'),
                      Insights_Card(
                          Icons.receipt_long_outlined, totalSales.round(), 'Total Sales'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Insights_Card(Icons.category_outlined, totalCategories, 'Categories'),
                      Insights_Card(
                          Icons.shopping_cart_outlined, totalOrders, 'Total Orders'),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                      'Revenue',
                      style: TextStyle(
                          fontFamily: 'font1',
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  LineGraph(),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
