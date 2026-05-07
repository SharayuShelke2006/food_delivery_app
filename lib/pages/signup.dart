import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/bottomnav.dart';
import 'package:food_delivery_app/pages/login.dart';
import 'package:food_delivery_app/services/database.dart';
import 'package:food_delivery_app/services/shared_pref.dart';
import 'package:food_delivery_app/widget/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";

  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Registered Successfully",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );

      String Id = randomAlphaNumeric(10);

      Map<String, dynamic> addUserInfo = {
        "Name": namecontroller.text,
        "Email": mailcontroller.text,
        "Wallet": "0",
        "Id": Id,
      };

      await DatabaseMethods().addUserDetail(addUserInfo, Id);

      await SharedPreferenceHelper()
          .saveUserName(namecontroller.text);

      await SharedPreferenceHelper()
          .saveUserEmail(mailcontroller.text);

      await SharedPreferenceHelper().saveUserId(Id);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNav(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "Password Provided is too Weak",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "Account Already Exists",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isWeb = screenWidth > 800;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              /// Orange Background
              Container(
                width: screenWidth,
                height: screenHeight * 0.35,
                decoration: const BoxDecoration(
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

              /// White Background
              Container(
                margin: EdgeInsets.only(
                  top: screenHeight * 0.25,
                ),
                width: screenWidth,
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),

              /// Main Content
              Center(
                child: Container(
                  width: isWeb ? 500 : screenWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      /// Logo
                      Image.asset(
                        "images/logo.png",
                        width: isWeb ? 300 : screenWidth * 0.7,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 40),

                      /// Signup Card
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                /// Title
                                Center(
                                  child: Text(
                                    "Sign Up",
                                    style: AppWidget
                                        .HeadlineTextFeildStyle(),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                /// Name
                                TextFormField(
                                  controller: namecontroller,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Please Enter Name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: AppWidget
                                        .semiBoldTextFeildStyle(),
                                    prefixIcon: const Icon(
                                      Icons.person_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              12),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// Email
                                TextFormField(
                                  controller: mailcontroller,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Please Enter E-mail';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: AppWidget
                                        .semiBoldTextFeildStyle(),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              12),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// Password
                                TextFormField(
                                  controller:
                                      passwordcontroller,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: AppWidget
                                        .semiBoldTextFeildStyle(),
                                    prefixIcon: const Icon(
                                      Icons.password_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              12),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 40),

                                /// Sign Up Button
                                GestureDetector(
                                  onTap: () async {
                                    if (_formkey
                                        .currentState!
                                        .validate()) {
                                      setState(() {
                                        email =
                                            mailcontroller.text;
                                        name =
                                            namecontroller.text;
                                        password =
                                            passwordcontroller
                                                .text;
                                      });

                                      registration();
                                    }
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color(0Xffff5722),
                                      borderRadius:
                                          BorderRadius.circular(
                                              15),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "SIGN UP",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins1',
                                          fontWeight:
                                              FontWeight.bold,
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

                      const SizedBox(height: 30),

                      /// Login Navigation
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogIn(),
                            ),
                          );
                        },
                        child: Text(
                          "Already have an account? Login",
                          style: AppWidget
                              .semiBoldTextFeildStyle(),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}