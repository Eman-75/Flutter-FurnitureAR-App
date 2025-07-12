import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_ar/thankyou.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:random_string/random_string.dart';
import 'package:furniture_ar/services/firebaseservices.dart';
import 'services/firebaseservices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'services/imagekit_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'categories.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> cartData;
  const CheckoutPage({super.key, required this.cartData});


  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormState> formstatus = GlobalKey<FormState>();
  PersistentShoppingCart cart = PersistentShoppingCart();
  TextEditingController NameController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController ContactController = TextEditingController();
  TextEditingController EmailController = TextEditingController();

  List<String> paymentOptions = ['Cash On Delivery', 'Bank Transfer'];
  String? currentOption;

  void initState() {
    super.initState();
    currentOption = paymentOptions[0];
  }
  Widget OrderSummary() {
    List<dynamic> cartItems = widget.cartData['cartItems'];
    double totalPrice = widget.cartData['totalPrice'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...cartItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    item.productThumbnail.toString(),
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Text(
                    '${item.productName} x ${item.quantity}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  'Rs ${item.unitPrice * item.quantity}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }).toList(),
        Divider(),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rs ${totalPrice.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 242, 225, 1),
      appBar: AppBar(
        title: Text(
            'Checkout',
          style: TextStyle(
            fontFamily: 'font1'
          ),
        ),
      ),
      body: Form(
        key: formstatus,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15,),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                TextFormField(
                    controller: EmailController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "*Please Enter Email";
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email',
                      filled: true,
                      fillColor: Colors.white60,
                      border: OutlineInputBorder(),
                    )),
                SizedBox(height: 13,),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Delivery',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                TextFormField(
                    controller: NameController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "*Please Enter Name";
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                      filled: true,
                      fillColor: Colors.white60,
                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: CityController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "*Please Enter City";
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your City',
                      filled: true,
                      fillColor: Colors.white60,
                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    maxLines: 6,
                    controller: AddressController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "*Please Enter Complete Address";
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Complete Address',
                      filled: true,
                      fillColor: Colors.white60,
                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: ContactController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "*Please Enter Contact";
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Contact Number',
                      filled: true,
                      fillColor: Colors.white60,
                      border: OutlineInputBorder(),
                    )),
                SizedBox(height: 16,),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 13,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.5
                        ),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Radio(
                            value: paymentOptions[0],
                            groupValue: currentOption,
                            onChanged: (value){
                              setState(() {
                                currentOption = value.toString();
                              });
                            },
                            activeColor: Color.fromRGBO(24, 59, 29, 1),
                          ),
                          Text(paymentOptions[0]),
                        ],
                      ),
                    ),
                    SizedBox(height: 4,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1.5
                          ),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Radio(
                            value: paymentOptions[1],
                            groupValue: currentOption,
                            onChanged: (value){
                              setState(() {
                                currentOption = value.toString();
                              });
                            },
                            activeColor: Color.fromRGBO(24, 59, 29, 1),
                          ),
                          Text(paymentOptions[1]),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16,),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 13,),
                OrderSummary(),

                SizedBox(
                  height: 18,
                ),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)), // Makes it rectangular
                          ),
                          backgroundColor: Color.fromRGBO(24, 59, 29, 1)),
                      onPressed: () async {
                        if (formstatus.currentState!.validate()) {
                          String PID = randomAlphaNumeric(5);
                          Map<String, dynamic> UserRecord = {
                            "NAME": NameController.text,
                            "CITY": CityController.text,
                            "ADDRESS": AddressController.text,
                            "CONTACT": ContactController.text,
                            "EMAIL" : EmailController.text,
                          };

                          List<dynamic> cartItems = widget.cartData['cartItems'];
                          double totalPrice = widget.cartData['totalPrice'];

                          await DBService().InsertOrder(
                            userDetails: UserRecord,
                            orderId: PID,
                            cartItems: cartItems,
                            totalPrice: totalPrice,
                            paymentMethod: currentOption.toString(),
                          );
                          PersistentShoppingCart().clearCart();
                          Fluttertoast.showToast(msg: 'Order Completed');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=>
                                      ThankYou()
                              )
                          );
                        } else {
                          Fluttertoast.showToast(msg: 'Fill the Form Completely');
                        };
                      },
                      child: Text(
                        'Complete Order',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
