import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  File _image;
  String _uploadedFileURL;
  List<File> _files;
  List<String> _extension = ['pdf','doc'];

  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  final Firestore db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String name, tribeName,talent,area;
  int c=1;
  String _uploadedURL;

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Tribal talent'), backgroundColor: Colors.green,
          actions: <Widget>[
            Builder(builder: (BuildContext context) {
              return FlatButton(
                child: const Text('Sign out'),
                textColor: Theme.of(context).buttonColor,
                onPressed: () async {
                  final FirebaseUser user = await _auth.currentUser();
                  if (user == null) {
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      content: Text('No one has signed in.'),
                    ));
                    return;
                  }
                  _signOut(context);
                  final String uid = user.uid;
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(uid + ' has successfully signed out.'),
                  ));
                },
              );

            })
          ],
        ),
        backgroundColor: Colors.white70,
        body: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Name:'
                    ),
                    //validator: (input) => !input.contains('@') ? 'Not a valid Email' : null,
                    onSaved: (input) => name = input,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Tribe Name:'
                    ),
                   // validator: (input) => input.length < 8 ? 'You need at least 8 characters' : null,
                    onSaved: (input) => tribeName = input,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Talent:'
                    ),
                   // validator: (input) => !input.contains('@') ? 'Not a valid Email' : null,
                    onSaved: (input) => talent = input,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Area :'
                    ),
                    //validator: (input) => !input.contains('@') ? 'Not a valid Email' : null,
                    onSaved: (input) => area = input,
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: _submit,
                      child: Text('submit'),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:RaisedButton(
                          child: Text('Choose Image'),
                          onPressed: chooseImage,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child :RaisedButton(
                          child: Text('upload Image'),
                          onPressed: uploadImage,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text('Choose Files'),
                          onPressed: chooseFile,
                        ),
                      ),
                      new Padding(
                          padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text('Upload Files'),
                          onPressed: uploadFile,
                        )
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pop(context);
  }

  Future chooseImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future chooseFile() async{
    _files = await FilePicker.getMultiFile(
        type: FileType.custom, allowedExtensions: _extension);
  }

  Future  uploadFile() async{
    List <String> paths = new List();
    for(File file in _files) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("${Path.basename(file.path)}}");
      StorageUploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.onComplete;
      print('File uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedURL = fileURL;
        });
      });
    }
    paths.add(_uploadedURL);
  db.collection("tribal_talents").document(name).updateData({"docs":FieldValue.arrayUnion(paths)});
    paths.clear();
}

  Future uploadImage() async {

    List images = new List();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("${Path.basename(_image.path)}}");
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('Image Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
    images.add(_uploadedFileURL);

    db.collection("tribal_talents").document(name).setData()
    db.collection("tribal_talents").document(name).updateData({"images":FieldValue.arrayUnion(images)});
    images.clear();
  }


  void _submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
     db.collection("tribal_talents").document(name).setData({
       "name":name,
       "area":area,
       "talent":talent,
       "tribe":tribeName,
     });

    }
  }
}