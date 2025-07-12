import 'dart:math';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:furniture_ar/services/firebaseservices.dart';
import 'services/firebaseservices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'services/imagekit_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'categories.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> formstatus = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController SubTitleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController PriceController = TextEditingController();

  File? imageFile;
  File? modelFile;
  bool isUploading = false;
  File? _pickedModel;
  // List<String> Catgeories = ['Beds', 'Chairs', 'Sofas'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formstatus,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
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
                          : Text("No image selected"),
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
                      if (_pickedModel != null)
                        Text("Model file: ${_pickedModel!.path.split('/').last}"),
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
                        if (imageFile == null || _pickedModel == null) {
                          Fluttertoast.showToast(
                              msg: 'Please select both image and model file');
                          return;
                        }

                        setState(() => isUploading = true);

                        final imageUrl =
                            await ImageKitService.uploadFile(imageFile!);
                        final modelUrl =
                            await ImageKitService.uploadFile(_pickedModel!);

                        if (imageUrl != null && modelUrl != null && formstatus.currentState!.validate()) {
                          String PID = randomAlphaNumeric(5);
                          Map<String, dynamic> UserRecord = {
                            "NAME": NameController.text,
                            "SUBTITLE": SubTitleController.text,
                            "DESCRIPTION": DescriptionController.text,
                            "PRICE": PriceController.text,
                            "CATEGORY": value,
                            "ID": PID,
                            "IMAGE_URL": imageUrl,
                            "MODEL_URL": modelUrl,
                          };

                          await DBService().InsertService(UserRecord, PID);
                          Fluttertoast.showToast(msg: 'Product Added');
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(msg: 'Fill Complete Form');
                        }
                        setState(() => isUploading = false);
                      },
                      child: Text(
                        'ADD PRODUCT',
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
