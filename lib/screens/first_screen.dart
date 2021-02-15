import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lists/dbs/main_db.dart';
import 'package:lists/dbs/table_names.dart';
import 'package:lists/screens/second_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class firstScreen extends StatefulWidget {
  @override
  _firstScreenState createState() => _firstScreenState();
}

class _firstScreenState extends State<firstScreen> {
  @override
  void dispose() {
    mainDBProvider.db.finish();
  }

  final _scaffold = GlobalKey<ScaffoldState>();
  Future<List<table_names>> tables;
  List<table_names> all_tables;
  bool first_time = true;
  Set<String> namesSet = Set();

  @override
  void initState() {
    super.initState();
    _updateNames();
  }

  _updateNames() {
    tables = mainDBProvider.db.getAllNames();
    setState(() {});
  }

  _builder(table_names table) {
    //(Done)add db elements in list
    return InkWell(
      onTap: () {
        goTo(table.name);
      },
      splashColor: Colors.black,
      highlightColor: Color(0xff6600ff),
      onLongPress: () {
        showDialog(
            context: this.context,
            builder: (BuildContext context) => deleteDialog(table));
      },
      child: Container(
        color: Color(0xa0262626),
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(10.0),
        child: Text(
          table.name,
          style: TextStyle(fontSize: 18.0, color: Color(0xff6600ff)),
        ),
      ),
    );
  }

  remove_table(table_names table) async {
    setState(() {
      all_tables.remove(table);
      namesSet.remove(table.name);
    });
    await deleteDB('sj_' + table.name + '.db');
    await mainDBProvider.db.delete(table.name);
  }

  deleteDB(String db_name) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File(join(dir.path, db_name));
    file.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text(
          "Lists",
          style: TextStyle(color: Color(0xfa6600ff)),
        ),
        backgroundColor: Color(0xfa1a1a1a),
      ),
      body: Material(
        color: Colors.black,
        child: Container(
          child: FutureBuilder(
            future: tables,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (first_time) {
                first_time = false;
                all_tables = snapshot.data;
                for (table_names nt in all_tables) {
                  namesSet.add(nt.name);
                }
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                itemCount: all_tables.length,
                itemBuilder: (BuildContext context, int index) {
                  return _builder(all_tables[index]);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 30.0,
        ),
        backgroundColor: Color(0xfa6600ff),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => _buildAdderDialog(context));
        },
      ),
    );
  }

  _buildAdderDialog(context) {
    // (Done)builds dialog
    final dialogController = TextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 1,
      title: Text(
        'New List',
        style: TextStyle(color: Color(0xff6600ff)),
      ),
      backgroundColor: Color(0xa0262626),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              cursorColor: Color(0xff6600ff),
              controller: dialogController,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      // borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: UnderlineInputBorder(
                      // borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xff6600ff))),
                  border: UnderlineInputBorder(
                      // borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black87)),
                  hintText: 'New List Name',
                  hintStyle: TextStyle(color: Color(0x606600ff))),
              style: TextStyle(fontSize: 15, color: Color(0xff6600ff)),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Text(
                      'Discard',
                      style: TextStyle(color: Color(0xff6600ff)),
                    ),
                    onPressed: () {
                      // dialogController.dispose();
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Add',
                      style: TextStyle(color: Color(0xff6600ff)),
                    ),
                    onPressed: () {
                      String txt = dialogController.text.trim();
                      if (txt == "") {
                        _scaffold.currentState.showSnackBar(SnackBar(
                          duration: const Duration(milliseconds: 500),
                          content: Text('List name cannot be empty'),
                        ));
                        // Future.delayed(Duration(seconds: 1), () {
                        //   _scaffold.currentState.hideCurrentSnackBar();
                        // });
                      } else if (namesSet.contains(txt)) {
                        _scaffold.currentState.showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text('List already exist'),
                        ));
                      } else {
                        newItem(txt, context);
                      }
                      // dialogController.dispose();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  deleteDialog(table_names table) {
    TextEditingController renameController = TextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 1,
      title: Text(
        table.name,
        style: TextStyle(color: Color(0xff6600ff)),
      ),
      backgroundColor: Color(0xa0262626),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Do you want to delete?',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xff6600ff),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xff6600ff)),
                    ),
                    onPressed: () {
                      Navigator.of(this.context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Color(0xff6600ff)),
                    ),
                    onPressed: () {
                      remove_table(table);
                      Navigator.of(this.context).pop();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  newItem(String txt, context) async {
    //(db left)adds item in list
    // bool cond = await mainDBProvider.db.isPresent(txt);
    // if (cond) {
    //   // _scaffold.currentState.showSnackBar(SnackBar(
    //   //   content: Text('list already exist'),
    //   // ));
    //   // Future.delayed(Duration(seconds: 1), () {
    //   //   _scaffold.currentState.hideCurrentSnackBar();
    //   // });
    //   return;
    // }
    table_names new_table = table_names(txt);
    namesSet.add(txt);
    setState(() {
      all_tables.add(new_table);
    });
    await mainDBProvider.db.insert(new_table);
  }

  goTo(String str) {
    //(Done)move to second screen
    Navigator.of(this.context)
        .push(MaterialPageRoute(builder: (context) => secondScreen(str)));
  }
}
