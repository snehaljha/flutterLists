import 'package:flutter/material.dart';
import 'package:lists/screens/second_screen.dart';

class firstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lists",
          style: TextStyle(
            color: Color(0xFFC9C9C9)
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Material(

        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: (){goTo('alphabets', context);},
              child:
            Container(
              padding: EdgeInsets.all(30.0),
              color: Color(0xff8b8b8b),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Alphabets",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

            )),
            InkWell(
              onTap: (){goTo('numbers', context);},
              child:
            Container(
              padding: EdgeInsets.all(30.0),
              color: Color(0xff8b8b8b),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Numbers",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            )
            )
          ],
        ),
      ),
    );
  }

}

goTo(String str, context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => secondScreen(str)));
}