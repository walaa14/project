import 'dart:ui';
import'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note/auth/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget{
  const SignUp ({Key ? key}):super(key: key);
  @override
  _SignUpState createState()=>_SignUpState();

}

class _SignUpState extends State<SignUp>{
  var myusername ,mypassword,myemail;
  GlobalKey<FormState> formstate=new GlobalKey<FormState>();
  signUp() async{
    var formdata =formstate.currentState;
    if(formdata==null){
     return"notValid";

    }if(formdata.validate()){
      formdata.save();
      try {
        showLoading(context);
       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
       email: myemail,
       password: mypassword
     );
     return userCredential;
    } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Navigator.of(context).pop();
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
     // print('Valid');
    }else{
      print('not Valid');
    }
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body:ListView(
      padding: EdgeInsets.all(60),
      children:[
      Center(child:  Image.asset('images/logo.png',width:150,height:150)),
      Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key:formstate,
          child: Column(children: [
          TextFormField(
            onSaved: (value){
              myusername=value;
            },
            validator: (value){
               if (value == null || value.isEmpty) {
               return '*Required Feild';
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
              myemail=value;
            },
            validator: (value){
               if (value == null || value.isEmpty||value.length>100) {
               return '*Please enter Valid Email';
               }
               return null;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail),
              hintText: "Email",
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
              Text("if you have account "),
              InkWell(
                onTap: (){
                  //Navigator.of(context).pushNamed("login");
                  Navigator.of(context).pushReplacementNamed("login");
                },
                child: Text("Click Here",style: TextStyle(color: Colors.blue),)
              ),
            ],)
          ),
          Container
          (child:RaisedButton( 
            textColor: Colors.white, 
            onPressed: ()async{
              UserCredential response=await signUp();
              print('////////////////////////////////////');
              if(response != null){
                await FirebaseFirestore.instance.collection("users").add(
                  {"username":myusername,"email":myemail}
                );
                Navigator.of(context).pushReplacementNamed("home");
              }else{
                print('Sign Up faild');
              }
              print('////////////////////////////////////');

            },child : Text("SignUp" ,style:TextStyle(fontSize: 20),)))
        ],)),
      )
      ]),
  );
  }

}
