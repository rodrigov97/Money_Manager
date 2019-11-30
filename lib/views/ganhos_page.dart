import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/helpers/helper.dart';
import 'package:money_manager/widgets/custom_drawer.dart';
import 'package:money_manager/widgets/ganhos_dialog.dart';
import 'package:money_manager/models/dados.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GanhosPage extends StatefulWidget {
  static const String routeName = '/ganhos';
  @override
  _GanhosPage createState() => _GanhosPage();
}

class _GanhosPage extends State<GanhosPage> {
  List<Gastos> _gastosList = [];
  List<GastosHistorico> _gastosListHistorico = [];
  GastosHelper _helper = GastosHelper();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _helper.getGanhos().then((list) {
      setState(() {
        _gastosList = list;
        _loading = false;
      });
    });
    _helper.getGanhosHistorico().then((listHist) {
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
      body: _buildGanhoList(),
      floatingActionButton: _floatingButton(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Ganhos', style: TextStyle(fontWeight: FontWeight.w300)),
    );
  }

  Widget _floatingButton() {
    return FloatingActionButton(child: Icon(Icons.add), onPressed: _addGanho);
  }

  Widget _buildGanhoList() {
    if (_gastosList.isEmpty) {
      return Center(
        child: _loading
            ? CircularProgressIndicator()
            : Icon(_iconEmptyGanho(), color: Colors.black12, size: 100),
      );
    } else {
      return Padding(
          padding: EdgeInsets.all(10),
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
            ),
            itemBuilder: _buildGanhoItemSlidable,
            itemCount: _gastosList.length,
          ));
    }
  }

  IconData _iconEmptyGanho() {
    return FontAwesomeIcons.sadTear;
  }

  Widget _buildGanhoItem(BuildContext context, int index) {
    final gasto = _gastosList[index];
    return Container(
        decoration: BoxDecoration(
            color: Colors.green[400], borderRadius: BorderRadius.circular(5)),
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

  Widget _buildGanhoItemSlidable(BuildContext context, int index) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                blurRadius: 10.0,
                spreadRadius: 0.1,
                offset: Offset(
                  5.0,
                  5.0,
                ))
          ],
        ),
        child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: _buildGanhoItem(context, index),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Editar',
                  color: Colors.blue,
                  icon: Icons.edit,
                  onTap: () {
                    _addGanho(
                        deletedGanho: _gastosList[index],
                        index: index);
                  },
                ),
                IconSlideAction(
                  caption: 'Excluir',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    _deleteGanho(
                        deletedGanho: _gastosList[index], index: index);
                  },
                ),
              ],
            )));
  }

  Future _addGanho(
      {Gastos deletedGanho, int index}) async {
    final gasto = await showDialog<Gastos>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ControleDialogGanhos(
          gastos: deletedGanho,
        );
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

  void _deleteGanho({Gastos deletedGanho, int index}) {
    setState(() {
      _gastosList.removeAt(index);
    });

    _helper.delete(deletedGanho.id);

    Flushbar(
            title: "Exclusão de Ganho",
            message: "Ganho \"${deletedGanho.nome}\" removido.",
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            duration: Duration(seconds: 2))
        .show(context);
  }
}
