import 'package:flutter/material.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';
import 'package:review_hub_admin/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center( 
                  child: AppText(
                      text: 'REVIEW HUB',
                      weight: FontWeight.bold,
                      size: 60,
                      textcolor: maincolor)),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context) {
                    return Login();
                  }, ));
                },
                child: Container(
                  height: 40,
                  width: 200,
                  color: maincolor,
                  child: Center(
                    child: AppText(
                        text: 'Login',
                        weight: FontWeight.w500,
                        size: 20,
                        textcolor: white),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
