import 'package:flutter/material.dart';
import 'package:money_manager/widgets/custom_drawer.dart';

class AboutPage extends StatefulWidget {
  static const String routeName = '/about';
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Sobre o projeto'),
    );
  }

  Widget _buildBody() {
    return Center(child: Text('Em construção!'));
  }
}
