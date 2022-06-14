import 'package:flutter/material.dart';
import 'package:note/auth/login.dart';
import 'dart:async';
import 'package:note/home/homepage.dart';
import 'auth/signup.dart';
import 'home/addnotes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isLogin=false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user=FirebaseAuth.instance.currentUser;
  if(user==null){
    isLogin=false;
  }else{
    isLogin=true;
  }
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:isLogin==false?Login():Home(),
      theme: ThemeData(
        
        primaryColor: Color.fromARGB(255, 235, 207, 68),
        buttonColor: Color.fromARGB(255, 235, 207, 68),
        textTheme: TextTheme(headline2: TextStyle(fontSize: 20,color: Color.fromARGB(255, 112, 111, 109)))
      
      ),
      routes:{
        "login":(context)=>Login(),
        "signup":(context) => SignUp(),
        "home":(context)=>Home(),
        "addnotes":(context) => Add(),
      },
    );
  }
  
}
