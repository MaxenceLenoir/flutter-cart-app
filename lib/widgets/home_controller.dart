import 'package:flutter/material.dart';
import 'package:flutter_cart_list/models/databaseClient.dart';
import '../models/item.dart';
import '../widgets/donnees_vides.dart';
import './details.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  String newList;
  List<Item> items;

  @override
  void initState() {
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () => ajouter(null),
            child: Text(
              'Ajouter',
              style: TextStyle(color: Colors.white)))
        ]
      ),
      body: (items == null || items.length == 0)
      ? DonnesVides()
      : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          Item item = items[i];
          return ListTile(
            title: Text(item.nom),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                DatabaseClient().delete(item.id, 'items').then((int) {
                  recuperer();
                });
              },
            ),
            leading: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => ajouter(item),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext buildContext){
                  return ItemDetail(item);
                }
              ));
            },
          );
        },
      )
    );
  }

  Future<Null> ajouter(Item item) async {
    await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext buildContext){
        return AlertDialog(
          title: Text('Ajouter une liste de  souhaits'),
          content: TextField(
            decoration: InputDecoration(
              labelText: 'liste:',
              hintText: (item == null) ? 'ex: mes prochains jeux videos' : item.nom
            ),
            onChanged: (String str) {
              newList = str;
            },
          ),
          actions: [
            TextButton(
              onPressed: (() => Navigator.pop(buildContext)),
              child: Text('Annuler')
            ),
            TextButton(
              onPressed: (() {
                if (newList != null) {
                  if (item == null) {
                    item = new Item();
                    Map<String, dynamic> map = {'nom': newList};
                    item.fromMap(map);
                  } else {
                    item.nom = newList;
                  }
                  DatabaseClient().upsertItem(item).then((i) => recuperer());
                  newList = null;
                }
                Navigator.pop(buildContext);
              }),
              child: Text('Valider', style: TextStyle(color: Colors.green))
            ),
          ],
        );
      }
    );
  }

  void recuperer() {
    DatabaseClient().allItem().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}