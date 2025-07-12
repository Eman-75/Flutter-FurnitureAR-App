import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furniture_ar/services/firebaseservices.dart';
import 'add_product.dart';

class ProductShow extends StatefulWidget {
  const ProductShow({super.key});

  @override
  State<ProductShow> createState() => _ProductShow();
}

class _ProductShow extends State<ProductShow> {

  Stream? LiveStream;
  callQuery()async{
    LiveStream = await DBService().GetService();
  }

  @override
  void initState() {
    callQuery();
    super.initState();
  }

  Widget RetrivalData(){
    return StreamBuilder(
        stream: LiveStream,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData? ListView.builder(
            itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
              DocumentSnapshot ds = snapshot.data.docs[index];
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 20,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name : ${ds['NAME']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.black
                              ),
                            ),
                            Text('Age : ${ds['SUBTITLE']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.black
                              ),
                            ),
                            Text('Location : ${ds['DESCRIPTION']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.black
                              ),
                            ),
                            Text('Phone Number : ${ds['PRICE']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.black
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          ): Text('No Products Found');
        }
    );
  }
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),

        body: Padding(
          padding: EdgeInsets.only(left: 15, top: 10, right: 15),
          child: Column(
            children: [
              Expanded(child: RetrivalData())
            ],
          ),
        ),


        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>AddProduct()));
            });
          },
          child: Icon(Icons.add),
        ),

      ),
    );
  }
}
