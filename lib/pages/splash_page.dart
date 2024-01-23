import 'package:cafesio/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//import 'login_page.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AuthService().handleAuth()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: Lottie.asset("assets/lottie_grey_food.json", repeat: false),
          ),
        ),
      ),
    );
  }
}
