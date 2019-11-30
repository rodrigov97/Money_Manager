import 'package:flutter/material.dart';
import 'package:money_manager/models/dados.dart';

class ControleDialogGanhos extends StatefulWidget {
  final Gastos gastos;
  final GastosHistorico gastosHistorico;

  ControleDialogGanhos({this.gastos, this.gastosHistorico});

  @override
  _ControleDialogGanhosState createState() => _ControleDialogGanhosState();
}

class _ControleDialogGanhosState extends State<ControleDialogGanhos> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();
  Gastos _gastos = Gastos();
  GastosHistorico _gastosHistorico = GastosHistorico();
  var data = DateTime.now();
  String titulo = '';

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
      title: Text(widget.gastos == null ? 'Novo Ganho' : 'Editar Ganho'),
      content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                autofocus: true,
                validator: (text) {
                  return text.isEmpty ? 'Campo Obrigatório' : null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (text) {
                  return text.isEmpty ? 'Campo Obrigatório' : null;
                },
              ),
            ],
          )),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Salvar'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _gastos.nome = _tituloController.text;
              _gastos.valor = double.parse(_valorController.text);
              _gastos.data = data.toString();
              _gastos.tipo = 'Ganhos';
              Navigator.of(context).pop(_gastos);
                            _gastosHistorico.nome = _tituloController.text;
              _gastosHistorico.valor = double.parse(_valorController.text);
              _gastosHistorico.tipo = 'Gastos';
              _gastosHistorico.data = data.toString();
              Navigator.of(context).pop(_gastosHistorico);
            }
          },
        ),
      ],
    );
  }
}
