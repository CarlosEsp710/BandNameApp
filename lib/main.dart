import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bands_name/pages/home.dart';
import 'package:bands_name/pages/status.dart';
import 'package:bands_name/services/socket_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'status',
        routes: {
          'home': (_) => const HomePage(),
          'status': (_) => const StatusPage()
        },
      ),
    );
  }
}
