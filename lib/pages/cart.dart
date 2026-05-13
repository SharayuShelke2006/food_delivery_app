import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widget/widget_support.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  final String userId =
      FirebaseAuth.instance.currentUser!.uid;

  /// UPDATE QUANTITY
  Future updateQuantity(
    DocumentSnapshot ds,
    int newQuantity,
  ) async {

    int price = int.parse(ds["price"]);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(ds.id)
        .update({
      "quantity": newQuantity,
      "total": price * newQuantity,
    });
  }

  /// DELETE ITEM
  Future deleteItem(String docId) async {

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {

    double width =
        MediaQuery.of(context).size.width;

    bool isDesktop = width > 900;

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        centerTitle: true,

        title: Text(
          "My Cart",
          style:
              AppWidget.boldTextFeildStyle(),
        ),
      ),

      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("cart")
              .orderBy(
                "createdAt",
                descending: true,
              )
              .snapshots(),

          builder:
              (context, AsyncSnapshot snapshot) {

            if (!snapshot.hasData) {
              return Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text(
                  "Cart is Empty",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              );
            }

            double subtotal = 0;

            for (var doc
                in snapshot.data.docs) {

              subtotal +=
                  (doc["total"]).toDouble();
            }

            double deliveryFee = 40;

            double finalTotal =
                subtotal + deliveryFee;

            return Center(
              child: Container(
                width:
                    isDesktop ? 1200 : width,

                padding: EdgeInsets.all(20),

                child: isDesktop

                    /// DESKTOP
                    ? Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          /// LEFT
                          Expanded(
                            flex: 2,

                            child:
                                ListView.builder(
                              shrinkWrap: true,

                              itemCount:
                                  snapshot
                                      .data
                                      .docs
                                      .length,

                              itemBuilder:
                                  (context,
                                      index) {

                                DocumentSnapshot
                                    ds =
                                    snapshot
                                        .data
                                        .docs[index];

                                return cartCard(
                                    ds);
                              },
                            ),
                          ),

                          SizedBox(width: 30),

                          /// RIGHT
                          Expanded(
                            child:
                                paymentSection(
                              subtotal,
                              deliveryFee,
                              finalTotal,
                            ),
                          )
                        ],
                      )

                    /// MOBILE
                    : Column(
                        children: [

                          Expanded(
                            child:
                                ListView.builder(
                              itemCount:
                                  snapshot
                                      .data
                                      .docs
                                      .length,

                              itemBuilder:
                                  (context,
                                      index) {

                                DocumentSnapshot
                                    ds =
                                    snapshot
                                        .data
                                        .docs[index];

                                return cartCard(
                                    ds);
                              },
                            ),
                          ),

                          paymentSection(
                            subtotal,
                            deliveryFee,
                            finalTotal,
                          )
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// CART CARD
  Widget cartCard(DocumentSnapshot ds) {

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius:
                BorderRadius.circular(15),

            child: Image.network(
              ds["image"],

              height: 110,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 15),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  ds["name"],

                  style: AppWidget
                      .semiBoldTextFeildStyle(),
                ),

                SizedBox(height: 8),

                Text(
                  ds["detail"],

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style: AppWidget
                      .LightTextFeildStyle(),
                ),

                SizedBox(height: 10),

                Text(
                  "₹ ${ds["total"]}",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,

                    color:
                        Color(0xFFff5c30),
                  ),
                ),

                SizedBox(height: 15),

                /// QUANTITY
                Row(
                  children: [

                    quantityButton(
                      Icons.remove,
                      () {

                        if (ds["quantity"] >
                            1) {

                          updateQuantity(
                            ds,
                            ds["quantity"] -
                                1,
                          );
                        }
                      },
                    ),

                    SizedBox(width: 15),

                    Text(
                      ds["quantity"]
                          .toString(),

                      style: AppWidget
                          .semiBoldTextFeildStyle(),
                    ),

                    SizedBox(width: 15),

                    quantityButton(
                      Icons.add,
                      () {

                        updateQuantity(
                          ds,
                          ds["quantity"] + 1,
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),

          /// DELETE
          GestureDetector(
            onTap: () {

              deleteItem(ds.id);
            },

            child: Icon(
              Icons.delete_outline,

              color: Colors.red,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  /// PAYMENT SECTION
  Widget paymentSection(
    double subtotal,
    double deliveryFee,
    double finalTotal,
  ) {

    return Container(
      padding: EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            "Payment Summary",

            style:
                AppWidget.boldTextFeildStyle(),
          ),

          SizedBox(height: 25),

          priceRow(
            "Subtotal",
            subtotal,
          ),

          SizedBox(height: 15),

          priceRow(
            "Delivery Fee",
            deliveryFee,
          ),

          Divider(height: 35),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Text(
                "Total",

                style: AppWidget
                    .semiBoldTextFeildStyle(),
              ),

              Text(
                "₹ ${finalTotal.toStringAsFixed(0)}",

                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(0xFFff5c30),
                ),
              )
            ],
          ),

          SizedBox(height: 30),

          /// CHECKOUT BUTTON
          Container(
            width: double.infinity,

            padding: EdgeInsets.symmetric(
              vertical: 18,
            ),

            decoration: BoxDecoration(
              color: Color(0xFFff5c30),

              borderRadius:
                  BorderRadius.circular(
                      18),
            ),

            child: Center(
              child: Text(
                "Proceed To Checkout",

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
    );
  }

  /// PRICE ROW
  Widget priceRow(
    String title,
    double amount,
  ) {

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,

          style:
              AppWidget.LightTextFeildStyle(),
        ),

        Text(
          "₹ ${amount.toStringAsFixed(0)}",

          style: AppWidget
              .semiBoldTextFeildStyle(),
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
          color: Color(0xFFff5c30),

          borderRadius:
              BorderRadius.circular(10),
        ),

        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}