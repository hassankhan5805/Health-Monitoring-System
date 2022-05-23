import 'package:demo_button/firebase/auth.dart';
import 'package:demo_button/screens/homepage.dart';
import 'package:demo_button/screens/signup.dart';
import 'package:demo_button/screens/verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void setStatus() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences preferences = await _prefs;
    preferences.setInt('Log', 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff040F23),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(left: 20, right: 20, bottom: kToolbarHeight - 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset('assets/logo.png'),
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.withOpacity(0.5))),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: !isPasswordVisible,
                    controller: passwordController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.withOpacity(0.5)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      emailController.text.isEmpty
                          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please enter your email.',
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ))
                          : Fluttertoast.showToast(
                              backgroundColor: Color(0xff040F23),
                              textColor: Colors.white,
                              msg:
                                  'Password reset email sent to ${emailController.text}');
                    },
                    child: Text('Forgot Passord?')),
                SizedBox(
                  height: 40,
                ),
               isLoading ? CircularProgressIndicator(): GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (!_formKey.currentState.validate()) {
                      return null;
                    } else {
                      await signinWithEmail(
                              emailController.text, passwordController.text)
                          .then((value) {
                        if (value != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ));
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          if (FirebaseAuth.instance.currentUser.emailVerified) {
                            setStatus();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                                     setState(() {
                            isLoading = false;
                          });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VerificationScreen()));
                                         setState(() {
                            isLoading = false;
                          });
                          }
                        }
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xff040F23)),
                    child: Center(
                        child: Text('Login',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return SignupScreen();
                          }));
                        },
                        child: Text(
                          'Create one',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
