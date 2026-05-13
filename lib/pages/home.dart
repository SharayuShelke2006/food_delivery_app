import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/cart.dart';
import 'package:food_delivery_app/pages/details.dart';
import 'package:food_delivery_app/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// NULL = SHOW ALL ITEMS
  String? selectedCategory;

  /// CATEGORY ICONS
  final List<Map<String, dynamic>> categories = [
    {
      "name": "Ice-cream",
      "image": "images/ice-cream.png",
    },
    {
      "name": "Pizza",
      "image": "images/pizza.png",
    },
    {
      "name": "Salad",
      "image": "images/salad.png",
    },
    {
      "name": "Burger",
      "image": "images/burger.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth =
        MediaQuery.of(context).size.width;

    bool isDesktop = screenWidth > 1000;
    bool isTablet = screenWidth > 700;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Center(
            child: Container(
              width: isDesktop
                  ? 1300
                  : isTablet
                      ? 900
                      : double.infinity,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            "Hello Sharayu,",
                            style: AppWidget
                                .boldTextFeildStyle(),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "Delicious food awaits",
                            style: AppWidget
                                .LightTextFeildStyle(),
                          ),
                        ],
                      ),

                      /// CART BUTTON
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CartPage(),
                            ),
                          );
                        },

                        child: Container(
                          padding:
                              EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color: Colors.black,

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        12),
                          ),

                          child: Icon(
                            Icons
                                .shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 30),

                  /// TITLE
                  Text(
                    "Delicious Food",
                    style: AppWidget
                        .HeadlineTextFeildStyle(),
                  ),

                  SizedBox(height: 5),

                  Text(
                    selectedCategory == null
                        ? "All Food Items"
                        : selectedCategory!,
                    style: AppWidget
                        .LightTextFeildStyle(),
                  ),

                  SizedBox(height: 30),

                  /// CATEGORY BUTTONS
                  categorySection(),

                  SizedBox(height: 35),

                  /// FOOD STREAM
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        selectedCategory == null
                            ? FirebaseFirestore
                                .instance
                                .collection(
                                    "foodItems")
                                .snapshots()

                            : FirebaseFirestore
                                .instance
                                .collection(
                                    "foodItems")
                                .where(
                                  "category",
                                  isEqualTo:
                                      selectedCategory,
                                )
                                .snapshots(),

                    builder:
                        (context, snapshot) {
                      if (snapshot
                              .connectionState ==
                          ConnectionState
                              .waiting) {
                        return Center(
                          child:
                              CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot
                              .data!.docs.isEmpty) {
                        return Center(
                          child: Padding(
                            padding:
                                const EdgeInsets
                                    .all(30),

                            child: Text(
                              "No Food Available",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      }

                      final foods =
                          snapshot.data!.docs;

                      return isDesktop
                          ? GridView.builder(
                              shrinkWrap: true,

                              physics:
                                  NeverScrollableScrollPhysics(),

                              itemCount:
                                  foods.length,

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    3,

                                crossAxisSpacing:
                                    20,

                                mainAxisSpacing:
                                    20,

                                childAspectRatio:
                                    0.72,
                              ),

                              itemBuilder:
                                  (context,
                                      index) {
                                return foodCard(
                                  foods[index],
                                );
                              },
                            )

                          : GridView.builder(
                              shrinkWrap: true,

                              physics:
                                  NeverScrollableScrollPhysics(),

                              itemCount:
                                  foods.length,

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    isTablet
                                        ? 2
                                        : 1,

                                crossAxisSpacing:
                                    20,

                                mainAxisSpacing:
                                    20,

                                childAspectRatio:
                                    isTablet
                                        ? 0.78
                                        : 1.9,
                              ),

                              itemBuilder:
                                  (context,
                                      index) {
                                return isTablet
                                    ? foodCard(
                                        foods[
                                            index],
                                      )

                                    : horizontalFoodCard(
                                        foods[
                                            index],
                                      );
                              },
                            );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// FOOD CARD
  Widget foodCard(DocumentSnapshot food) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) => Details(
              image: food["image"],
              name: food["name"],
              detail: food["detail"],
              price: food["price"],
            ),
          ),
        );
      },

      child: Material(
        elevation: 5,

        borderRadius:
            BorderRadius.circular(20),

        child: Container(
          padding: EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(20),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              /// IMAGE
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                          20),

                  child: Image.network(
                    food["image"],

                    width: double.infinity,

                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 15),

              Text(
                food["name"],

                maxLines: 1,

                overflow:
                    TextOverflow.ellipsis,

                style: AppWidget
                    .semiBoldTextFeildStyle(),
              ),

              SizedBox(height: 5),

              Text(
                food["detail"],

                maxLines: 2,

                overflow:
                    TextOverflow.ellipsis,

                style: AppWidget
                    .LightTextFeildStyle(),
              ),

              SizedBox(height: 10),

              Text(
                "₹ ${food["price"]}",

                style: AppWidget
                    .semiBoldTextFeildStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// MOBILE CARD
  Widget horizontalFoodCard(
      DocumentSnapshot food) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) => Details(
              image: food["image"],
              name: food["name"],
              detail: food["detail"],
              price: food["price"],
            ),
          ),
        );
      },

      child: Material(
        elevation: 5,

        borderRadius:
            BorderRadius.circular(20),

        child: Container(
          padding: EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(20),
          ),

          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                        15),

                child: Image.network(
                  food["image"],

                  height: 120,
                  width: 120,

                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 20),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      food["name"],

                      maxLines: 1,

                      overflow:
                          TextOverflow
                              .ellipsis,

                      style: AppWidget
                          .semiBoldTextFeildStyle(),
                    ),

                    SizedBox(height: 8),

                    Text(
                      food["detail"],

                      maxLines: 2,

                      overflow:
                          TextOverflow
                              .ellipsis,

                      style: AppWidget
                          .LightTextFeildStyle(),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "₹ ${food["price"]}",

                      style: AppWidget
                          .semiBoldTextFeildStyle(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// CATEGORY SECTION
  Widget categorySection() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: categories.map((category) {
        bool isSelected =
            selectedCategory ==
                category["name"];

        return GestureDetector(
          onTap: () {
            setState(() {

              /// CLICK AGAIN -> REMOVE FILTER
              if (selectedCategory ==
                  category["name"]) {

                selectedCategory = null;

              } else {

                selectedCategory =
                    category["name"];
              }
            });
          },

          child: Material(
            elevation: 5,

            borderRadius:
                BorderRadius.circular(12),

            child: Container(
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black
                    : Colors.white,

                borderRadius:
                    BorderRadius.circular(
                        12),
              ),

              child: Image.asset(
                category["image"],

                height: 40,
                width: 40,

                color: isSelected
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}