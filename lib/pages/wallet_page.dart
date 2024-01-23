import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cafesio/models/wallet_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  List<WalletItem> walletList = [];

  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  //String uid = "wYUrvmfiJlWNsEBY0evxbf0pgpt2";
  String balance = "";

  @override
  void initState() {
    super.initState();
    print('calling init state for wallet');

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("Wallet");
    reference.child(uid).once().then((value) => {
          if (value.exists)
            {
              reference.child(uid).child("balance").once().then((snapshot) =>
                  {balance = snapshot.value.toString(), setState(() {})}),
              reference
                  .child(uid)
                  .child("Transactions")
                  .once()
                  .then((dataSnapshot) {
                walletList.clear();
                if (dataSnapshot.exists) {
                  var keys = dataSnapshot.value.keys;
                  var values = dataSnapshot.value;

                  for (var key in keys) {
                    WalletItem walletItem = new WalletItem(
                        values[key]["dateStamp"],
                        values[key]["transAmount"],
                        values[key]["transID"],
                        values[key]["transStatus"]);
                    walletList.add(walletItem);
                  }
                }
                print("length " + walletList.length.toString());
                setState(() {});
              }),
            }
          else
            {
              reference.child(uid).set({
                "balance": "0",
                "uid": uid,
                "walletStatus": "active"
              }).whenComplete(
                () => reference.child(uid).child("balance").once().then(
                    (snapshot) =>
                        {balance = snapshot.value.toString(), setState(() {})}),
              )
            }
        });
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
      body: walletList.length == 0
          ? Column(
              children: [
                BalanceContainer(balance: balance),
                BalancePadding(),
                Spacer(),
                Center(
                  child: Text("No Transactions yet"),
                ),
                Spacer(),
              ],
            )
          : ListView.builder(
              itemCount: walletList.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    children: [
                      BalanceContainer(balance: balance),
                      BalancePadding(),
                      ListItem(
                          transId: walletList[index].transID,
                          transDate: walletList[index].dateStamp,
                          transAmount: walletList[index].transAmount,
                          transType: walletList[index].transStatus == "success"
                              ? 1
                              : 0),
                    ],
                  );
                } else {
                  return ListItem(
                      transId: walletList[index].transID,
                      transDate: walletList[index].dateStamp,
                      transAmount: walletList[index].transAmount,
                      transType:
                          walletList[index].transStatus == "success" ? 1 : 0);
                }
              },
            ),
    );
  }
}

class BalancePadding extends StatelessWidget {
  const BalancePadding({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 14.0,
        top: 16,
        bottom: 10.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Recharge History",
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class BalanceContainer extends StatelessWidget {
  const BalanceContainer({
    Key? key,
    required this.balance,
  }) : super(key: key);

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14.0),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey, width: 0.9),
      ),
      child: Column(
        children: [
          SizedBox(height: 15.0),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Available balance in wallet",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.center,
            child: Text(
              "₹ " + balance,
              style: TextStyle(
                fontSize: 35,
                color: Colors.green.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Spacer(),
          BouncingWidget(
            duration: Duration(milliseconds: 100),
            scaleFactor: 0.5,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Add Money to the Wallet")),
              );
              // showToast(
              //   "Add Money to the Wallet",
              //   context: context,
              //   animation: StyledToastAnimation.fadeScale,
              //   reverseAnimation: StyledToastAnimation.fade,
              //   position: StyledToastPosition.bottom,
              //   animDuration: Duration(seconds: 1),
              //   duration: Duration(seconds: 3),
              //   curve: Curves.elasticOut,
              //   reverseCurve: Curves.linear,
              // );
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(
                left: 14,
                right: 14,
                bottom: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Center(
                child: Text(
                  "Add Money",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem(
      {required this.transId,
      required this.transDate,
      required this.transAmount,
      required this.transType});

  final String transId, transDate, transAmount;
  final int transType;

  IconData typeIcon(transType) {
    return transType == 0 ? Icons.error : Icons.add_business_rounded;
  }

  Color typeColor(transType) {
    return transType == 0 ? Colors.red : Colors.blue;
  }

  String month(index) {
    List<String> monthList = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthList[index - 1];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        title: Text(
          transId,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          transDate.substring(0, 2) +
              " " +
              month(int.parse(transDate.substring(2, 4))) +
              " " +
              transDate.substring(4),
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: typeColor(transType),
          child: Icon(
            typeIcon(transType),
            color: Colors.white,
          ),
        ),
        trailing: Text(
          "₹" + transAmount,
          style: TextStyle(
            fontSize: 18,
            color: Colors.green.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
