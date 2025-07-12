import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_ar/services/firebaseservices.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListShow();
}

class _OrderListShow extends State<OrderList> {
  Stream? LiveStream;
  callQuery() async {
    var stream = await DBService().GetOrders();
    setState(() {
      LiveStream = stream;
    });
  }

  @override
  void initState() {
    callQuery();
    super.initState();
  }

  TableRow _buildBorderedRow(String label, String value) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontFamily: 'font1',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            value,
            softWrap: true,
            style: const TextStyle(
              fontFamily: 'font1',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _refresh() async {
    await callQuery();
    return Future.delayed(Duration(seconds: 0));
  }

  Widget RetrivalData() {
    return StreamBuilder(
        stream: LiveStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? RefreshIndicator(
                  onRefresh: _refresh,
                  color: Color.fromRGBO(24, 59, 29, 1),
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        List<dynamic> cartItems = ds['CART_ITEMS'];
                        double totalPrice = ds['TOTAL_PRICE'];
                        return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.5),
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(6)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 6,
                                            right: 6,
                                            bottom: 0,
                                            top: 4),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            'Order Id : ',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 6,
                                            right: 6,
                                            bottom: 0,
                                            top: 4),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            '#${ds['ORDER_ID']}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 6,
                                            right: 6,
                                            bottom: 0,
                                            top: 0),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            'Payment Method : ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 6,
                                            right: 6,
                                            bottom: 0,
                                            top: 4),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            '${ds['PAYMENT_METHOD']}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(6),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Customer Info : ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Table(
                                border: TableBorder.all(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                ),
                                columnWidths: const {
                                  0: IntrinsicColumnWidth(), // Label column adjusts to content
                                  1: FlexColumnWidth(), // Value column expands
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  _buildBorderedRow(
                                      'Name', ds['USER_DETAILS']['NAME']),
                                  _buildBorderedRow(
                                      'Address', ds['USER_DETAILS']['ADDRESS']),
                                  _buildBorderedRow(
                                      'Contact', ds['USER_DETAILS']['CONTACT']),
                                  _buildBorderedRow(
                                      'Email', ds['USER_DETAILS']['EMAIL']),
                                  _buildBorderedRow(
                                      'City', ds['USER_DETAILS']['CITY']),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(6),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Order Details : ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              ...cartItems.map((item) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          item['PRODUCT_IMAGE'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '${item['PRODUCT_NAME']} x ${item['QUANTITY']}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        'Rs ${item['UNIT_PRICE'] * item['QUANTITY']}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              Divider(),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Rs ${totalPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Confirmation:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                      onTap:()async{
                                        await DBService().DeleteOrder(ds['ORDER_ID']);
                                      },
                                      child: Icon(Icons.delete_outline_outlined)
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                )
              : Center(
                  child: Text(
                  'No Orders Found',
                  style: TextStyle(fontFamily: 'font1', fontSize: 15),
                ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(238, 242, 225, 1),
        body: Padding(
          padding: EdgeInsets.only(left: 15, top: 10, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'All Orders',
                  style: TextStyle(
                      fontFamily: 'font1',
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(child: RetrivalData()),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
