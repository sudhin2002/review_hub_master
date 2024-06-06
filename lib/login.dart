import 'package:flutter/material.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';
import 'package:review_hub_admin/customWidgets/customTextField.dart';
import 'package:review_hub_admin/dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: AppText(
          size: 20,
          text: 'Review Hub',
          textcolor: white,
          weight: FontWeight.w500,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset('assets/images/bg.png',fit: BoxFit.cover,),
            ),
            Center(
              child: Container(
                width: 500,
                height: 500,
                color: maincolor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 18,right: 18,top: 28),
                      child: AppText(text: 'LOGIN', weight: FontWeight.w400, size: 25, textcolor: white),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60,right: 60,top: 18),
                          child: CustomTextField(
                              hint: 'Email Address',
                              controller: email,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter Email';
                                }
                                return null;
                              }),
                        ),
                  
                     Padding(
                        padding: const EdgeInsets.only(left: 60,right: 60,top: 18),
                       child: CustomTextField(
                           hint: 'Password',
                           controller: password,
                           validator: (value) {
                             if (value?.isEmpty ?? true) {
                               return 'Please enter Password';
                             }
                             return null;
                           }),
                     ),
                         ],
                    ),
                       InkWell(
                      onTap: (){
                        login();
                        // Navigator.push(context, MaterialPageRoute(builder:(context) {
                        //   return Dashboard();
                        // }, ));
                      },
                      child: Container(
                        height: 40,
                        width: 200,
                        color: white,
                        child: Center(
                          child: AppText(
                              text: 'Login',
                              weight: FontWeight.w500,
                              size: 20,
                              textcolor: maincolor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void login(){
   
 if (_formKey.currentState?.validate() ?? false) {
    const String adminEmail = 'admin@gmail.com';
    const String adminPassword = 'admin@123';

    if (email.text == adminEmail && password.text == adminPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successfull...')),
        );
      // Redirect to the admin home page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      }));
      return;
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Credentials...')),
        );
    }
 }
}
}