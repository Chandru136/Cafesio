import 'package:cafesio/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as rtDatabase;
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  void initState() {
    super.initState();
    print('calling init state for History');
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> readItems() {
    Query collectionReference = FirebaseFirestore.instance
        .collection("Orders")
        .where("uid", isEqualTo: uid)
        .orderBy("timeStamp", descending: true);
    return collectionReference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: readItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 0.5,
                color: Colors.grey,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var orderInfo =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                Timestamp timestamp = orderInfo["timeStamp"];

                double halfWidth = MediaQuery.of(context).size.width / 2;

                if (orderInfo.isNotEmpty) {
                  if (index == 0) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 75,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 75,
                                child: Center(
                                  child: Text(
                                    "History",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 75,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.logout_outlined,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AuthService().handleAuth(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              cancelOrder(
                                  orderInfo["dateStamp"],
                                  orderInfo["orderID"],
                                  orderInfo["orderStatus"]);
                            },
                            child: ListTile(
                              title: Container(
                                width: halfWidth,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 15, left: 15),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          orderInfo["orderID"],
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 8, left: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Total Items : " +
                                              orderInfo["numberOfItems"],
                                          style: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: 15.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 8, left: 15, bottom: 10),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          orderInfo["dateStamp"]
                                                  .toString()
                                                  .substring(0, 2) +
                                              "." +
                                              orderInfo["dateStamp"]
                                                  .toString()
                                                  .substring(2, 4) +
                                              "." +
                                              orderInfo["dateStamp"]
                                                  .toString()
                                                  .substring(4) +
                                              "\n" +
                                              timestamp
                                                  .toDate()
                                                  .hour
                                                  .toString() +
                                              ":" +
                                              timestamp
                                                  .toDate()
                                                  .minute
                                                  .toString() +
                                              ":" +
                                              timestamp
                                                  .toDate()
                                                  .second
                                                  .toString(),
                                          style: TextStyle(
                                            color: Color(0xff848484),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Container(
                                width: halfWidth,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 5, right: 15),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          "₹ " + orderInfo["orderPrice"],
                                          style: TextStyle(
                                            color: Color(0xff50C878),
                                            fontSize: 16.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 7, right: 15),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          orderInfo["orderStatus"],
                                          style: TextStyle(
                                            color: colorCode(
                                                orderInfo["orderStatus"]),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        cancelOrder(orderInfo["dateStamp"],
                            orderInfo["orderID"], orderInfo["orderStatus"]);
                      },
                      child: ListTile(
                        title: Container(
                          width: halfWidth,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 15, left: 15),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    orderInfo["orderID"],
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8, left: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Total Items : " +
                                        orderInfo["numberOfItems"],
                                    style: TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: 15.5,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 8, left: 15, bottom: 10),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    orderInfo["dateStamp"]
                                            .toString()
                                            .substring(0, 2) +
                                        "." +
                                        orderInfo["dateStamp"]
                                            .toString()
                                            .substring(2, 4) +
                                        "." +
                                        orderInfo["dateStamp"]
                                            .toString()
                                            .substring(4) +
                                        "\n" +
                                        timestamp.toDate().hour.toString() +
                                        ":" +
                                        timestamp.toDate().minute.toString() +
                                        ":" +
                                        timestamp.toDate().second.toString(),
                                    style: TextStyle(
                                      color: Color(0xff848484),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Container(
                          width: halfWidth,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 5, right: 15),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "₹ " + orderInfo["orderPrice"],
                                    style: TextStyle(
                                      color: Color(0xff50C878),
                                      fontSize: 16.5,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7, right: 15),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      orderInfo["orderStatus"],
                                      style: TextStyle(
                                        color:
                                            colorCode(orderInfo["orderStatus"]),
                                        fontSize: 18,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(child: Text("You haven't made any orders"));
                }
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          );
        },
      ),
    );
  }

  Color colorCode(status) {
    if (status == "Active") {
      return Color(0xff50c878);
    } else if (status == "Delivered") {
      return Color(0xff848484);
    } else {
      return Color(0xffEE4B2B);
    }
  }

  void cancelOrder(dateStamp, orderID, orderStatus) {
    if (orderStatus == "Active") {
      Widget cancelButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("Cancel Order"),
        onPressed: () {
          rtDatabase.DatabaseReference reference =
              rtDatabase.FirebaseDatabase.instance.reference().child("Orders");

          reference
              .child(dateStamp)
              .child(orderID)
              .child("orderStatus")
              .set("Cancelled")
              .whenComplete(
                () => {
                  FirebaseFirestore.instance
                      .collection("Orders")
                      .doc(orderID)
                      .update(
                    {
                      "orderStatus": "Cancelled",
                    },
                  ).whenComplete(
                    () => {
                      ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Order cancelled successfully")),
              ),
                    //   showToast(
                    //     "Order cancelled successfully",
                    //     context: context,
                    //     animation: StyledToastAnimation.fadeScale,
                    //     reverseAnimation: StyledToastAnimation.fade,
                    //     position: StyledToastPosition.bottom,
                    //     animDuration: Duration(seconds: 1),
                    //     duration: Duration(seconds: 3),
                    //     curve: Curves.elasticOut,
                    //     reverseCurve: Curves.linear,
                    //   ),
                    //   Navigator.of(context).pop(),
                    },
                  )
                },
              )
              .onError((error, stackTrace) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              ),
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
                    // )
                  });
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Cancel Order"),
        content: Text("Would you like to cancel your order with order number " +
            orderID +
            "?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }
}
