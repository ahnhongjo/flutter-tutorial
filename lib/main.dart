// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _person = <String>["ine","jingburger","lilpa","jururu","gosegu","viichan"];
  final _phoneNum ={
    "ine":"010-1111-1111","jingburger":"010-2222-2222","lilpa" : "010-3333-3333",
    "jururu" :"010-4444-4444","gosegu" : "010-5555-5555", "viichan" :"010-6666-6666"
  };
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  TextEditingController dateinput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _person.length*2,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          final alreadySaved = _saved.contains(_person[index]);

          return ListTile(
            title: Text(
              _person[index],
              style: _biggerFont,
            ),
            trailing: IconButton(
              // NEW from here ...
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',),
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(_person[index]);
                    } else {
                      _saved.add(_person[index]);
                    }
                  });
                }
            ),
            onTap: () => _detailView(_person[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('New schedule'),
            content: Column(
              children: <Widget>[
                TextField(decoration: InputDecoration(hintText: "Title")),
                TextField(decoration: InputDecoration(hintText: "Description")),
                TextField(
                  controller: dateinput,
                  decoration: const InputDecoration(
                    labelText: "Enter Deadline"
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101)
                    );

                    if(pickedDate !=null){
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateinput.text = formattedDate;
                      });
                    }
                  },


                ),
                TextField(decoration: InputDecoration(hintText: "Importance"))
              ],

            ),
            actions:<Widget>[
              TextButton(onPressed: ()=>{
                dateinput = TextEditingController(),
                Navigator.pop(context,'Cancel')}, child: const Text('Cancel')),
              TextButton(onPressed: ()=>Navigator.pop(context,'OK'), child: const Text('OK')),
            ]
          )
        ),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: _biggerFont,
                ),
                onTap: ()=>_detailView(pair),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _detailView(name) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final divided = <Widget>[];
          String imageName = "assets/"+name+".jpeg";

          return Scaffold(
              appBar: AppBar(
                title: const Text('Detail view'),
              ),
              body:Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Container(
                          width: 200.0,
                          height:200.0,
                          decoration: BoxDecoration(
                              shape:BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(imageName)
                              )
                          )
                      ),
                      Text(name,
                        textScaleFactor: 1.5,),
                      Text(_phoneNum[name]!,
                        textScaleFactor: 1.5,)
                    ],
                  ))
          );
        },
      ),
    );
  }
}
