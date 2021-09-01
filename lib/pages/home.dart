import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:bands_name/models/band.dart';
import 'package:bands_name/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.off('active-bands');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Band Names", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.wifi_outlined, color: Colors.blue[300])
                  : Icon(Icons.wifi_off_rounded, color: Colors.red[300])),
        ],
      ),
      body: Column(children: <Widget>[
        _showGraph(),
        Expanded(
          child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, i) => _bandTile(bands[i]),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    // if (!Platform.isIOS) {
    //   return
    // }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
      ),
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
      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    // ignore: prefer_collection_literals
    Map<String, double> dataMap = Map();

    // ignore: avoid_function_literals_in_foreach_calls
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    final List<Color> colorList = [
      const Color(0XFFE3F2FD),
      const Color(0XFF90CAF9),
      const Color(0XFFFCE4EC),
      const Color(0XFFF48FB1),
      const Color(0XFFFFFDE7),
      const Color(0XFFFFF59D),
      const Color(0XFFFFEBEE),
      const Color(0XFFEF9A9A),
      const Color(0XFFE8F5E9),
      const Color(0XFFA5D6A7),
    ];

    return dataMap.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: PieChart(
                dataMap: dataMap,
                chartType: ChartType.ring,
                colorList: colorList,
                animationDuration: const Duration(microseconds: 800),
                chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true, showChartValues: true),
              ),
            ),
          )
        : const LinearProgressIndicator();
  }
}
