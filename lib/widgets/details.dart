import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cart_list/models/databaseClient.dart';
import '../models/item.dart';
import '../models/article.dart';
import './donnees_vides.dart';
import './ajout_article.dart';

class ItemDetail extends StatefulWidget {
  Item item;

  ItemDetail(Item item) {
    this.item = item;
  }

  @override
  _ItemDetailState createState() => new _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<Article> articles;

  @override
  void initState() {
    super.initState();
    DatabaseClient().allArticles(widget.item.id).then((liste) {
      setState((){
        articles = liste;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.nom),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return Ajout(widget.item.id);
              })).then((value) {
                    DatabaseClient().allArticles(widget.item.id).then((liste) {
                    setState((){
                      articles = liste;
                    });
                  });
              });
            },
            child: Text(
              'Ájouter',
              style: TextStyle(color: Colors.white)
            )
          ),
        ],
      ),
      body: (articles == null || articles.length == 0)
      ? DonnesVides()
      : GridView.builder(
        itemCount: articles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, i){
          Article article = articles[i];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(article.nom),
                (article.image == null)
                  ? Image.asset('images/profile-pic.jpeg')
                  : Image.file(File(article.image)),
                  Text((article.prix == null) ? 'Aucun prix renseigné' : 'Prix : ${article.prix}'),
                  Text((article.magasin == null) ? 'Aucun magasin renseigné' : 'Magasin : ${article.prix}'),
              ],
            )
          );
        })
    );
  }
}