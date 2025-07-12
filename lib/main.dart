import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'firebase_options.dart';
import 'admin/admin_main.dart';
import 'login/wrapper.dart';
import 'splash.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PersistentShoppingCart cart = PersistentShoppingCart();
  await cart.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// class FurniturePreview extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('3D Furniture Viewer')),
//       body: Center(
//         child: ModelViewer(
//           src: 'assets/models/sofa.glb',
//           alt: 'A 3D chair model',
//           ar: true,
//           autoRotate: true,
//           cameraControls: true,
//           disableZoom: false,
//           backgroundColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }
