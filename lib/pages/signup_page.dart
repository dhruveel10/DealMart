import 'package:flutter/material.dart';
import 'package:dealmart/widget/support_widget.dart';
import 'package:dealmart/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dealmart/pages/bottom_nav.dart';
import 'package:random_string/random_string.dart';
import 'package:dealmart/services/database.dart';
import 'package:dealmart/services/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? name, email, password;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    if (password != null && name != null && email != null) {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));

        String id = randomAlphaNumeric(10);

        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserId(id);
        await SharedPreferenceHelper().saveUserImage(
            "https://firebasestorage.googleapis.com/v0/b/dealmart-27cea.appspot.com/o/person-image-icon-0.webp?alt=media&token=1ca97dc6-9710-4888-9264-e5262d6b5e12");

        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Id": id,
          "Image":
              "https://firebasestorage.googleapis.com/v0/b/dealmart-27cea.appspot.com/o/person-image-icon-0.webp?alt=media&token=1ca97dc6-9710-4888-9264-e5262d6b5e12"
        };

        await DatabaseMethods().addUserDetails(userInfoMap, id);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Weak Password",
                style: TextStyle(fontSize: 20.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Account already exist",
                style: TextStyle(fontSize: 20.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 25, left: 40, right: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/login_photo.jpg"),
                Center(
                  child: Text(
                    "Register",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "Please enter the details below to continue",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Name",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F9),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please Enter your Name";

                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Enter your name",
                        contentPadding: EdgeInsets.only(left: 10)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Email",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F9),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please Enter your Email";

                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Enter your email",
                        contentPadding: EdgeInsets.only(left: 10)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Password",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F9),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please Enter your Password";

                      return null;
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        name = nameController.text;
                        email = emailController.text;
                        password = passwordController.text;
                      });
                    }
                    registration();
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Color(0xff0d3479),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
