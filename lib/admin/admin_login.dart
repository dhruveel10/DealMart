import 'package:flutter/material.dart';
import 'package:dealmart/widget/support_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_screen.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  String? email, password;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  loginAdmin() {
    FirebaseFirestore.instance.collection("admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['email'] != emailController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Incorrect email",
              style: TextStyle(fontSize: 20.0),
            ),
          ));
        } else if (result.data()['password'] != passwordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Incorrect Password",
              style: TextStyle(fontSize: 20.0),
            ),
          ));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,  // Ensure that the UI adjusts when the keyboard is shown
      body: SingleChildScrollView(  // Allows scrolling when content overflows
        child: Container(
          margin: EdgeInsets.only(top: 25, left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35,),
              Image.asset("images/login_photo.jpg"),
              SizedBox(height: 25,),
              Center(
                child: Text(
                  "Admin Login",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Please enter the details below to continue",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Email",
                style: AppWidget.semiboldTextFieldStyle(),
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF4F5F9),
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Enter your email",
                      contentPadding: EdgeInsets.only(left: 10)),
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Password",
                style: AppWidget.semiboldTextFieldStyle(),
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF4F5F9),
                ),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  loginAdmin();
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

}
