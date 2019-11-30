import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/widgets/custom_drawer.dart';
import 'package:money_manager/widgets/ganhos_dialog.dart';
import 'package:money_manager/widgets/gastos_dialog.dart';
import 'package:money_manager/helpers/helper.dart';
import 'package:money_manager/models/dados.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Gastos gasto = Gastos();
  GastosHelper _helper = GastosHelper();
  List<Gastos> _gastosListGanhos = [];
  List<Gastos> _gastosListGastos = [];
  List<Gastos> _gastosListTodos = [];

  var _colorTotal;
  String _totalGasto;
  String _totalGanho;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildMainScreen(),
    );
  }

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    //_totalController.text = _totalGasto();
    _helper.getGanhos().then((listGanho) {
      setState(() {
        _gastosListGanhos = listGanho;
        _loading = false;
      });
    });
    _helper.getGastos().then((listGasto) {
      setState(() {
        _gastosListGastos = listGasto;
        _loading = false;
      });
    });
    _helper.getTotalGanho().then((listTotalGanho) {
      setState(() {
        if (listTotalGanho == null) {
          _totalGanho = '0';
        } else {
          _totalGanho = listTotalGanho[0]['TotalGanho'].toString();
        }
        _loading = false;
      });
    });
    _helper.getTotalGasto().then((listTotalGasto) {
      setState(() {
        if (listTotalGasto == null) {
          _totalGasto = '0';
        } else {
          _totalGasto = listTotalGasto[0]['TotalGasto'].toString();
        }
        _loading = false;
      });
    });
    _helper.getAll().then((listTodos) {
      setState(() {
        _gastosListTodos = listTodos;
        _loading = false;
      });
    });
  }

  Widget _buildAppBar() {
    return AppBar(title: Text('Home'));
  }

  _refresh() {
    _helper.getTotalGanho().then((listTotalGanho) {
      setState(() {
        if (listTotalGanho == null) {
          _totalGanho = '0';
        } else {
          _totalGanho = listTotalGanho[0]['TotalGanho'].toString();
        }
        _loading = false;
      });
    });
    _helper.getTotalGasto().then((listTotalGasto) {
      setState(() {
        if (listTotalGasto == null) {
          _totalGasto = '0';
        } else {
          _totalGasto = listTotalGasto[0]['TotalGasto'].toString();
        }
        _loading = false;
      });
    });
  }

  Widget _buildMainScreen() {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
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
                child: TabBar(
                    indicator: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99.0)),
                      color: Colors.transparent,
                    ),
                    labelColor: Colors.black,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelColor: Colors.black38,
                    tabs: [
                      Tab(
                        child: Text('Gastos'),
                      ),
                      Tab(
                        child: Text('Ganhos'),
                      ),
                      Tab(
                        child: Text('Histórico'),
                      )
                    ]),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: _buildTotal(),
                  ),
                  Container(
                    child: Text('Em construção'),
                  ),
                  Container(
                    child: Text('Em construção'),
                  )
                ],
              ),
            ),
          ],
        )));
  }

  //TOTAL
  Widget _buildTotal() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 300,
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
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: 40, right: 40, left: 20, bottom: 20),
                    child: Icon(_iconTotal(),
                        color: Colors.green[800], size: 120)),
                Text("R\$  " +_total().toString().replaceAll('.0', '.00')),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 200, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(_iconTotalGasto(), color: Colors.red[400]),
                          Padding(padding:EdgeInsets.only(left: 15)),
                          Text("R\$  " + _totalGasto.replaceAll('.0', '.00'))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(_iconTotalGanho(), color: Colors.green[400]),
                          Padding(padding:EdgeInsets.only(left: 15)),
                          Text("R\$  " + _totalGanho.replaceAll('.0', '.00'))
                        ],
                      )
                    ],
                  ),
                )
              ],
            )));
  }

  IconData _iconTotal() {
    return FontAwesomeIcons.moneyBillWave;
  }

    IconData _iconTotalGasto() {
    return FontAwesomeIcons.arrowCircleDown;
  }

    IconData _iconTotalGanho() {
    return FontAwesomeIcons.arrowCircleUp;
  }

  _total() {
    var gastos;
    var ganhos;
    var total;
    if (double.parse(_totalGasto) == null) {
      ganhos = double.parse(_totalGanho);
      total = ganhos;
      return total;
    } else if (double.parse(_totalGanho) == null) {
      gastos = double.parse(_totalGasto);
      total = 0 - gastos;
      return total;
    } else {
      ganhos = double.parse(_totalGanho);
      gastos = double.parse(_totalGasto);
      total = ganhos - gastos;
    }
    if (total <= 10) {
      _colorTotal = Colors.red;
    } else {
      _colorTotal = Colors.grey[900];
    }
    return total;
  }

  //HISTÓRICO
  Widget _buildHistoricoList() {
    if (_gastosListTodos.isEmpty) {
      return Center(
        child: _loading ? CircularProgressIndicator() : Text("Sem tarefas!"),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.white,
        ),
        itemBuilder: _buildHistoricoItem,
        itemCount: _gastosListTodos.length,
      );
    }
  }

  Widget _buildHistoricoItem(BuildContext context, int index) {
    final gasto = _gastosListTodos[index];
    var color;
    var sinal;
    if (gasto.tipo == 'Ganhos') {
      color = Colors.green[400];
      sinal = '+ ';
    } else if (gasto.tipo == 'Gastos') {
      color = Colors.red[400];
      sinal = '- ';
    }
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(gasto.nome, style: TextStyle(fontSize: 20)),
        ],
      ),
      subtitle: Text(sinal + gasto.valor.toString(),
          style: TextStyle(color: color, fontSize: 18)),
    );
  }
}
