// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:furniture_ar/login/wrapper.dart';
//
// class Forgot extends StatefulWidget {
//   const Forgot({super.key});
//
//   @override
//   State<Forgot> createState() => _ForgotState();
// }
//
// class _ForgotState extends State<Forgot> {
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//
//   reset()async{
//     await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//             opacity: 0.8,
//             image: AssetImage('images/register.png'), fit: BoxFit.cover),
//       ),
//       child: Scaffold(
//         backgroundColor: Color.fromRGBO(238, 242, 225, 1),
//         // backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         body: Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.only(left: 35, top: 30),
//               child: Text(
//                 'Create\nAccount',
//                 style: TextStyle(color: Colors.white, fontSize: 33),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.28),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(left: 35, right: 35),
//                       child: Column(
//                         children: [
//                           TextField(
//                             style: TextStyle(color: Colors.white),
//                             decoration: InputDecoration(
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 hintText: "Name",
//                                 hintStyle: TextStyle(color: Colors.white),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           TextField(
//                             style: TextStyle(color: Colors.white),
//                             decoration: InputDecoration(
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 hintText: "Email",
//                                 hintStyle: TextStyle(color: Colors.white),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Send Link',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 27,
//                                     fontWeight: FontWeight.w700),
//                               ),
//                               CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: Color.fromRGBO(24, 59, 29, 1),
//                                 child: IconButton(
//                                     color: Colors.white,
//                                     onPressed: (()=>reset()),
//                                     icon: Icon(
//                                       Icons.arrow_forward,
//                                     )),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pushNamed(context, 'login');
//                                 },
//                                 child: Text(
//                                   'Sign In',
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                       decoration: TextDecoration.underline,
//                                       color: Colors.white,
//                                       fontSize: 18),
//                                 ),
//                                 style: ButtonStyle(),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendResetLink() async {
    try {
      if (emailController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter your email');
        return;
      }

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Get.snackbar('Success', 'Password reset link sent to your email');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 242, 225, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your email address and we\'ll send you a password reset link.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: sendResetLink,
              child: const Text('Send Reset Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(24, 59, 29, 1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Back to Login'),
            )
          ],
        ),
      ),
    );
  }
}
