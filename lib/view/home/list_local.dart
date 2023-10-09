import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListLocal extends StatefulWidget {
  const ListLocal({Key? key}) : super(key: key);

  @override
  State<ListLocal> createState() => _ListLocalState();
}

class _ListLocalState extends State<ListLocal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.black,
      title: Padding(
        padding: const EdgeInsets.only(left: 120),
        child: Text ('SD PM CAVEIRA',
            style: TextStyle(
              fontSize: 14,
              color: Colors.yellowAccent,
            )
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.account_circle_rounded,
            color: Colors.yellowAccent,
          ),
          onPressed: () {
            // do something
          },
        )
      ],
    ),
    );
  }
}
