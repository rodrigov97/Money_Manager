import 'package:flutter/material.dart';
import 'package:money_manager/widgets/custom_drawer.dart';
import 'package:money_manager/widgets/gastos_dialog.dart';
import 'package:money_manager/models/dados.dart';
import 'package:money_manager/helpers/helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flushbar/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GastosPage extends StatefulWidget {
  static const String routeName = '/gastos';
  @override
  _GastosPage createState() => _GastosPage();
}

class _GastosPage extends State<GastosPage> {
  List<Gastos> _gastosList = [];
  List<GastosHistorico> _gastosListHistorico = [];
  GastosHelper _helper = GastosHelper();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _helper.getGastos().then((list) {
      setState(() {
        _gastosList = list;
        _loading = false;
      });
    });
    _helper.getGastosHistorico().then((listHist) {
      setState(() {
        _gastosListHistorico = listHist;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildGastoList(),
      floatingActionButton: _floatingButton(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Gastos', style: TextStyle(fontWeight: FontWeight.w300)),
    );
  }

  Widget _floatingButton() {
    return FloatingActionButton(child: Icon(Icons.add), onPressed: _addGastos);
  }

  Widget _buildGastoList() {
    if (_gastosList.isEmpty) {
      return Center(
        child: _loading
            ? CircularProgressIndicator()
            : Icon(_iconEmptyGasto(), color: Colors.black12, size: 100),
      );
    } else {
      return Padding(
          padding: EdgeInsets.all(10),
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
            ),
            itemBuilder: _buildGastoItemSlidable,
            itemCount: _gastosList.length,
          ));
    }
  }

  IconData _iconEmptyGasto() {
    return FontAwesomeIcons.smile;
  }

  Widget _buildGastoItem(BuildContext context, int index) {
    final gasto = _gastosList[index];
    return Container(
        decoration: BoxDecoration(
            color: Colors.red[400], borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          title: Text(gasto.nome + _getGastoDate(index),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          subtitle: Text(
              'Valor: R\$  ${gasto.valor.toString().replaceAll('.0', '.00')}',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ));
  }

  _getGastoDate(index) {
    final data = _gastosList[index].data;
    DateTime dateTime = DateTime.parse(data);
    var text = ' - ${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return text;
  }

  Widget _buildGastoItemSlidable(BuildContext context, int index) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(5),
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
        child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: _buildGastoItem(context, index),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Editar',
                  color: Colors.blue,
                  icon: Icons.edit,
                  onTap: () {
                    _addGastos(editedGastos: _gastosList[index], index: index);
                  },
                ),
                IconSlideAction(
                  caption: 'Excluir',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    _deleteGasto(
                        deletedGasto: _gastosList[index], index: index);
                  },
                ),
              ],
            )));
  }

  Future _addGastos({Gastos editedGastos, int index}) async {
    final gasto = await showDialog<Gastos>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ControleDialogGastos(gastos: editedGastos);
      },
    );

    if (gasto != null) {
      setState(() {
        if (index == null) {
          _gastosList.add(gasto);
          _helper.save(gasto);
        } else {
          _gastosList[index] = gasto;
          _helper.update(gasto);
        }
      });
    }
  }

  void _deleteGasto({Gastos deletedGasto, int index}) {
    setState(() {
      _gastosList.removeAt(index);
    });

    _helper.delete(deletedGasto.id);

    Flushbar(
            title: "Exclusão de Gastos",
            message: "Gasto \"${deletedGasto.nome}\" removido.",
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            duration: Duration(seconds: 2))
        .show(context);
  }
}
