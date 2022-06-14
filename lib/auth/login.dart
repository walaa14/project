import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:note/auth/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Login extends StatefulWidget{
  const Login ({Key ? key}):super(key: key);
  @override
  _LoginState createState()=>_LoginState();

}



class _LoginState extends State<Login>{
  var mypassword,myemail;
  GlobalKey<FormState> formstate=new GlobalKey<FormState>();
  signIn() async{
    var formdata =formstate.currentState;
    if(formdata==null){
     return"notValid";

    }if(formdata.validate()){
      formdata.save();
      try {
        showLoading(context);
     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
     email: myemail,
     password: mypassword
     );
     return userCredential;
}    on FirebaseAuthException catch (e) {
     if (e.code == 'user-not-found') {
      Navigator.of(context).pop();
      print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
     Navigator.of(context).pop();
     print('Wrong password provided for that user.');
  }
}
     // print('Valid');
    }else{
      print('not Valid');
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
      Center(child:  Image.asset('images/logo.png',width:150,height:150)),
      Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key:formstate,
          child: Column(children: [
          TextFormField(
             onSaved: (value){
              myemail=value;
            },
            validator: (value){
               if (value == null || value.isEmpty||value.length>100) {
               return '*Please enter Valid Email';
               }
               return null;
            },

            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              hintText: "Username",
              border: OutlineInputBorder(
                borderSide:BorderSide(width:1)
                )
            ),
          ),
          SizedBox(height: 20,),
          TextFormField(
             onSaved: (value){
              mypassword=value;
            },
            validator: (value){
               if (value == null || value.isEmpty||value.length>100) {
               return '*Please enter valid password';
               }if(value.length<4){
               return "*Password can't be less than 4 letters";

               }
               return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: "Password",
              border: OutlineInputBorder(
                borderSide:BorderSide(width:1)
              )
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child:Row(children: [
              Text("if you have not account "),
              InkWell(
                onTap: (){
                  Navigator.of(context).pushReplacementNamed("signup");
                },
                child: Text("Click Here",style: TextStyle(color: Colors.blue),)
              ),
            ],)
          ),
          Container
          (child:RaisedButton( 
            textColor: Colors.white, 
            onPressed: () async{
            var user= await  signIn();
            if(user != null){
              Navigator.of(context).pushReplacementNamed('home');
            }
            },child : Text("Login" ,style:TextStyle(fontSize: 20),)))
        ],)),
      )
      ]),
  );
  }
}