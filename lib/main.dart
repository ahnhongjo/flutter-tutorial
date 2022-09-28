// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_tuto/Object.dart';

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

  List<work> workList = <work>[
    work("work1","work1 description",DateTime(2022,9,1),2,false),
    work("work2","work2 description",DateTime(2022,9,2),2,false),
    work("work3","work3 description",DateTime(2022,9,3),3,false),
    work("work4","work4 description",DateTime(2022,9,4),1,false)];

  List<Color> colorList = <Color>[
    Colors.black26,
    Colors.lightGreenAccent,
    Colors.yellowAccent,
    Colors.red
  ];

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController importController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todo list'),
        actions: []

      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: workList.length*2,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/

            return ListTile(
            title: Text(
              workList[index].title,
              style: workList[index].isDone?
                  const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 18
                  ) :const TextStyle(fontSize: 18),

            ),
            trailing:
              Checkbox(
                  value: workList[index].isDone,
                  onChanged: (value){
                    setState(() {
                      workList[index].isDone = value!;
                    });
                  }),
            tileColor: workList[index].isDone? Colors.black26:colorList[workList[index].importance],
            onTap: () => _detailView(workList[index]),
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
                TextField(decoration: InputDecoration(hintText: "Title"),
                  controller: titleController,
                ),
                TextField(decoration: InputDecoration(hintText: "Description"),
                controller: descController,),
                TextField(
                  controller: dateController,
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
                        dateController.text = formattedDate;
                      });
                    }
                  },
                ),
                TextField(decoration: InputDecoration(hintText: "Importance"),
                controller: importController,)
              ],

            ),
            actions:<Widget>[
              TextButton(onPressed: ()=>{
                clearAddWork(),
                Navigator.pop(context,'Cancel')
              },
                  child: const Text('Cancel')),
              TextButton(onPressed: ()=>{

                Navigator.pop(context,'OK'),
                setState(() {
                  workList.add(work(titleController.text,descController.text,DateTime.parse(dateController.text),int.parse(importController.text),false));
                }),
                clearAddWork(),

              }, child: const Text('OK')),
            ]
          )
        ),
      ),
    );
  }

  void clearAddWork(){
    titleController = TextEditingController();
    descController = TextEditingController();
    dateController = TextEditingController();
    importController = TextEditingController();
  }

  void deleteTodo(work oneWork){
    setState(() {
      workList.remove(oneWork);
      Navigator.pop(context);
    });
  }

  void _detailView(work onework) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Detail view'),
              ),
              body:Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Text(onework.title,
                        textScaleFactor: 1.5,),
                      Text(onework.description,
                        textScaleFactor: 1.5,),
                      Text(DateFormat('yyyy-MM-dd').format(onework.due),
                      textScaleFactor: 1.5,),
                      IconButton(onPressed: () => deleteTodo(onework), icon: const Icon(Icons.delete))
                    ],
                  ),

              ),
          );
        },
      ),
    );
  }
}
