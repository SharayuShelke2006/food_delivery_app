import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/details.dart';
import 'package:food_delivery_app/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false,
      pizza = false,
      salad = false,
      burger = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isWeb = screenWidth > 800;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Center(
            child: Container(
              width: isWeb ? 1200 : screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hello Sharayu,",
                        style:
                            AppWidget.boldTextFeildStyle(),
                      ),

                      /// Cart
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Title
                  Text(
                    "Delicious Food",
                    style:
                        AppWidget.HeadlineTextFeildStyle(),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Discover and Get Great Food",
                    style:
                        AppWidget.LightTextFeildStyle(),
                  ),

                  const SizedBox(height: 25),

                  /// Categories
                  showItem(),

                  const SizedBox(height: 30),

                  /// Top Food Cards
                  SizedBox(
                    height: 290,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        foodCard(
                          image: "images/salad2.png",
                          title: "Veggie Taco Hash",
                          subtitle: "Fresh and Healthy",
                          price: "\$25",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Details(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 15),

                        foodCard(
                          image: "images/salad4.png",
                          title: "Mix Veg Salad",
                          subtitle: "Spicy with Onion",
                          price: "\$28",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Vertical Food List
                  isWeb
                      ? GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 3.5,
                          children: [
                            verticalFoodCard(
                              "images/salad4.png",
                              "Mediterranean Chickpea Salad",
                              "Honey goat cheese",
                              "\$28",
                            ),
                            verticalFoodCard(
                              "images/salad2.png",
                              "Veggie Taco Hash",
                              "Honey goat cheese",
                              "\$28",
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            verticalFoodCard(
                              "images/salad4.png",
                              "Mediterranean Chickpea Salad",
                              "Honey goat cheese",
                              "\$28",
                            ),

                            const SizedBox(height: 20),

                            verticalFoodCard(
                              "images/salad2.png",
                              "Veggie Taco Hash",
                              "Honey goat cheese",
                              "\$28",
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Horizontal Food Card
  Widget foodCard({
    required String image,
    required String title,
    required String subtitle,
    required String price,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  image,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                title,
                style:
                    AppWidget.semiBoldTextFeildStyle(),
              ),

              const SizedBox(height: 5),

              Text(
                subtitle,
                style: AppWidget.LightTextFeildStyle(),
              ),

              const SizedBox(height: 5),

              Text(
                price,
                style:
                    AppWidget.semiBoldTextFeildStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Vertical Food Card
  Widget verticalFoodCard(
    String image,
    String title,
    String subtitle,
    String price,
  ) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 20),

            /// Text
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppWidget
                        .semiBoldTextFeildStyle(),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style:
                        AppWidget.LightTextFeildStyle(),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    price,
                    style: AppWidget
                        .semiBoldTextFeildStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Category Icons
  Widget showItem() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        categoryItem(
          "images/ice-cream.png",
          icecream,
          () {
            setState(() {
              icecream = true;
              pizza = false;
              salad = false;
              burger = false;
            });
          },
        ),

        categoryItem(
          "images/pizza.png",
          pizza,
          () {
            setState(() {
              icecream = false;
              pizza = true;
              salad = false;
              burger = false;
            });
          },
        ),

        categoryItem(
          "images/salad.png",
          salad,
          () {
            setState(() {
              icecream = false;
              pizza = false;
              salad = true;
              burger = false;
            });
          },
        ),

        categoryItem(
          "images/burger.png",
          burger,
          () {
            setState(() {
              icecream = false;
              pizza = false;
              salad = false;
              burger = true;
            });
          },
        ),
      ],
    );
  }

  /// Category Widget
  Widget categoryItem(
    String image,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                selected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            image,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
            color:
                selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}