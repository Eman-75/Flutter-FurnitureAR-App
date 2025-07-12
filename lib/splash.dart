import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
            () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(238, 242, 225, 1),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Furnestra',
                  style: TextStyle(
                      fontSize: 67,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'font2'
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Lottie.asset('assets/splash.json',)
              ),
              SizedBox(height: 10,),
              Text('Sleep with coziness',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'font1'
                ),
              ),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 85, vertical: 10), // <-- Margin added
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(24, 59, 29, 1)),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
