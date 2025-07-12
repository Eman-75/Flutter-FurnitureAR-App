import 'package:flutter/material.dart';
import 'package:furniture_ar/home.dart';
import 'package:lottie/lottie.dart';

class ThankYou extends StatefulWidget {
  const ThankYou({super.key});

  @override
  State<ThankYou> createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 242, 225, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/orderSuccess.json', width: 150),
            SizedBox(height: 20,),
            Center(
              child: Text(
                  '    Thank You\n For Your Order',
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 25,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            SizedBox(height: 45,),
            SizedBox(
              width: 280,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)), // Makes it rectangular
                      ),
                      backgroundColor: Color.fromRGBO(24, 59, 29, 1)),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    'Continue Shopping',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            )

          ],
        ),
      ),
    );
  }
}