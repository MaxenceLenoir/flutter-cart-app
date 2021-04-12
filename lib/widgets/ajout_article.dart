import 'dart:io';

import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/databaseClient.dart';
import 'package:image_picker/image_picker.dart';

class Ajout extends StatefulWidget {
  int id;
  Ajout(int id){
    this.id = id;
  }

  @override
  _AjoutState createState() => _AjoutState();
}

class _AjoutState extends State<Ajout> {

  String image;

  String nom;
  String magasin;
  String prix;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter'),
        actions: [
          TextButton(
            onPressed: ajouter,
            child: Text('valider', style: TextStyle(color: Colors.white)))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
          Text('Article à ajouter', textScaleFactor: 1.4, style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (image == null)
                ? Image.asset('images/profile-pic.jpeg')
                : Image.file(File(image)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(onPressed: (() => getImage(ImageSource.camera)),icon: Icon(Icons.camera_enhance)),
                    IconButton(onPressed: (() => getImage(ImageSource.gallery)), icon: Icon(Icons.photo_library)),
                  ],
                ),
                textField(TypeTextField.nom, "Nom de l'article"),
                textField(TypeTextField.prix, "Prix"),
                textField(TypeTextField.magasin, "Magasin"),
              ],
            )
          )
          ]
        )
      )
    );
  }

  TextField textField(TypeTextField type, String label) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: (String string) {
        switch (type) {
          case TypeTextField.nom:
            nom = string;
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
      }
    );
  }

  void ajouter() {
    if (nom != null) {
      Map<String, dynamic> map = { 'nom': nom, 'item': widget.id };
      if (magasin != null) {
        map['magasin'] = magasin;
      }
      if (prix != null) {
        map['prix'] = prix;
      }
      if (image != null) {
        map['image'] = image;
      }
      Article article = Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        image = null;
        nom = null;
        magasin = null;
        prix = null;
        Navigator.pop(context);
      });
    }
  }

  Future getImage(ImageSource source) async {
    final newImage = await ImagePicker().getImage(source: source);
    setState(() {
      image = newImage.path;
    });
  }
}

enum TypeTextField {nom, prix, magasin}
