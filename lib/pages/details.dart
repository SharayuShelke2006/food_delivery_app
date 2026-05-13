import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widget/widget_support.dart';

class Details extends StatefulWidget {
  final String image;
  final String name;
  final String detail;
  final String price;

  const Details({
    super.key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;

  /// ADD TO CART
  Future addToCart() async {
    try {
      String userId =
          FirebaseAuth.instance.currentUser!.uid;

      int price = int.parse(widget.price);

      int total = price * quantity;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("cart")
          .add({
        "image": widget.image,
        "name": widget.name,
        "detail": widget.detail,
        "price": widget.price,
        "quantity": quantity,
        "total": total,
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added to cart"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    bool isDesktop = width > 900;
    bool isTablet = width > 600 && width <= 900;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: isDesktop
                  ? 1200
                  : isTablet
                      ? 800
                      : double.infinity,
              padding: EdgeInsets.all(20),
              child: isDesktop
                  ? desktopLayout()
                  : mobileLayout(),
            ),
          ),
        ),
      ),
    );
  }

  /// MOBILE + TABLET
  Widget mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// BACK BUTTON
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 20),

        /// IMAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            widget.image,
            width: double.infinity,
            height: 350,
            fit: BoxFit.cover,
          ),
        ),

        SizedBox(height: 20),

        /// TITLE + QUANTITY
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style:
                        AppWidget.boldTextFeildStyle(),
                  ),

                  SizedBox(height: 10),

                  Text(
                    widget.detail,
                    maxLines: 4,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        AppWidget.LightTextFeildStyle(),
                  ),
                ],
              ),
            ),

            SizedBox(width: 15),

            Row(
              children: [
                quantityButton(
                  Icons.remove,
                  () {
                    if (quantity > 1) {
                      quantity--;
                      setState(() {});
                    }
                  },
                ),

                SizedBox(width: 12),

                Text(
                  quantity.toString(),
                  style: AppWidget
                      .semiBoldTextFeildStyle(),
                ),

                SizedBox(width: 12),

                quantityButton(
                  Icons.add,
                  () {
                    quantity++;
                    setState(() {});
                  },
                ),
              ],
            )
          ],
        ),

        SizedBox(height: 25),

        /// DELIVERY
        Row(
          children: [
            Text(
              "Delivery Time",
              style:
                  AppWidget.semiBoldTextFeildStyle(),
            ),

            SizedBox(width: 20),

            Icon(
              Icons.alarm,
              color: Colors.black54,
            ),

            SizedBox(width: 5),

            Text(
              "30 min",
              style:
                  AppWidget.semiBoldTextFeildStyle(),
            )
          ],
        ),

        SizedBox(height: 40),

        /// PRICE + BUTTON
        Row(
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Price",
                  style: AppWidget
                      .semiBoldTextFeildStyle(),
                ),

                SizedBox(height: 5),

                Text(
                  "₹ ${int.parse(widget.price) * quantity}",
                  style: AppWidget
                      .HeadlineTextFeildStyle(),
                )
              ],
            ),

            SizedBox(width: 20),

            Expanded(
              child: GestureDetector(
                onTap: addToCart,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add to cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      SizedBox(width: 15),

                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  /// DESKTOP
  Widget desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT IMAGE
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 20),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(25),
                child: Image.network(
                  widget.image,
                  height: 650,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 50),

        /// RIGHT CONTENT
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style:
                    AppWidget.HeadlineTextFeildStyle(),
              ),

              SizedBox(height: 25),

              Text(
                widget.detail,
                style:
                    AppWidget.LightTextFeildStyle(),
              ),

              SizedBox(height: 40),

              Row(
                children: [
                  quantityButton(
                    Icons.remove,
                    () {
                      if (quantity > 1) {
                        quantity--;
                        setState(() {});
                      }
                    },
                  ),

                  SizedBox(width: 20),

                  Text(
                    quantity.toString(),
                    style: AppWidget
                        .semiBoldTextFeildStyle(),
                  ),

                  SizedBox(width: 20),

                  quantityButton(
                    Icons.add,
                    () {
                      quantity++;
                      setState(() {});
                    },
                  )
                ],
              ),

              SizedBox(height: 40),

              Row(
                children: [
                  Text(
                    "Delivery Time",
                    style: AppWidget
                        .semiBoldTextFeildStyle(),
                  ),

                  SizedBox(width: 20),

                  Icon(Icons.alarm),

                  SizedBox(width: 5),

                  Text(
                    "30 min",
                    style: AppWidget
                        .semiBoldTextFeildStyle(),
                  )
                ],
              ),

              SizedBox(height: 50),

              Text(
                "₹ ${int.parse(widget.price) * quantity}",
                style:
                    AppWidget.HeadlineTextFeildStyle(),
              ),

              SizedBox(height: 40),

              GestureDetector(
                onTap: addToCart,
                child: Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add to cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      SizedBox(width: 20),

                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  /// QUANTITY BUTTON
  Widget quantityButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}