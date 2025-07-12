import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'cart_view.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';

class ProductDetail extends StatefulWidget {
  final String? name;
  final String? subtitle;
  final String? desc;
  final dynamic price;
  final dynamic model;
  final dynamic image;
  final dynamic id;
  const ProductDetail({super.key, this.name, this.subtitle, this.desc, this.price, this.model, this.image, this.id});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PersistentShoppingCart cart = PersistentShoppingCart();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 242, 225, 1),
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('Product Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: ModelViewer(
                src: widget.model ?? 'assets/models/sofa.glb',
                alt: 'A 3D chair model',
                ar: true,
                autoRotate: true,
                cameraControls: true,
                disableZoom: false,
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(left: 20, right: 35, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name ?? 'Product Name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'font1', color: Color.fromRGBO(24, 59, 29, 1))),
                      SizedBox(height: 4),
                      Text(widget.subtitle ?? 'Subtitle',
                          style: TextStyle(color: Colors.grey[600], fontFamily: 'font1')),
                    ],
                  ),
                  Text('Rs. ' + widget.price,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'font1',
                          color: Color.fromRGBO(24, 59, 29, 1))),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 30),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.desc ?? 'Description',
                  style: TextStyle(fontSize: 18, fontFamily: 'font1'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Reviews & Comments',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(24, 59, 29, 1),
                      fontFamily: 'font1'
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 1,
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/girl1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  'Haleema',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'I love the sofa! It’s very comfortable and stylish. I am very happy',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/girl2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  'Elaiza',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Furnestra is my favrouite shop. i love buying furniture from here',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity, // full width button
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PersistentShoppingCart()
                  .showAndUpdateCartItemWidget(
                  inCartWidget: Container(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      child: Text(
                        'Remove',
                        style: TextStyle(color: Colors.white,),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Color.fromRGBO(24, 59, 29, 1); // Custom color when disabled
                          }
                          return Color.fromRGBO(24, 59, 29, 1);
                        }),
                      ),
                      onPressed: null,
                    ),
                  ),
                  notInCartWidget: Container(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white,),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Color.fromRGBO(24, 59, 29, 1); // Custom color when disabled
                          }
                          return Color.fromRGBO(24, 59, 29, 1);
                        }),
                      ),
                      onPressed: null,
                    ),
                  ),
                  product: PersistentShoppingCartItem(
                      productId: widget.id,
                      productName: widget.name.toString(),
                      productDescription:
                      widget.subtitle,
                      unitPrice: double.parse(
                          widget.price),
                      quantity: 1,
                      productThumbnail:
                      widget.image)
              ),
              cart.showCartItemCountWidget(
                  cartItemCountWidgetBuilder: (itemCount) => IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((s) =>
                        s.contains(MaterialState.pressed)
                            ? Colors.black
                            : Color.fromRGBO(24, 59, 29, 1)),
                      ),
                      iconSize: 25,
                      constraints: BoxConstraints(
                        minHeight: 40,
                        minWidth: 40,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartView()));
                      },
                      icon: Badge(
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        label: Text(itemCount.toString(),),
                        child: Icon(Icons.shopping_bag_outlined, color: Colors.white,),
                      )
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}
