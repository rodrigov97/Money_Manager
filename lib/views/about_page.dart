import 'package:flutter/material.dart';
import 'package:money_manager/widgets/custom_drawer.dart';
//Habilitar 'url_launcher' caso tenha a versão do Flutter SDK 1.9.1+hotfix.4
//import 'package:url_launcher/url_launcher.dart';

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
      body: _buildSobre(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Sobre o projeto'),
    );
  }

  Widget _buildSobre() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Container(
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400],
                  blurRadius: 10.0,
                  spreadRadius: 0.1,
                  offset: Offset(
                    5.0,
                    5.0,
                  ),
                )
              ],
            ),
            child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Sobre\n',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                    Text(
                        'Projeto realizado para a aula de Programação para Dispositivos Móveis 3º Semestre de Análise e Dsenvolvimento de Sistemas.\n',
                        style: TextStyle(fontWeight: FontWeight.w400)),
                    InkWell(
                      child: Text('Professor: Kleber Andrade\nGithub: https://github.com/kleberandrade\n',
                          style: TextStyle(fontWeight: FontWeight.w400)),
                          //onTap: _gitKleber(),
                    ),
                    Text('Desenvolvido pelos alunos:\n',
                        style: TextStyle(fontWeight: FontWeight.w400)),
                    InkWell(
                      child: Text('Rodrigo Ventura\nGithub: https://github.com/rodrigov97\n',
                          style: TextStyle(fontWeight: FontWeight.w400)),
                          //onTap: _gitRodrigo(),
                    ),
                    InkWell(
                      child: Text('Cesar Gabriel\nGithub: https://github.com/Username',
                          style: TextStyle(fontWeight: FontWeight.w400)),
                          //onTap: _gitCesar(),
                    )
                  ],
                ))));
  }

  //Habilitar 'url_launcher' caso tenha a versão do Flutter SDK 1.9.1+hotfix.4
  // _gitKleber() async {
  // const url = 'https://github.com/kleberandrade';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _gitRodrigo() async {
  // const url = 'https://github.com/rodrigov97';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _gitCesar() async {
  // const url = 'https://github.com/'Username';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
