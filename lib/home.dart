import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_ar/login/wrapper.dart';
import 'package:furniture_ar/services/firebaseservices.dart';
import 'add_product.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'cart_view.dart';
import 'categories.dart';
import 'product_detail.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream? LiveStream;
  String? selectedCategory;
  List<String> filterCategories = ['All', ...Catgeories];
  // callQuery() async {
  //   LiveStream = await DBService().GetService();
  // }
  callQuery() async {
    if (selectedCategory == null) {
      LiveStream = DBService().GetService(); // fetch all
    } else {
      LiveStream = FirebaseFirestore.instance
          .collection('PRODUCTS')
          .where('CATEGORY', isEqualTo: selectedCategory)
          .snapshots(); // fetch filtered
    }
    setState(() {}); // update UI
  }

  PersistentShoppingCart cart = PersistentShoppingCart();

  @override
  void initState() {
    callQuery();
    cart.init();
    super.initState();
  }

  Widget RetrivalData() {
    return StreamBuilder(
        stream: LiveStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? GridView.builder(
            padding: EdgeInsets.only(bottom: 230),
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        0.72, // Lower = Taller Cards, Higher = Wider Cards
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                      name: '${ds['NAME']}',
                                      subtitle: '${ds['SUBTITLE']}',
                                      desc: '${ds['DESCRIPTION']}',
                                      price: '${ds['PRICE']}',
                                      model: '${ds['MODEL_URL']}',
                                      image: '${ds['IMAGE_URL']}',
                                      id: '${ds['ID']}',
                                    )));
                      },
                      child: Card(
                        color: Color.fromRGBO(224, 235, 209, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.2,
                          ),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image(
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    '${ds['IMAGE_URL']}',
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '${ds['NAME']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'font1',
                                        color: Color.fromRGBO(24, 59, 29, 1)),
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rs. ${ds['PRICE']}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 59, 29, 1),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17,
                                        fontFamily: 'font1'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Text(
                  'No Products Found',
                  style: TextStyle(fontSize: 15),
                ));
        });
  }

  Widget buildCategoryButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filterCategories
            .map((cat) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      selectedCategory = (cat == "All") ? null : cat;
                      callQuery();
                      print("Selected: $selectedCategory");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        selectedCategory == cat ||
                                (selectedCategory == null && cat == "All")
                            ? Color.fromRGBO(24, 59, 29, 1) // selected color
                            : Color.fromRGBO(238, 242, 225, 1), // default
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        selectedCategory == cat ||
                                (selectedCategory == null && cat == "All")
                            ? Colors.white // selected text color
                            : Color.fromRGBO(24, 59, 29, 1),
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(
                          color: Color.fromRGBO(24, 59, 29, 1),
                          width: selectedCategory == cat ||
                                  (selectedCategory == null && cat == "All")
                              ? 2
                              : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                          fontFamily: 'font1', fontWeight: FontWeight.w800),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(238, 242, 225, 1),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(24, 59, 29, 1),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Wrapper()));
                },
                child: Icon(Icons.person_2_outlined,
                    color: Colors.white, size: 32),
              ),
              cart.showCartItemCountWidget(
                  cartItemCountWidgetBuilder: (itemCount) => IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartView()));
                      },
                      icon: Badge(
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        label: Text(itemCount.toString()),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ))),
            ],
            title: Text(
              'Furnestra',
              style: TextStyle(
                  fontFamily: 'font2',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 40),
            ),
          ),
          // body: Padding(
          //   padding: EdgeInsets.all(10),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       ClipRRect(
          //           borderRadius: BorderRadius.circular(10),
          //           child: Image(image: AssetImage('images/banner1.jpg'))),
          //       buildCategoryButtons(),
          //       Expanded(
          //         child: RetrivalData(),
          //       ),
          //     ],
          //   ),
          // ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('images/banner1.jpg'),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyCategoryBar(
                  child: buildCategoryButtons(),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: RetrivalData(), // your GridView
                  ),
                ),
              ),
            ],
          ),

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     setState(() {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => AddProduct()));
          //     });
          //   },
          //   child: Icon(Icons.add),
          // ),
        ),
      ),
    );
  }
}

class _StickyCategoryBar extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyCategoryBar({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color.fromRGBO(238, 242, 225, 1),
      child: child,
    );
  }

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
