import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widget/widget_support.dart';
import 'package:image_picker/image_picker.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final List<String> foodItems = [
    'Ice-cream',
    'Burger',
    'Salad',
    'Pizza'
  ];

  String? selectedCategory;

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  final TextEditingController detailController =
      TextEditingController();

  final ImagePicker picker = ImagePicker();

  Uint8List? imageBytes;

  XFile? pickedImage;

  bool isLoading = false;

  /// CLOUDINARY
  final cloudinary = CloudinaryPublic(
    'dbl6yxhl6',
    'fooddeliveryapp',
    cache: false,
  );

  /// PICK IMAGE
  Future pickImage() async {
    final image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      pickedImage = image;

      imageBytes = await image.readAsBytes();

      setState(() {});
    }
  }

  /// UPLOAD FOOD
  Future uploadFood() async {
    if (pickedImage == null ||
        nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        detailController.text.isEmpty ||
        selectedCategory == null) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      /// Upload Image To Cloudinary
      CloudinaryResponse response =
          await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          pickedImage!.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      String imageUrl = response.secureUrl;

      /// Save To Firestore
      await FirebaseFirestore.instance
          .collection("foodItems")
          .add({
        "image": imageUrl,
        "name": nameController.text.trim(),
        "price": priceController.text.trim(),
        "detail": detailController.text.trim(),
        "category": selectedCategory,
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Food Added Successfully"),
        ),
      );

      /// CLEAR
      nameController.clear();
      priceController.clear();
      detailController.clear();

      setState(() {
        imageBytes = null;
        pickedImage = null;
        selectedCategory = null;
      });

    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload Failed"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    bool isDesktop = width > 900;
    bool isTablet = width > 600 && width <= 900;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Food",
          style: AppWidget.HeadlineTextFeildStyle(),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: isDesktop
                ? 650
                : isTablet
                    ? 550
                    : double.infinity,

            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// IMAGE
                    Text(
                      "Food Image",
                      style:
                          AppWidget.semiBoldTextFeildStyle(),
                    ),

                    SizedBox(height: 20),

                    Center(
                      child: GestureDetector(
                        onTap: pickImage,

                        child: Container(
                          width: 170,
                          height: 170,

                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),

                          child: imageBytes == null
                              ? Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(20),

                                  child: Image.memory(
                                    imageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    buildTextField(
                      title: "Food Name",
                      hint: "Enter food name",
                      controller: nameController,
                    ),

                    SizedBox(height: 20),

                    buildTextField(
                      title: "Price",
                      hint: "Enter price",
                      controller: priceController,
                    ),

                    SizedBox(height: 20),

                    buildTextField(
                      title: "Details",
                      hint: "Enter details",
                      controller: detailController,
                      maxLines: 5,
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Category",
                      style:
                          AppWidget.semiBoldTextFeildStyle(),
                    ),

                    SizedBox(height: 10),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15),

                      decoration: BoxDecoration(
                        color: Color(0xFFF4F4F4),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),

                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,

                          hint: Text("Select Category"),

                          items: foodItems.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : uploadFood,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),

                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "ADD FOOD",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String title,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: AppWidget.semiBoldTextFeildStyle(),
        ),

        SizedBox(height: 10),

        TextField(
          controller: controller,
          maxLines: maxLines,

          decoration: InputDecoration(
            hintText: hint,

            filled: true,
            fillColor: Color(0xFFF4F4F4),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}