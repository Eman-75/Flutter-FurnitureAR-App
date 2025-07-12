import 'package:flutter/material.dart';
import 'package:furniture_ar/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  signout()async{
    await FirebaseAuth.instance.signOut();
  }

  Widget PersonInfo (IconData icon, String text){
    return Container(
      padding: EdgeInsets.all(10),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Row(
        children: [
          Icon(icon,
            size: 30,
          ),
          SizedBox(width: 23,),
          Text(text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),)
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 242, 225, 1),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                child: Icon(
                    Icons.person,
                  color: Colors.white,
                  size: 70,
                ),
                backgroundColor: Color.fromRGBO(24, 59, 29, 1),
              ),
              SizedBox(height: 20,),
              Text('Admin Info',
                style: TextStyle(
                  fontFamily: 'font1',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),),
              SizedBox(height: 15,),
              PersonInfo(Icons.person_2_outlined,'Eman Shahid'),
              SizedBox(height: 15,),
              PersonInfo(Icons.confirmation_num_outlined,'22-ARID-5138'),
              SizedBox(height: 15,),
              PersonInfo(Icons.propane_outlined,'Furniture AR Project'),
              SizedBox(height: 15,),
              PersonInfo(Icons.class_outlined,'BSSE-6'),
              SizedBox(height: 38,),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)), // Makes it rectangular
                        ),
                        backgroundColor: Color.fromRGBO(24, 59, 29, 1)),
                    onPressed: (()=>signout()),
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}