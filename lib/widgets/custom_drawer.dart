import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/views/about_page.dart';
import 'package:money_manager/views/gastos_page.dart';
import 'package:money_manager/views/home_page.dart';
import 'package:money_manager/views/ganhos_page.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          children: <Widget>[
            _showHeader(),
            ListTile(
              leading: Icon(_iconHome(), size: 24, color: Colors.blue[900]),
              title: Text('Home',
                  style: TextStyle(color: Colors.grey[800], fontSize: 20,fontWeight: FontWeight.w300)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              },
            ),
            ListTile(
              leading: Icon(_iconGasto(), size: 24, color: Colors.red[600]),
              title: Text('Gastos',
                  style: TextStyle(color: Colors.grey[800], fontSize: 20,fontWeight: FontWeight.w300)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushReplacementNamed(GastosPage.routeName);
              },
            ),
            ListTile(
              leading: Icon(_iconGanho(), size: 24, color: Colors.green[600]),
              title: Text('Ganhos',
                  style: TextStyle(color: Colors.grey[800], fontSize: 20,fontWeight: FontWeight.w300)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushReplacementNamed(GanhosPage.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(_iconSobre(), size: 24, color: Colors.yellow[900]),
              title: Text('Sobre o projeto',
                  style: TextStyle(color: Colors.grey[800], fontSize: 20,fontWeight: FontWeight.w300)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed(AboutPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _showHeader() {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        child: Column(
          children: <Widget>[
            Icon(
              _iconHeader(),
              size: 50,
              color: Colors.grey[900],
            ),
          ],
        ),
      ),
    ));
  }

  IconData _iconHeader() {
    return FontAwesomeIcons.wallet;
  }

  IconData _iconHome() {
    return FontAwesomeIcons.home;
  }

  IconData _iconGasto() {
    return FontAwesomeIcons.minusCircle;
  }

  IconData _iconGanho() {
    return FontAwesomeIcons.plusCircle;
  }

  IconData _iconSobre() {
    return FontAwesomeIcons.infoCircle;
  }
}
