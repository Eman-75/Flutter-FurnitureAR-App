import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_ar/services/firebaseservices.dart';
import '../add_product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:furniture_ar/categories.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_ar/services/imagekit_service.dart';
import 'dart:io';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductShow();
}

class _ProductShow extends State<ProductList> {
  Stream? LiveStream;
  callQuery() async {
    var stream = await DBService().GetService();
    setState(() {
      LiveStream = stream;
    });
  }

  final GlobalKey<FormState> formstatus = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController SubTitleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController PriceController = TextEditingController();

  File? imageFile;
  File? modelFile;
  bool isUploading = false;
  File? _pickedModel;
  String? value;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> pickModel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        String path = result.files.single.path!;
        setState(() {
          _pickedModel = File(path);
        });
        print("Picked model file: $path");
      } else {
        print("User canceled or no file selected");
      }
    } catch (e) {
      print("Error picking model file: $e");
    }
  }

  Future<void> uploadBoth() async {
    if (imageFile == null || _pickedModel == null) {
      Fluttertoast.showToast(msg: 'Please select both image and model file');
      return;
    }

    setState(() => isUploading = true);

    final imageUrl = await ImageKitService.uploadFile(imageFile!);
    final modelUrl = await ImageKitService.uploadFile(_pickedModel!);

    print("✅ imageUrl: $imageUrl");
    print("✅ modelUrl: $modelUrl");

    if (imageUrl != null && modelUrl != null) {
      await ImageKitService.saveProductToFirestore(imageUrl, modelUrl);
      Fluttertoast.showToast(msg: 'Image & Model uploaded and saved!');
    } else {
      Fluttertoast.showToast(msg: 'Upload failed: image or model URL is null');
    }

    setState(() => isUploading = false);
  }



  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(
          fontSize: 20,
        ),
      ));

  Future EditData(String id, String oldImageUrl, String oldModelUrl)=>showDialog(  // kaam specific interval mein hoga
      context: context,
      builder: (context)=>AlertDialog(
          scrollable: true,
        contentPadding: EdgeInsets.zero,
        content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, color: Colors.red,),
                  ),
                  Form(
                    key: formstatus,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Text(
                              'Product Form',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 30,
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
                                  hintText: 'Enter Name of the Product',
                                  border: OutlineInputBorder(),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                controller: SubTitleController,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return "*Please Enter Subtitle";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter SubTitle of the Product',
                                  border: OutlineInputBorder(),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                maxLines: 8,
                                controller: DescriptionController,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return "*Please Enter Description";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Description',
                                  border: OutlineInputBorder(),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                controller: PriceController,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return "*Please Enter Price";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Price',
                                  border: OutlineInputBorder(),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey, // same as OutlineInputBorder borderSide.color
                                    width: 1.5, // same as OutlineInputBorder borderSide.width
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: value,
                                    iconSize: 35,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    isExpanded: true,
                                    items: Catgeories.map(buildMenuItem).toList(),
                                    onChanged: (value) => setState(() => this.value = value),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Product Image",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  imageFile != null
                                      ? Image.file(imageFile!,
                                      width: 100, height: 100, fit: BoxFit.cover)
                                      : Image.network(oldImageUrl,
                                      width: 100, height: 100, fit: BoxFit.cover),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: pickImage,
                                    child: Text("Pick Product Image"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Product Image",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  _pickedModel != null
                                      ? Text(_pickedModel!.path.split('/').last)
                                      : Text("Current model: ${oldModelUrl.split('/').last}"),
                                  // if (_pickedModel != null)
                                  //   Text("Model file: ${_pickedModel!.path.split('/').last}"),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                      onPressed: pickModel, child: Text("Pick Model File")),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 10, backgroundColor: Color.fromRGBO(24, 59, 29, 1)),
                                  onPressed: () async {
                                    if (!formstatus.currentState!.validate()) {
                                      Fluttertoast.showToast(msg: 'Fill Complete Form');
                                      return;
                                    }

                                    setState(() => isUploading = true);

                                    String imageUrl = oldImageUrl;
                                    String modelUrl = oldModelUrl;

                                    // Upload only if new image selected
                                    if (imageFile != null) {
                                      imageUrl = await ImageKitService.uploadFile(imageFile!) ?? oldImageUrl;
                                      if (imageUrl != oldImageUrl) {
                                        await ImageKitService.deleteFileFromURL(oldImageUrl);
                                      }
                                    }

                                    // Upload only if new model selected
                                    if (_pickedModel != null) {
                                      modelUrl = await ImageKitService.uploadFile(_pickedModel!) ?? oldModelUrl;
                                      if (modelUrl != oldModelUrl) {
                                        await ImageKitService.deleteFileFromURL(oldModelUrl);
                                      }
                                    }

                                    Map<String, dynamic> UserRecord = {
                                      "NAME": NameController.text,
                                      "SUBTITLE": SubTitleController.text,
                                      "DESCRIPTION": DescriptionController.text,
                                      "PRICE": PriceController.text,
                                      "CATEGORY": value,
                                      "ID": id,
                                      "IMAGE_URL": imageUrl,
                                      "MODEL_URL": modelUrl,
                                    };

                                    await DBService().EditProduct(UserRecord, id);
                                    Fluttertoast.showToast(msg: 'Product Updated');
                                    Navigator.pop(context);
                                    setState(() => isUploading = false);
                                  },
                                  child: Text(
                                    'Update Product',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  )),
                            )
                          ],
                        ),
                    ),
                  )
                ],
              ),
            ),
      ));

  @override
  void initState() {
    callQuery();
    super.initState();
  }

  Widget RetrivalData() {
    return StreamBuilder(
        stream: LiveStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    // print(ds.data());
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                      ),
                      child: Material(
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color:
                                Color.fromRGBO(24, 59, 29, 0.5), // Border color
                            width: 2, // Border width
                          ),
                        ),
                        // elevation: 2,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image: NetworkImage('${ds['IMAGE_URL']}'),
                                      height: 60,
                                      width: 70,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${ds['NAME']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'font1',
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          '${ds['SUBTITLE']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'font1',
                                              fontSize: 12,
                                              color: Colors.grey[700]),
                                        ),
                                        Text(
                                          'Rs. ${ds['PRICE']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'font1',
                                              fontSize: 20,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await DBService()
                                            .DeleteProduct(ds['ID']);
                                      },
                                      child:
                                          Icon(Icons.delete_outline, size: 20),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        EditData(
                                          ds['ID'],
                                          ds['IMAGE_URL'],
                                          ds['MODEL_URL'],
                                        );
                                        NameController.text = ds['NAME'];
                                        SubTitleController.text = ds['SUBTITLE'];
                                        DescriptionController.text = ds['DESCRIPTION'];
                                        PriceController.text = ds['PRICE'];
                                        value = ds['CATEGORY'];
                                      },
                                      child: Icon(Icons.edit, size: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Text(
                  'No Products Found',
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
                  'All Products',
                  style: TextStyle(
                      fontFamily: 'font1',
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(child: RetrivalData()),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // mini: true,
          shape: const CircleBorder(),
          backgroundColor: Color.fromRGBO(24, 59, 29, 1),
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProduct()));
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }
}
