import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_ar/admin/admin_main.dart';
import 'package:furniture_ar/login/login.dart';
import 'package:furniture_ar/login/register.dart';
import 'user_profile.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.email == "admin@gmail.com") {
              return AdminPanel();
            } else {
              return UserProfile();
            }
          } else {
            return MyLogin();
          }
        },
      ),
    );
  }
}
