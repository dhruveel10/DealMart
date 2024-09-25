import 'package:dealmart/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:dealmart/widget/support_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealmart/services/database.dart';

class ProductCategoryPage extends StatefulWidget {
  final String category;

  ProductCategoryPage({required this.category});

  @override
  State<ProductCategoryPage> createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  Stream<QuerySnapshot>? categoryStream;

  loadCategory() async {
    categoryStream = await DatabaseMethods().getCategoryProducts(widget.category);
    setState(() {}); // Rebuild the widget with the new data
  }

  @override
  void initState() {
    super.initState();
    loadCategory();
  }

  Widget allProducts() {
    return StreamBuilder(
        stream: categoryStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products found"));
          }

          return GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      SizedBox(height: 15.0,),
                      Image.network(
                        ds["Image"],
                        height: 170,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 15,),
                      Text(
                        ds["Name"],
                        style: AppWidget.semiboldTextFieldStyle(),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${ds["Price"]}",
                            style: TextStyle(
                              color: Color(0xFFfd6f3e),
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsPage(description: 
                                  ds["Description"], image: ds["Image"], name: ds["Name"], price: ds["Price"])
                                ),
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: Color(0xFFfd6f3e),
                                    borderRadius: BorderRadius.circular(7)),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 35,
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
              child: allProducts(),
            )
          ],
        ),
      ),
    );
  }
}
