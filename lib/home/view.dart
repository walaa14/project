import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:note/main.dart';

class View extends StatefulWidget{
  final title,text,imageurl;

  const View ({Key ? key,this.text,this.title,this.imageurl}):super(key: key);
  @override
  State<StatefulWidget> createState()=>ViewState();
  
}
class ViewState extends State<View>{
 
  @override
  Widget build(BuildContext context) {
return Scaffold(appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,    
        title: Text('View Notes'),
      
),
body: Container(  
  alignment: Alignment.center,
  padding: EdgeInsets.only(top:50),
  child: Column(children: [
Text(widget.title,style: Theme.of(context).textTheme.headline2,)
,
Container( 
  alignment: Alignment.center,
  padding: EdgeInsets.only(top:20),
  child: Column(children: [
Text(widget.text)
],)),Expanded( 
child: Column(
 children: [
   Image.network("${widget.imageurl}", fit: BoxFit.fitWidth,height: 450,),
 ],
) 
   
  ),
],)),
);
  }
  
}