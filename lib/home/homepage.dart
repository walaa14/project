import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:note/home/view.dart';
import 'package:note/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:note/home/edit.dart';
import 'package:note/home/ViewText.dart';

class Home extends StatefulWidget{
  const Home ({Key ? key}):super(key: key);
  @override
  _HomeState createState()=>_HomeState();

}

class _HomeState extends State<Home>{
 Query<Map<String, dynamic>> notes=FirebaseFirestore.instance.collection("Notes").where('userid',isEqualTo: FirebaseAuth.instance.currentUser?.uid);
  getUser(){
    var user =FirebaseAuth.instance.currentUser;
    if(user==null){
      print('not Valid');
    }else{
      print(user.email);
    }
  }
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Theme.of(context).primaryColor,
       title: Text('Home'),
       actions: [
         IconButton(icon: Icon( Icons.exit_to_app, color: Colors.white,),
         onPressed:()async{
           await FirebaseAuth.instance.signOut();
           Navigator.of(context).pushReplacementNamed('login');
         } ,)
       ],
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.add),onPressed: (){
         Navigator.of(context).pushNamed("addnotes");
       },backgroundColor: Colors.red,),
       body: Container(
  //////////////////////////////////////////////////
      child: FutureBuilder<QuerySnapshot>(
        future:  notes.get(),
        builder: ((context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) { 
          return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,i){
             var data=snapshot.data!.docs[i];           
//            return Text(data['title']);
              return InkWell(
                onTap: (){ Navigator.of(context)
                .push(MaterialPageRoute(builder: (context){
                  if (data['imageurl']==null) {
                  return ViewText(title:data['title'],text:data['note']);
                  }else{
                  return View(title:data['title'],text:data['note'],imageurl: data['imageurl'],);
                }})
                  );},
                child: Card(
                 child:Row(children: [
                   Expanded(
                    
                     ///data['imageurl']
                  child: Image.asset("images/note.png",height: 100,width: 100,),
                   ),Expanded(
                     child:ListTile(
                       title: Text("${data['title']}"),
                       subtitle:Text("${data['note']}"),
                       trailing: IconButton(onPressed: ( ) { 
                         Navigator.push(context,MaterialPageRoute(
                          builder: (context) => Edit(id:data['userid'],title:data['title'],text:data['note'],)),
                          ); },icon: Icon(Icons.edit),),
                          
 ))],),),
              );});
        }else CircularProgressIndicator();
        return Text("data");
      })),
  //////////////////////////////////////////////////
    ),
   );
  }
}

