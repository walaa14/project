
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' ;


class Add extends StatefulWidget{
  const Add ({Key ? key}):super(key: key);
  @override
  _AddState createState()=>_AddState();

}

class _AddState extends State<Add>{
  var ref;
  var title,note,imageurl;
    GlobalKey<FormState> formstate=new GlobalKey<FormState>();
    CollectionReference notesref=FirebaseFirestore.instance.collection("Notes");

    addNote()async{
      var formdata=formstate.currentState;
      if(formdata==null){
        return"notValid";

    }if (formdata.validate()) {
      formdata.save();
     
      await notesref.add({
        "title":title,
        "note":note,
        "userid":FirebaseAuth.instance.currentUser?.uid
        ,"imageurl":imageurl
        });
        Navigator.of(context).pushNamed('home');

    }
    }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Add NOTE"),
      ),
      body: Container(child: Column(children: [
        Form(
          key: formstate,
          child: Column(children: [
        
          TextFormField(
            validator: (value){
               if (value == null || value.isEmpty||value.length<5) {
               return "Title can't be less than 5 letters";
               }
               return null;
            },
            onSaved: (value){
              note=value;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "Add Title",
              prefixIcon: Icon(Icons.title),
),),
          
          TextFormField(
            validator: (value){
               if (value == null || value.isEmpty||value.length<2) {
               return "Note can't be less than 2 letters";
               }
               return null;
            },
            onSaved: (value){
              title=value;
            },
            minLines: 1,maxLines: 5,maxLength: 1000,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "Add Your Notes",
              prefixIcon: Icon(Icons.text_fields),
),),


        ],)),
        Container(child: Row(children: [
Padding(padding: EdgeInsets.symmetric(horizontal: 40)),

  RaisedButton(onPressed: (){
    showButtomImage();
  },
textColor: Colors.white,
child: Text("Add Image",style: TextStyle(fontSize: 20))),
Padding(padding: EdgeInsets.only(right:20)),
RaisedButton(
onPressed: ()async{
  await addNote();
},
textColor: Colors.white,
child: Text("Add Note",style: TextStyle(fontSize: 20),),

)
]),)

      ],),),
    );
  }

  showButtomImage(){
return showModalBottomSheet(context: context, builder: (BuildContext contect){
  return Container(
    padding:EdgeInsets.all(20),
    height: 170, 
    
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text("Choose Image",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
     
     InkWell(
       onTap: ()async{
        var pick=await ImagePicker().getImage(source: ImageSource.gallery);
                if (pick !=null) {
               File file=File(pick.path) ;
                var random =Random().nextInt(100000);
                var imagename="$random"+Path.basename(pick.path);
                ref=FirebaseStorage.instance.ref("assets").child("$imagename");
                await ref.putFile(file);
                imageurl=await ref.getDownloadURL();
                return imageurl;
                }
               },
        child: Container(
  
        width:double.infinity,
        padding:EdgeInsets.all(10),
        child:Row(children: [Icon(Icons.photo_album) ,SizedBox(width:20),Text("From Gallery",style: TextStyle(fontSize: 20))],)
),
     ),InkWell(
       onTap: ()async{
               var pick=await ImagePicker().getImage(source: ImageSource.camera);
                if (pick !=null) {
               File file=File(pick.path) ;
                var random =Random().nextInt(100000);
                var imagename="$random"+Path.basename(pick.path);
                ref=FirebaseStorage.instance.ref("assets").child("$imagename");
                await ref.putFile(file);
                imageurl=await ref.getDownloadURL();
                return imageurl;
               }
                },
child: Container(
  width:double.infinity,
  padding:EdgeInsets.all(10),
  child:Row(children: [Icon(Icons.photo_camera) ,SizedBox(width:20),Text("From Camera",style: TextStyle(fontSize: 20))],)
),
     )
     

    ],)

  );
});
  }
}


