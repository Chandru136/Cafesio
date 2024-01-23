import 'dart:math';

import 'package:cafesio/constants/imgLinks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ModalFit extends StatefulWidget {
  String itemName,
      itemPrice,
      itemCount,
      itemImage,
      itemCategory,
      itemDescription,
      itemType;

  ModalFit(
      {required this.itemName,
      required this.itemPrice,
      required this.itemCount,
      required this.itemImage,
      required this.itemCategory,
      required this.itemDescription,
      required this.itemType});

  @override
  State<ModalFit> createState() => _ModalFitState();
}

////source control
class _ModalFitState extends State<ModalFit> {
  late int pricing;

  String imagefun(itemType) {
    if (itemType == "veg") {
      return "assets/veg.png";
    } else if (itemType == "egg") {
      return "assets/egg.png";
    } else {
      return "assets/nonveg.png";
    }
  }

  int _counter = 1;

  String price(priceOfItem) {
    pricing = int.parse(priceOfItem) * _counter;
    return pricing.toString();
  }

  void _incrementCounter() {
    setState(() {
      if (_counter < 10) {
        _counter++;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        if (_counter == 1) {
          Navigator.of(context).pop();
        }
        _counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    ImageLinks().imgLinks(widget.itemName),
                    fit: BoxFit.fill,
                    height: 250.0,
                    width: MediaQuery.of(context).size.width,
                    loadingBuilder: (context, child, loadingProgress) {
                      return loadingProgress == null
                          ? child
                          : CircularProgressIndicator(color: Colors.redAccent);
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 15.0),
                  child: Image.asset(
                    imagefun(widget.itemType),
                    width: 23,
                    height: 23,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15, top: 15),
                  child: Text(
                    "₹ " + price(widget.itemPrice),
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15, top: 7),
                  child: Text(
                    widget.itemName,
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double?>(0),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(20, 20)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        onPressed: _decrementCounter,
                        child: Center(
                          child: Text(
                            "-",
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 31,
                        child: Center(
                          child: Text(
                            '$_counter',
                            style: TextStyle(
                                fontSize: 24, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double?>(0),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(20, 20)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        onPressed: _incrementCounter,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, left: 13),
                  padding:
                      EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
                  decoration: BoxDecoration(
                      color: Color(0xfff3f3f3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 1.0)),
                  child: Text(
                    widget.itemCategory,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(widget.itemDescription,
                  style: TextStyle(color: Colors.grey.shade700)),
            ),
            // ListTile(
            //   title: Text(itemType),
            //   //onTap: () => Navigator.of(context).pop(),
            // )
            SizedBox(height: 10),
            ElevatedButton(
              child: Text(
                "Add to cart",
                style: TextStyle(color: Colors.redAccent),
              ),
              style: ButtonStyle(
                enableFeedback: true,
                elevation: MaterialStateProperty.all<double?>(2),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width - 70, 50)),
              ),
              onPressed: () {
                sendToFirebase(widget.itemName, _counter.toString(),
                    widget.itemPrice, pricing.toString());
              },
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  void sendToFirebase(itemName, itemCount, itemPrice, totalPrice) {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("Cart").child(uid);

    reference.once().then((onValue) {
      if (onValue.exists) {
        Map data = onValue.value;
        int count = data.length;
        String itemID = generateRandomString();

        if (count < 5) {
          reference.child(itemID).set({
            "itemName": itemName,
            "itemCount": itemCount,
            "itemPrice": itemPrice,
            "totalPrice": totalPrice,
            "itemID": itemID
          }).whenComplete(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Done")),
            );
            // showToast(
            //   'Done',
            //   context: context,
            //   animation: StyledToastAnimation.fadeScale,
            //   reverseAnimation: StyledToastAnimation.fade,
            //   position: StyledToastPosition.bottom,
            //   animDuration: Duration(seconds: 1),
            //   duration: Duration(seconds: 3),
            //   curve: Curves.elasticOut,
            //   reverseCurve: Curves.linear,
            // );
            Navigator.of(context).pop();
          }).onError((error, stackTrace) {
            print(error.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
            // showToast(
            //   error.toString(),
            //   context: context,
            //   animation: StyledToastAnimation.fadeScale,
            //   reverseAnimation: StyledToastAnimation.fade,
            //   position: StyledToastPosition.bottom,
            //   animDuration: Duration(seconds: 1),
            //   duration: Duration(seconds: 3),
            //   curve: Curves.elasticOut,
            //   reverseCurve: Curves.linear,
            // );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your cart is full")),
          );
          // showToast(
          //   "Your cart is full",
          //   context: context,
          //   animation: StyledToastAnimation.fadeScale,
          //   reverseAnimation: StyledToastAnimation.fade,
          //   position: StyledToastPosition.bottom,
          //   animDuration: Duration(seconds: 1),
          //   duration: Duration(seconds: 3),
          //   curve: Curves.elasticOut,
          //   reverseCurve: Curves.linear,
          // );
        }
      } else {
        String itemID = generateRandomString();

        reference.child(itemID).set({
          "itemName": itemName,
          "itemCount": itemCount,
          "itemPrice": itemPrice,
          "totalPrice": totalPrice,
          "itemID": itemID
        }).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Done")),
          );
          // showToast(
          //   'Done',
          //   context: context,
          //   animation: StyledToastAnimation.fadeScale,
          //   reverseAnimation: StyledToastAnimation.fade,
          //   position: StyledToastPosition.bottom,
          //   animDuration: Duration(seconds: 1),
          //   duration: Duration(seconds: 3),
          //   curve: Curves.elasticOut,
          //   reverseCurve: Curves.linear,
          // );
          Navigator.of(context).pop();
        }).onError((error, stackTrace) {
          print(error.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
          // showToast(
          //   error.toString(),
          //   context: context,
          //   animation: StyledToastAnimation.fadeScale,
          //   reverseAnimation: StyledToastAnimation.fade,
          //   position: StyledToastPosition.bottom,
          //   animDuration: Duration(seconds: 1),
          //   duration: Duration(seconds: 3),
          //   curve: Curves.elasticOut,
          //   reverseCurve: Curves.linear,
          // );
        });
      }
    });
  }

  String generateRandomString() {
    var r = Random.secure();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(10, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
