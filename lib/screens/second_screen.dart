import 'package:flutter/material.dart';
import 'package:lists/dbs/task_db.dart';
import 'package:lists/dbs/tasks.dart';
import 'package:share/share.dart';

// ignore: must_be_immutable, camel_case_types
class secondScreen extends StatefulWidget {
  String txt;
  secondScreen(String str) {
    txt = str;
  }

  @override
  _secondScreenState createState() => _secondScreenState();
}

// ignore: camel_case_types
class _secondScreenState extends State<secondScreen>
    with WidgetsBindingObserver {
  final tfController = TextEditingController();
  final scrollController = ScrollController();
  Future<List<Tasks>> futureTasks;
  List<Tasks> tasks;
  bool firstTimeDataLoad = true;
  Set<String> nameSet = Set();
  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    taskDBProvider.db.setName('sj_' + widget.txt);
    futureTasks = taskDBProvider.db.getAllNames();
    setState(() {});
  }

  @override
  void dispose() {
    tfController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    taskDBProvider.db.finish();
    super.dispose();
  }

  _builder(int ind) {
    TextStyle ts;
    if (tasks[ind].striked == 1) {
      ts = new TextStyle(
          fontSize: 18.0,
          color: Color(0xff6600ff),
          decoration: TextDecoration.lineThrough);
    } else {
      ts = new TextStyle(fontSize: 18.0, color: Color(0xff6600ff));
    }
    return InkWell(
      onTap: () async {
        tasks[ind].striked = 1 - tasks[ind].striked;
        setState(() {});
        await taskDBProvider.db.changeState(tasks[ind]);
      },
      onLongPress: () {
        removeItem(tasks[ind]);
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        padding: EdgeInsets.all(10.0),
        color: Color(0xa0262626),
        child: (Text(
          tasks[ind].task_name,
          style: ts,
        )),
      ),
    );
  }

  removeItem(Tasks task) async {
    nameSet.remove(task.striked);
    tasks.remove(task);
    setState(() {});
    await taskDBProvider.db.delete(task.task_name);
  }

  shareList() {
    if (nameSet.isEmpty) return;
    // final RenderBox box = this.context.findRenderObject();
    String txt = widget.txt + " :-\n\n";
    for (String s in nameSet) {
      txt += s + '\n';
    }
    Share.share(
      txt,
      subject: widget.txt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xff6600ff)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.txt,
              style: TextStyle(color: Color(0xff6600ff)),
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: Color(0xff6600ff),
              ),
              onPressed: () {
                shareList();
              },
            )
          ],
        ),
        backgroundColor: Color(0xfa1a1a1a),
      ),
      body: Material(
        color: Colors.black,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(5.0),
            height: 50.0,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xff6600ff)),
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    alignment: Alignment.centerLeft,
                    height: 30.0,
                    width: getTFWidth(),
                    child: TextField(
                      cursorColor: Color(0xff6600ff),
                      controller: tfController,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff6600ff))),
                          hintText: 'Enter Something',
                          hintStyle: TextStyle(color: Color(0x806600ff))),
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xff6600ff)),
                    ),
                  ),
                ),
                FlatButton(
                  color: Color(0x906600ff),
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.black87),
                  ),
                  splashColor: Color(0xff6600ff),
                  onPressed: () {
                    addItem();
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: FutureBuilder(
                future: futureTasks,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (firstTimeDataLoad) {
                    tasks = snapshot.data;
                    firstTimeDataLoad = false;
                    for (Tasks tt in tasks) {
                      nameSet.add(tt.task_name);
                    }
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    itemCount: tasks.length,
                    itemBuilder: (context, ind) {
                      return _builder(ind);
                    },
                  );
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  addItem() async {
    String txt = tfController.text.trim();
    if (txt == "") {
      _scaffold.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('You must enter something'),
      ));
      return;
    } else if (nameSet.contains(txt)) {
      _scaffold.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('Item already present'),
      ));
      return;
    }
    tfController.text = "";
    Tasks task = Tasks(txt);
    tasks.add(task);
    nameSet.add(task.task_name);
    setState(() {});
    await taskDBProvider.db.insert(task);
  }

  getTFWidth() {
    double width = MediaQuery.of(this.context).size.width;
    return width - 150;
  }
}
