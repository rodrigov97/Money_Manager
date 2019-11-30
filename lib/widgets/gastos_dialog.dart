import 'package:flutter/material.dart';
import 'package:money_manager/models/dados.dart';

class ControleDialogGastos extends StatefulWidget {
  final Gastos gastos;
  final GastosHistorico gastosHistorico;

  ControleDialogGastos({this.gastos, this.gastosHistorico});

  @override
  _ControleDialogState createState() => _ControleDialogState();
}

class _ControleDialogState extends State<ControleDialogGastos> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();
  Gastos _gastos = Gastos();
  GastosHistorico _gastosHistorico = GastosHistorico();
  var data = DateTime.now();
  var titulo;

  @override
  void initState() {
    super.initState();

    if (widget.gastos != null) {
      _gastos = Gastos.fromMap(widget.gastos.toMap());

      _tituloController.text = _gastos.nome.toString();
      _valorController.text = _gastos.valor.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tituloController.clear();
    _valorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.gastos == null ? 'Novo Gasto' : 'Editar Gasto',
          style: TextStyle(fontWeight: FontWeight.w300)),
      content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: TextStyle(fontWeight: FontWeight.w300)),
                autofocus: true,
                validator: (text) {
                  return text.isEmpty ? 'Campo Obrigatório' : null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(
                    labelText: 'Valor',
                    labelStyle: TextStyle(fontWeight: FontWeight.w300)),
                keyboardType: TextInputType.number,
                validator: (text) {
                  return text.isEmpty ? 'Campo Obrigatório' : null;
                },
              ),
            ],
          )),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Salvar', style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _gastos.nome = _tituloController.text;
              _gastos.valor = double.parse(_valorController.text);
              _gastos.tipo = 'Gastos';
              _gastos.data = data.toString();
              Navigator.of(context).pop(_gastos);
            }
          },
        ),
      ],
    );
  }
}
