import 'dart:io';
import 'package:flutter_cart_list/models/item.dart';
import 'article.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseClient {
  Database _database;

  Future<Database> get database async {
    if(_database != null) {
      return _database;
    } else {
      _database = await create();
      return _database;
    }
  }

  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db');
    var bdd = await openDatabase(database_directory, version: 1, onCreate: _onCreate);
    return bdd;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE items(
      id INTEGER PRIMARY KEY,
      nom TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE articles(
      id INTEGER PRIMARY KEY,
      nom TEXT NOT NULL,
      item INTEGER,
      prix TEXT,
      magasin TEXT,
      image TEXT
    )
    ''');
  }

  // Ecriture des données
  Future<Item> ajoutItem(Item item) async {
    Database maDatabase = await database;
    item.id = await maDatabase.insert('items', item.toMap());
    return item;
  }

  Future<int> delete(int id, String table) async {
    Database maDatabase = await database;
    await maDatabase.delete('articles', where: 'item = ?', whereArgs: [id]);
    return await maDatabase.delete(table, where: 'id= ?', whereArgs: [id]);
  }

  Future<int> updateItem(Item item) async {
    Database maDatabase = await database;
    return await maDatabase.update('items', item.toMap(), where: 'id= ?', whereArgs: [item.id]);
  }

  Future<Item> upsertItem(Item item) async {
    Database maDatabase = await database;
    if (item.id == null){
      item.id = await maDatabase.insert('items', item.toMap());
    } else {
      await maDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }

  Future<Article> upsertArticle(Article article) async {
    Database maDatabase = await database;
    (article.id == null)
      ? article.id = await maDatabase.insert('articles', article.toMap())
      : await maDatabase.update('articles', article.toMap(), where: 'id = ?', whereArgs: [article.id]);
    return article;
  }

  // Lecture des données
  Future<List<Item>> allItem() async {
    Database maDatabase = await database;
    List<Map<String, dynamic>> resultats = await maDatabase.rawQuery('SELECT * FROM items');
    List<Item> items = [];
    resultats.forEach((map) {
      Item item = Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }

    Future<List<Article>> allArticles(int item) async {
    Database maDatabase = await database;
    List<Map<String, dynamic>> resultats = await maDatabase.query('articles', where: 'item = ?', whereArgs: [item]);
    List<Article> articles = [];
    resultats.forEach((map) {
      Article article = Article();
      article.fromMap(map);
      articles.add(article);
    });
    return articles;
  }
}