import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodel/home_page_modelview.dart';
import 'views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Gravador',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => HomePageViewModel(),
        child: MyHomePage(
          title: 'Gravador MarGirius',
        ),
      ),
    );
  }
}
