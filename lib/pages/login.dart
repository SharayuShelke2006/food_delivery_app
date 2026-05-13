import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/bottomnav.dart';
import 'package:food_delivery_app/pages/forgotpassword.dart';
import 'package:food_delivery_app/pages/signup.dart';
import 'package:food_delivery_app/widget/widget_support.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller =
      TextEditingController();

  TextEditingController userpasswordcontroller =
      TextEditingController();

  /// LOGIN FUNCTION
  Future userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNav(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "";

      if (e.code == 'user-not-found') {
        message = "No User Found for that Email";
      } else if (e.code == 'wrong-password') {
        message = "Wrong Password";
      } else {
        message = e.message ?? "Login Failed";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth =
        MediaQuery.of(context).size.width;

    double screenHeight =
        MediaQuery.of(context).size.height;

    bool isWeb = screenWidth > 800;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Stack(
          children: [
            /// BACKGROUND
            Column(
              children: [
                /// TOP ORANGE
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFff5c30),
                        Color(0xFFe74b1a),
                      ],
                    ),
                  ),
                ),

                /// WHITE
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(
                        topLeft:
                            Radius.circular(40),
                        topRight:
                            Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// ADMIN BUTTON
            Positioned(
              top: 15,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/adminLogin',
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                            30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons
                            .admin_panel_settings_outlined,
                        color:
                            Color(0xFFff5c30),
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Admin",
                        style: TextStyle(
                          color:
                              Color(0xFFff5c30),
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// CONTENT
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom,
              ),
              child: Center(
                child: Container(
                  width:
                      isWeb ? 450 : double.infinity,
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 40),

                      /// LOGO
                      Image.asset(
                        "images/logo.png",
                        width: isWeb
                            ? 280
                            : screenWidth / 1.6,
                        fit: BoxFit.cover,
                      ),

                      SizedBox(height: 40),

                      /// LOGIN CARD
                      Material(
                        elevation: 5,
                        borderRadius:
                            BorderRadius.circular(
                                20),
                        child: Container(
                          padding:
                              EdgeInsets.all(20),
                          decoration:
                              BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        20),
                          ),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Text(
                                  "Login",
                                  style: AppWidget
                                      .HeadlineTextFeildStyle(),
                                ),

                                SizedBox(
                                    height: 30),

                                /// EMAIL
                                TextFormField(
                                  controller:
                                      useremailcontroller,
                                  validator:
                                      (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .isEmpty) {
                                      return "Please Enter Email";
                                    }

                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(
                                    hintText:
                                        "Email",
                                    prefixIcon:
                                        Icon(Icons
                                            .email_outlined),
                                    border:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  12),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height: 25),

                                /// PASSWORD
                                TextFormField(
                                  controller:
                                      userpasswordcontroller,
                                  obscureText:
                                      true,
                                  validator:
                                      (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .isEmpty) {
                                      return "Please Enter Password";
                                    }

                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(
                                    hintText:
                                        "Password",
                                    prefixIcon:
                                        Icon(Icons
                                            .lock_outline),
                                    border:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  12),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height: 15),

                                /// FORGOT PASSWORD
                                Align(
                                  alignment:
                                      Alignment
                                          .centerRight,
                                  child:
                                      GestureDetector(
                                    onTap: () {
                                      Navigator
                                          .push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  ForgotPassword(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: AppWidget
                                          .semiBoldTextFeildStyle(),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height: 35),

                                /// LOGIN BUTTON
                                GestureDetector(
                                  onTap: () {
                                    if (_formkey
                                        .currentState!
                                        .validate()) {
                                      email =
                                          useremailcontroller
                                              .text
                                              .trim();

                                      password =
                                          userpasswordcontroller
                                              .text
                                              .trim();

                                      userLogin();
                                    }
                                  },
                                  child: Container(
                                    width:
                                        double.infinity,
                                    padding:
                                        EdgeInsets
                                            .symmetric(
                                      vertical: 15,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: Color(
                                          0xFFff5c30),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "LOGIN",
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize:
                                              18,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      /// SIGNUP
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          "Don't have an account? Sign up",
                          style: AppWidget
                              .semiBoldTextFeildStyle(),
                        ),
                      ),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}