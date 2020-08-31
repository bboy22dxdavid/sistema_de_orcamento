import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistema/bancoDados/banco.dart';
import 'package:sistema/objetos/objContato.dart';
import 'package:sistema/objetos/objOrcamento.dart';
import 'package:sistema/paginas/inicio.dart';
import 'package:sistema/paginas/lista.dart';

/*
================================================================================
  TELA DE ORCAMENTO
   */
class Orcamento extends StatefulWidget {
  //intanciando a classe contatos
  final ObjOrcamento objOrc;
  //construtor
  Orcamento({this.objOrc, ObjOrcamento objOrcamento});

  @override
  _OrcamentoState createState() => _OrcamentoState();
}

class _OrcamentoState extends State<Orcamento> {
  ContactHelper helper = ContactHelper();
  /*==============================================
             VARIAVEIS GLOBAIS
    ==============================================*/
  String _infoText = "Orçamento ";
  ObjOrcamento _editedOrcament;

  //variaveis de controler
  TextEditingController _areaCont = TextEditingController();
  TextEditingController _gramaCont = TextEditingController();
  TextEditingController _localCont = TextEditingController();
  TextEditingController _adcionalCont = TextEditingController();
  TextEditingController _totalCont = TextEditingController();


  //variavel de foco
  final _areaFocus = FocusNode();

  //variavel
  bool _useEdited = false;

  @override
  void initState() {
    super.initState();
    //iniciando as condicoes
    if (widget.objOrc == null) {
      _editedOrcament = ObjOrcamento();
    } else {
      _editedOrcament = ObjOrcamento.fromMap(widget.objOrc.toMap());

      _areaCont.text = _editedOrcament.area;
      _gramaCont.text = _editedOrcament.grama;
      _localCont.text = _editedOrcament.local;
      _adcionalCont.text = _editedOrcament.adcional;
      _totalCont.text = _editedOrcament.total;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Iniciando o layout do app
      /*=======================================================================
      INICIANDO A BARRA DO TITULO
       */
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
        title: Text("NOVO ORÇAMENTO"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            //iniciando condicao para validar o formulario
            if (_editedOrcament.area != null &&
                _editedOrcament.area.isNotEmpty) {
              helper.saveOrc(_editedOrcament);
              print(_editedOrcament);
              _showDialog();
            } else {
              FocusScope.of(context).requestFocus(_areaFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red),
      /*=======================================================================
          INICIANDO O CORPO DO APP
        =======================================================================*/
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.monetization_on,
              size: 120.0,
              color: Colors.red,
            ),
            /*========================================================
              INICIANDO FORMULARIO
               */
            TextField(
              controller: _areaCont,
              focusNode: _areaFocus,
              decoration: InputDecoration(labelText: "Area por M²"),
              onChanged: (Text) {
                _useEdited = true;
                setState(() {
                  _editedOrcament.area = Text;
                });
              },
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _gramaCont,
              decoration: InputDecoration(labelText: "Valor da Grama por m²"),
              onChanged: (Text) {
                _useEdited = true;
                _editedOrcament.grama = Text;
              },
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _localCont,
              decoration: InputDecoration(labelText: "Valor de Entrega "),
              onChanged: (Text) {
                _useEdited = true;
                _editedOrcament.local = Text;
              },
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _adcionalCont,
              decoration: InputDecoration(labelText: "Outros Adicionais "),
              onChanged: (Text) {
                _useEdited = true;
                _editedOrcament.adcional = Text;
              },
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 10.0, left: 80.0, right: 80.0),
              child: Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    _calcular();
                  },
                  child: Text(
                    "Calcular",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  color: Colors.green,
                ),
              ),
            ),
            Text(
              _editedOrcament.total = _infoText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 25.0),
            ),
          ],
        ),
      ),
    );
  }

  /*========================================================
              INICIANDO AS FUNÇÕES
    =========================================================*/
  //FUNCAO QUE RETORNA PARA TELA ANTERIOR
  void _showInicio({inicio ine}) async {
    final recContact = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => inicio()));
  }

  //funcao de refresh
  void _refresh() {
    _areaCont.text = "";
    _gramaCont.text = "";
    _localCont.text = "";
    _adcionalCont.text = "";
    setState(() {
      _infoText = "";
    });
  }

  //funçao para calcular
  void _calcular() async{
    ObjOrcamento obj = ObjOrcamento();

    setState(() {
      double area =  double.parse(_areaCont.text);
      double grama = double.parse(_gramaCont.text);
      double local = double.parse(_localCont.text);
      double adcional = double.parse(_adcionalCont.text);
      double resp = (area * grama) + local + adcional;

      //condiçao para orçamento
      if (resp > 0) {
        _totalCont.text = resp.toString();
        _infoText = "Orcamento ${resp.toStringAsPrecision(4)}";
        print("valor $_totalCont");
      }
    });
  }

  //FUNCAO QUE ENVIA OS DADOS PARA PROXIMA TELA DE CADASTRO
  void _showCadastro({Contact contacts}) async {
    final recContact = await Navigator.pushNamed(context, "/Cadastro");
  }

  //FUNCAO QUE ENVIA OS DADOS PARA PROXIMA TELA DE LISTAR
  void _showLista({Lista lista}) async {
    final recContact = await Navigator.pushNamed(context, "/Lista");
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("ORÇAMENTO SALVO! "),
          content: new Text(
              "Deseja concluir seu orçamento?."),
          actions: <Widget>[
            // define os botões na base do dialogo
            FlatButton(
              child: new Text("SIM"),
              onPressed: () {
                _showCadastro();
              },
            ),
            FlatButton(
              child: new Text("NÃO"),
              onPressed: () {
                _showInicio();
              },
            ),
          ],
        );
      },
    );
  }
}
