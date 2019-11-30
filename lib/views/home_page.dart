import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/Api/money.dart';
import 'package:money_manager/widgets/custom_drawer.dart';
import 'package:money_manager/helpers/helper.dart';
import 'package:money_manager/models/dados.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _realController = TextEditingController();
  final _dolarController = TextEditingController();
  final _euroController = TextEditingController();
  final _bitcoinController = TextEditingController();
  Gastos gasto = Gastos();
  GastosHistorico gastoHistorico = GastosHistorico();
  GastosHelper _helper = GastosHelper();
  List<Gastos> _gastosListGanhos = [];
  List<Gastos> _gastosListGastos = [];
  List<Gastos> _gastosListTodos = [];
  List<GastosHistorico> _gastoHistorico = [];
  Map _moneyData;

  var _colorTotal;
  String _totalGasto;
  String _totalGanho;

  var dollarBuy;
  var euroBuy;
  var bitcoinBuy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildMainScreen(),
      resizeToAvoidBottomInset: false,
    );
  }

  bool _loading = true;

  @override
  void initState() {
    super.initState();
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
    _helper.getAllHistorico().then((listTodos) {
      setState(() {
        _gastoHistorico = listTodos;
        _loading = false;
      });
    });
    getData().then((listTodos) {
      setState(() {
        _moneyData = listTodos;

        dollarBuy =
            _moneyData["results"]["currencies"]["USD"]["buy"].toString();
        euroBuy = _moneyData["results"]["currencies"]["EUR"]["buy"].toString();
        bitcoinBuy =
            _moneyData["results"]["currencies"]["BTC"]["buy"].toString();
        _loading = false;
      });
    });
  }

  Widget _buildAppBar() {
    return AppBar(
        title: Text('Home', style: TextStyle(fontWeight: FontWeight.w300)));
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
                        child: Text('Overview',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                      ),
                      Tab(
                        child: Text('Ganhos',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                      ),
                      Tab(
                        child: Text('Histórico',
                            style: TextStyle(fontWeight: FontWeight.w300)),
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
                    child: _buildTab2(),
                  ),
                  Container(
                    child: Text('Calma'),
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
                        top: 130, right: 40, left: 20, bottom: 20),
                    child:
                        Icon(_iconTotal(), color: Colors.green[500], size: 90)),
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(
                  "R\$  " + _total().toString().replaceAll('.0', '.00'),
                  style: TextStyle(
                      color: _colorTotal,
                      fontSize: 40,
                      fontWeight: FontWeight.w300),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 100, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(_iconTotalGasto(), color: Colors.red[400]),
                          Padding(padding: EdgeInsets.only(left: 15)),
                          Text("R\$  " + _totalGasto.replaceAll('.0', '.00'),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(_iconTotalGanho(), color: Colors.green[400]),
                          Padding(padding: EdgeInsets.only(left: 15)),
                          Text("R\$  " + _totalGanho.replaceAll('.0', '.00'),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300))
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

  //TAB 2
  Widget _buildTab2() {
    return Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 50, right: 50),
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
            child: Padding(
                padding: EdgeInsets.all(20), child: _buildFormConversao())));
  }

  Widget _buildFormConversao() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 30)),
            Text('CONVERSOR',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30)),
            Padding(padding: EdgeInsets.only(top: 20)),
            TextFormField(
              controller: _realController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Real(R\$)",
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            TextFormField(
              controller: _dolarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Dolar(US\$)",
                  labelStyle: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w300)),
              enabled: false,
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            TextFormField(
              controller: _euroController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Euro(€)",
                  labelStyle: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w300)),
              enabled: false,
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            TextFormField(
              controller: _bitcoinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Bitcoin",
                  labelStyle: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w300)),
              enabled: false,
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            RaisedButton(
              child: Text("CONVERTER",
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
              onPressed: _converterReal,
            )
          ],
        )));
  }

  void _converterReal() {
    var valorReal = double.parse(_realController.text);
    _dolarController.text =
        (valorReal / double.parse(dollarBuy)).toStringAsFixed(2);
    _euroController.text =
        (valorReal / double.parse(euroBuy)).toStringAsFixed(2);
    _bitcoinController.text =
        (valorReal / double.parse(bitcoinBuy)).toStringAsFixed(10);
  }
}
