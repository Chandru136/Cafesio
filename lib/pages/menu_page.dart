import 'package:cafesio/constants/imgLinks.dart';
import 'package:cafesio/models/menu_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bottom_sheet/floating_modal.dart';
import '../bottom_sheet/modal_fit.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuItem> menuList = [];

  void initState() {
    super.initState();
    print('calling init state for menu');

    String today = DateFormat('ddMMyyyy').format(DateTime.now());
    print(today);

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("Menu").child("01092021");
    reference.once().then((DataSnapshot dataSnapshot) {
      menuList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        MenuItem menuItem = new MenuItem(
            values[key]["itemName"],
            values[key]["itemPrice"],
            values[key]["itemCount"],
            values[key]["itemImage"],
            values[key]["itemCategory"],
            values[key]["itemDescription"],
            values[key]["itemType"]);
        menuList.add(menuItem);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Today's Menu", style: TextStyle(color: Colors.grey.shade800)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: menuList.length == 0
          ? Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : customizedCard(menuList),
    );
  }

  String imagefun(itemType) {
    if (itemType == "veg") {
      return "assets/veg.png";
    } else if (itemType == "egg") {
      return "assets/egg.png";
    } else {
      return "assets/nonveg.png";
    }
  }

  Widget customizedCard(List<MenuItem> menuList) {
    /*24 is for notification bar on Android*/
    // var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    // final double itemWidth = size.width / 2;

    final double itemHeight = 100;
    final double itemWidth = 70;

    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: GridView.count(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        children: List.generate(menuList.length, (index) {
          return InkWell(
            onTap: () => showFloatingModalBottomSheet(
              context: context,
              builder: (context) => ModalFit(
                  itemName: menuList[index].itemName,
                  itemPrice: menuList[index].itemPrice,
                  itemCount: menuList[index].itemCount,
                  itemImage: menuList[index].itemImage,
                  itemCategory: menuList[index].itemCategory,
                  itemDescription: menuList[index].itemDescription,
                  itemType: menuList[index].itemType),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: Color(0xfff2f2f2),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      child: Image.network(
                        ImageLinks().imgLinks(menuList[index].itemName),
                        fit: BoxFit.fill,
                        height: 125.0,
                        width: MediaQuery.of(context).size.width,
                        loadingBuilder: (context, child, loadingProgress) {
                          return loadingProgress == null
                              ? child
                              : CircularProgressIndicator(
                                  color: Colors.redAccent);
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10.0),
                        child: Image.asset(imagefun(menuList[index].itemType),
                            width: 23, height: 23),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 8),
                        child: Text(
                          menuList[index].itemName,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "₹ " + menuList[index].itemPrice,
                          style: TextStyle(
                              fontSize: 17, color: Colors.green.shade600),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 7, left: 10),
                        padding: EdgeInsets.only(
                            left: 7, right: 7, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                            color: Color(0xfff3f3f3),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 1.0)),
                        child: Text(
                          menuList[index].itemCategory,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
