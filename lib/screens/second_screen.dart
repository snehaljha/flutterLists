import 'package:flutter/material.dart';

var alphabets = [
  'Alpha',
  'bravo',
  'charlie',
  'delta',
  'echo',
  'foxtrot',
  'golf',
  'hotel',
  'india',
  'juliet'
];
var numbers = [
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten'
];

class secondScreen extends StatefulWidget {
  String list_name = "alphabet";
  List list_items;

  secondScreen(String str) {
    list_name = str;
    list_items = getItems(list_name);
  }

  @override
  _secondScreenState createState() => _secondScreenState();
}

class _secondScreenState extends State<secondScreen> {
  final tfController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void dispose() {
    tfController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.list_name,
          style: TextStyle(color: Color(0xFFC9C9C9)),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Material(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50.0,
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30.0,
                    width: getTFWidth(context),
                    child: TextField(
                      controller: tfController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Something',
                      ),
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add'),
                    splashColor: Colors.white30,
                    onPressed: () {
                      addItem(widget.list_items, tfController);
                      setState(() {});
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent + 85,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.list_items,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

getItems(String list_name) {
  if (list_name == 'alphabets') return generateItems(alphabets);
  return generateItems(numbers);
}

generateItems(List list) {
  List items = List<Widget>();
  for (String name in list) {
    Widget widget = new Container(
      padding: EdgeInsets.all(30.0),
      margin: EdgeInsets.only(bottom: 10.0),
      alignment: Alignment.centerLeft,
      color: Color(0xff8b8b8b),
      child: Text(
        name,
        style: TextStyle(color: Colors.white70, fontSize: 15.0),
      ),
    );
    items.add(widget);
  }
  return items;
}

getTFWidth(context) {
  double w = MediaQuery.of(context).size.width;
  return w - 100;
}

addItem(list_items, tfController) {
  Widget item = new Container(
    padding: EdgeInsets.all(30.0),
    margin: EdgeInsets.only(bottom: 10.0),
    alignment: Alignment.centerLeft,
    color: Color(0xff8b8b8b),
    child: Text(
      tfController.text,
      style: TextStyle(color: Colors.white70, fontSize: 15.0),
    ),
  );
  list_items.add(item);
}
