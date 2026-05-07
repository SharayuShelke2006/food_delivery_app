import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/signup.dart';
import 'package:food_delivery_app/widget/content_model.dart';
import 'package:food_delivery_app/widget/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isWeb = screenWidth > 800;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// PageView
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return SingleChildScrollView(
                    child: Center(
                      child: Container(
                        width: isWeb ? 600 : screenWidth,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            /// Image
                            Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    isWeb ? 450 : screenHeight * 0.45,
                              ),
                              child: Image.asset(
                                contents[i].image,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// Title
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style:
                                  AppWidget.HeadlineTextFeildStyle(),
                            ),

                            const SizedBox(height: 20),

                            /// Description
                            Text(
                              contents[i].description,
                              textAlign: TextAlign.center,
                              style:
                                  AppWidget.LightTextFeildStyle(),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index),
              ),
            ),

            const SizedBox(height: 20),

            /// Next Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? screenWidth * 0.3 : 20,
                vertical: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  if (currentIndex == contents.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  } else {
                    _controller.nextPage(
                      duration:
                          const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      currentIndex == contents.length - 1
                          ? "Start"
                          : "Next",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: currentIndex == index ? 20 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: currentIndex == index
            ? Colors.red
            : Colors.black38,
      ),
    );
  }
}