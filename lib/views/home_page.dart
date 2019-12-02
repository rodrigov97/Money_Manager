import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/api/money.dart';
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
  Map _moneyData = Map();

  var _colorTotal;
  var _colorPointIbovespa;
  var _colorPointNasdaq;
  var _colorVariationIbovespa;
  var _colorVariationNasdaq;
  var _colorVariationCac;
  var _colorVariationNikkei;

  IconData _iconVariationIbovespa;
  IconData _iconVariationNasdaq;
  IconData _iconVariationCac;
  IconData _iconVariationNikkei;

  String _totalGasto = '0.00';
  String _totalGanho = '0.00';

  String dollarBuy = '0.00';
  String euroBuy = '0.00';
  String bitcoinBuy = '0.00';

  String nomeIbovespa = 'NULL';
  String locationIbovespa = 'NULL';
  String pointsIbovespa = '0.00';
  String variationIbovespa = '0.00';

  String nomeNasdaq = 'NULL';
  String locationNasdaq = 'NULL';
  String pointsNasdaq = '0.00';
  String variationNasdaq = '0.00';

  String nomeCac = 'NULL';
  String locationCac = '0.00';
  String variationCac = '0.00';

  String nomeNikkei = 'NULL';
  String locationNikkei = '0.00';
  String variationNikkei = '0.00';

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
  bool _loadingStock = true;

  @override
  void initState() {
    super.initState();
    _helper.getGanhos().then((listGanho) async {
      setState(() {
        _gastosListGanhos = listGanho;
        _loading = false;
      });
    });
    _helper.getGastos().then((listGasto) async {
      setState(() {
        _gastosListGastos = listGasto;
        _loading = false;
      });
    });
    _helper.getTotalGanho().then((listTotalGanho) async {
      setState(() {
        if (listTotalGanho == null) {
          _totalGanho = '0';
        } else {
          _totalGanho = listTotalGanho[0]['TotalGanho'].toString();
        }
        _loading = false;
      });
    });
    _helper.getTotalGasto().then((listTotalGasto) async {
      setState(() {
        if (listTotalGasto == null) {
          _totalGasto = '0';
        } else {
          _totalGasto = listTotalGasto[0]['TotalGasto'].toString();
        }
        _loading = false;
      });
    });
    getData().then((listData) async {
      final _moneyData = await getData();
      if (_moneyData != null) {
        updateStock();
        _bolsaLabelVariationColor();
        _bolsaLabelIcon();
      }
    });
  }

  Future updateStock() async {
    final _moneyData = await getData();
    if (_moneyData != null) {
      setState(() {
        nomeIbovespa =
            _moneyData["results"]["stocks"]["IBOVESPA"]["name"].toString();
        locationIbovespa =
            _moneyData["results"]["stocks"]["IBOVESPA"]["location"].toString();
        pointsIbovespa =
            _moneyData["results"]["stocks"]["IBOVESPA"]["points"].toString();
        variationIbovespa =
            _moneyData["results"]["stocks"]["IBOVESPA"]["variation"].toString();

        nomeNasdaq =
            _moneyData["results"]["stocks"]["NASDAQ"]["name"].toString();
        locationNasdaq =
            _moneyData["results"]["stocks"]["NASDAQ"]["location"].toString();
        pointsNasdaq =
            _moneyData["results"]["stocks"]["NASDAQ"]["points"].toString();
        variationNasdaq =
            _moneyData["results"]["stocks"]["NASDAQ"]["variation"].toString();

        nomeCac = _moneyData["results"]["stocks"]["CAC"]["name"].toString();
        locationCac =
            _moneyData["results"]["stocks"]["CAC"]["location"].toString();
        variationCac =
            _moneyData["results"]["stocks"]["CAC"]["variation"].toString();

        nomeNikkei =
            _moneyData["results"]["stocks"]["NIKKEI"]["name"].toString();
        locationNikkei =
            _moneyData["results"]["stocks"]["NIKKEI"]["location"].toString();
        variationNikkei =
            _moneyData["results"]["stocks"]["NIKKEI"]["variation"].toString();

        _loadingStock = false;
      });
    } else {
      _loadingStock = false;
    }
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
                        child: Text('Conversor',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                      ),
                      Tab(
                        child: Text('Stock Market',
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
                    child: _buildConversor(),
                  ),
                  Container(
                    child:
                        _loadingStock ? _circularLoadingStock() : _buildBolsa(),
                  )
                ],
              ),
            ),
          ],
        )));
  }

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

  Widget _buildConversor() {
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
              validator: (text) {
                return text.isEmpty ? 'Campo Obrigatório' : null;
              },
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
              child: _loading
                  ? _circularLoading()
                  : Text("CONVERTER",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.black)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _converterReal();
                }
              },
            )
          ],
        )));
  }

  Future _converterReal() async {
    final _moneyCurrency = await getData();
    if (_moneyCurrency != null) {
      dollarBuy =
          _moneyCurrency["results"]["currencies"]["USD"]["buy"].toString();
      euroBuy =
          _moneyCurrency["results"]["currencies"]["EUR"]["buy"].toString();
      bitcoinBuy =
          _moneyCurrency["results"]["currencies"]["BTC"]["buy"].toString();
      var valorReal = double.parse(_realController.text);
      _dolarController.text =
          (valorReal / double.parse(dollarBuy)).toStringAsFixed(2);
      _euroController.text =
          (valorReal / double.parse(euroBuy)).toStringAsFixed(2);
      _bitcoinController.text =
          (valorReal / double.parse(bitcoinBuy)).toStringAsFixed(10);
    } else {
      _loading = true;
    }
  }

  Widget _buildBolsa() {
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
              padding: EdgeInsets.all(40),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    //IBOVESPA
                    Text(nomeIbovespa + ', ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 19)),
                    Text(locationIbovespa,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 15)),
                    Text('Pontos: ' + pointsIbovespa,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 17)),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          _iconVariationIbovespa,
                          size: 15,
                          color: _colorVariationIbovespa,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Text(variationIbovespa,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: _colorVariationIbovespa,
                                fontSize: 17)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                    ),

                    //NASDAQ
                    Text(nomeNasdaq + ', ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 19)),
                    Text(locationNasdaq,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 15)),
                    Text('Pontos: ' + pointsIbovespa,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 17)),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(_iconVariationNasdaq,
                            size: 15, color: _colorVariationNasdaq),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Text(variationNasdaq,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: _colorVariationNasdaq,
                                fontSize: 17)),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 60),
                    ),

                    //CAC
                    Text(nomeCac + ', ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 19)),
                    Text(locationCac,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 15)),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(_iconVariationCac,
                            size: 15, color: _colorVariationCac),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Text(variationCac,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: _colorVariationCac,
                                fontSize: 17)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                    ),

                    //NIKKEI
                    Text(nomeNikkei + ', ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 19)),
                    Text(locationNikkei,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 15)),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          _iconVariationNikkei,
                          size: 15,
                          color: _colorVariationNikkei,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Text(variationNikkei,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: _colorVariationNikkei,
                                fontSize: 17)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    RaisedButton(
                        child: _loading
                            ? _circularLoading()
                            : Text("ATUALIZAR",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black)),
                        onPressed: () {
                          updateStock();
                          _bolsaLabelVariationColor();
                          _bolsaLabelIcon();
                        }),
                  ]),
            )));
  }

  Widget _circularLoadingStock() {
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
            child: Center(
                child: Container(
              height: 15.0,
              width: 15.0,
              child: CircularProgressIndicator(),
            ))));
  }

  _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _bolsaLabelVariationColor() async {
    final _moneyData = await getData();
    if (_moneyData != null) {
      setState(() {
        if (double.parse(variationIbovespa) < 0) {
          _colorVariationIbovespa = Colors.red[400];
        } else {
          _colorVariationIbovespa = Colors.green[400];
        }
        if (double.parse(variationNasdaq) < 0) {
          _colorVariationNasdaq = Colors.red[400];
        } else {
          _colorVariationNasdaq = Colors.green[400];
        }
        if (double.parse(variationCac) < 0) {
          _colorVariationCac = Colors.red[400];
        } else {
          _colorVariationCac = Colors.green[400];
        }
        if (double.parse(variationNikkei) < 0) {
          _colorVariationNikkei = Colors.red[400];
        } else {
          _colorVariationNikkei = Colors.green[400];
        }
      });
    }
  }

  Future _bolsaLabelIcon() async {
    final _moneyData = await getData();
    if (_moneyData != null) {
      setState(() {
        if (double.parse(variationIbovespa) < 0) {
          _iconVariationIbovespa = _iconArrowDown();
        } else {
          _iconVariationIbovespa = _iconArrowUp();
        }
        if (double.parse(variationNasdaq) < 0) {
          _iconVariationNasdaq = _iconArrowDown();
        } else {
          _iconVariationNasdaq = _iconArrowUp();
        }
        if (double.parse(variationCac) < 0) {
          _iconVariationCac = _iconArrowDown();
        } else {
          _iconVariationCac = _iconArrowUp();
        }
        if (double.parse(variationNikkei) < 0) {
          _iconVariationNikkei = _iconArrowDown();
        } else {
          _iconVariationNikkei = _iconArrowUp();
        }
      });
    }
  }

  IconData _iconArrowDown() {
    return FontAwesomeIcons.arrowCircleDown;
  }

  IconData _iconArrowUp() {
    return FontAwesomeIcons.arrowCircleUp;
  }
}
