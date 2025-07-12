import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_ar/checkout.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 242, 225, 1),
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: PersistentShoppingCart().showCartItems(
                    cartTileWidget: ({required data}) => Card(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(224, 235, 209, 1),
                              border: Border.all(width: 1, color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                    image: NetworkImage(
                                        data.productThumbnail.toString()),
                                    fit: BoxFit.fill,
                                    width: 92,
                                    height: 92,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.productName,
                                            style: TextStyle(
                                                height: 1,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              fontFamily: 'font1',
                                              color: Color.fromRGBO(24, 59, 29, 1)
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                PersistentShoppingCart()
                                                    .removeFromCart(
                                                        data.productId);
                                              },
                                              icon: Icon(
                                                Icons.delete_outline_outlined,
                                                color: Colors.grey[600],
                                                size: 20,
                                              ))
                                        ]),
                                    Text(
                                      data.productDescription.toString(),
                                      style: TextStyle(fontSize: 12, height: 0,fontFamily: 'font1'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rs : " +
                                              data.unitPrice.round().toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            fontFamily: 'font1',
                                            color: Color.fromRGBO(24, 59, 29, 1)
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.grey[300],
                                              radius: 12,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: BoxConstraints(),
                                                onPressed: () {
                                                  PersistentShoppingCart()
                                                      .incrementCartItemQuantity(
                                                          data.productId);
                                                },
                                                color: Colors.grey[600],
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(data.quantity.toString()),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            CircleAvatar(
                                              backgroundColor: Colors.grey[300],
                                              radius: 12,
                                              child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                  onPressed: () {
                                                    PersistentShoppingCart()
                                                        .decrementCartItemQuantity(
                                                            data.productId);
                                                  },
                                                  color: Colors.grey[600],
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  )),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                    showEmptyCartMsgWidget:
                        Center(child: Text('Cart is Empty'))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PersistentShoppingCart().showTotalAmountWidget(
                    cartTotalAmountWidgetBuilder: (totalAmount) {
                  return Column(
                    children: [
                      Visibility(
                        visible: totalAmount == 0.0 ? false : true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount : ",
                              style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500, fontFamily: 'font1'),
                            ),
                            Text(totalAmount.round().toString() +
                                  " Rs",
                              style: TextStyle(fontSize: 19),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(bottom: 12,top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Color.fromRGBO(24, 59, 29, 1)
                              ),
                              onPressed: () {
                                final shoppingCart = PersistentShoppingCart();
                                Map<String, dynamic> cartData =
                                    shoppingCart.getCartData();
                                List<PersistentShoppingCartItem> cartItems =
                                    cartData['cartItems'];
                                double totalPrice = cartData['totalPrice'];
                                /* cart items is a list we can runa loop to extract all the values and send to firebase */
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CheckoutPage(cartData: cartData))
                                );
                              },
                              child: Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontFamily: 'font1'
                                ),
                              )),
                        ),
                      )
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
