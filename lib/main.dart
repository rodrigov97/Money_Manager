import 'package:flutter/material.dart';
import 'package:money_manager/themes/theme.dart';
import 'package:money_manager/views/about_page.dart';
import 'package:money_manager/views/ganhos_page.dart';
import 'package:money_manager/views/home_page.dart';
import 'package:money_manager/views/gastos_page.dart';
import 'package:money_manager/views/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Gastos',
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        HomePage.routeName: (context) => new HomePage(),
        AboutPage.routeName: (context) => new AboutPage(),
        GastosPage.routeName: (context) => new GastosPage(),
        GanhosPage.routeName: (context) => new GanhosPage(),
      },
      home: RootPage(),
    );
  }
}
