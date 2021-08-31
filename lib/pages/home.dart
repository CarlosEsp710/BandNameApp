import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:bands_name/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Interpol', votes: 5),
    Band(id: '2', name: 'Metallica', votes: 4),
    Band(id: '3', name: 'Pearl Jam', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 7),
    Band(id: '5', name: 'The Killers', votes: 5)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Band Names", style: TextStyle(color: Colors.black87)),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  ListTile _bandTile(Band band) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(band.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      title: Text(band.name),
      trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
      onTap: () {
        // ignore: avoid_print
        print(band.name);
      },
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    // if (!Platform.isIOS) {
    //   return
    // }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New band name:"),
          content: TextField(controller: textController),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addBandToList(textController.text),
            )
          ],
        );
      },
    );

    // showCupertinoDialog(
    //     context: context,
    //     builder: (_) {
    //       return CupertinoAlertDialog(
    //         title: const Text('New band name:'),
    //         content: CupertinoTextField(controller: textController),
    //         actions: <Widget>[
    //           CupertinoDialogAction(
    //             isDefaultAction: true,
    //             child: const Text('Add'),
    //             onPressed: () => addBandToList(textController.text),
    //           ),
    //           CupertinoDialogAction(
    //             isDestructiveAction: true,
    //             child: const Text('Dismiss'),
    //             onPressed: () => Navigator.pop(context),
    //           )
    //         ],
    //       );
    //     });
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
