import 'dart:convert';

import 'package:dealmart/services/constants.dart';
import 'package:dealmart/services/database.dart';
import 'package:dealmart/services/shared_preferences.dart';
import 'package:dealmart/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ProductDetailsPage extends StatefulWidget {
  String image, name, description, price;
  ProductDetailsPage(
      {required this.description,
      required this.image,
      required this.name,
      required this.price});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Map<String, dynamic>? paymentIntent;
  String? name, email;

  getSharedPrefData()async{
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();

    setState(() {
      
    });
  } 

  onLoad()async{
    await getSharedPrefData();
    setState(() {
      
    });
  }

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: "Dhruveel"))
          .then((value) {});

      displayPaymentSheet();
    } catch (e, s) {
      print('Exception: $e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {

        Map<String, dynamic> orderInformationMap = {
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email": email,
          "ProductImage": widget.image,
        };
        await DatabaseMethods().orderDetails(orderInformationMap);

        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text(
                            "Payment Successful",
                            style: AppWidget.semiboldTextFieldStyle(),
                          ),
                        ],
                      )
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Error: $error $stackTrace");
      });
    } on StripeException catch (e) {
      print('Error: $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Payment Cancelled"),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer $secret_key',
            'Content-type': 'application/x-www-form-urlencoded'
          }, body: body,
          );
          return jsonDecode(response.body);
    } catch (err) {
      print("Error during the payment: ${err.toString()}");
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfef5f1),
      body: Container(
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30)),
                    child: Icon(Icons.arrow_back_ios_new_outlined)),
              ),
              Center(
                child: Image.network(
                  widget.image,
                  height: 400,
                ),
              )
            ]),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                          widget.price,
                          style: TextStyle(
                            color: Color(0xFFfd6f3e),
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.description,
                      style: AppWidget.semiboldTextFieldStyle(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Loren ipsum",
                    ),
                    SizedBox(
                      height: 90,
                    ),
                    GestureDetector(
                      onTap: (){
                        makePayment(widget.price);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Color(0xFFfd6f3e),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Text(
                          "Buy Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
