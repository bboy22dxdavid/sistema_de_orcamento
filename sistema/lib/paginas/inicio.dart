import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistema/bancoDados/banco.dart';
import 'package:sistema/objetos/objContato.dart';
import 'package:sistema/paginas/cadastro.dart';
import 'package:sistema/paginas/lista.dart';
import 'package:sistema/paginas/orcamento.dart';
/*
================================================================================
  TELA INICIAL
   */
class inicio extends StatefulWidget {

  @override
  _inicioState createState() => _inicioState();
}

class _inicioState extends State<inicio> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Iniciando o layout do app
      /*=======================================================================
      INICIANDO A BARRA DO TITULO
       */
      appBar: AppBar(
        title: Text("SMS Gramas",  style: TextStyle(),),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,

      /*=======================================================================
      INICIANDO O CORPO DO APP
       */
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image:DecorationImage(
                  image:  AssetImage("images/logo.png")
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 10.0, left: 80.0, right: 80.0
              ),
              child: Container(
                height: 50.0,
                child:  RaisedButton(
                  onPressed: (){
                    _showCadastro();
                  },
                  child: Text("CADASTRO",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 80.0, right: 80.0
              ),
              child: Container(
                height: 50.0,
                child:  RaisedButton(
                  onPressed: () {
                    _showOrcamento();
                  },
                  child: Text("ORÇAMENTO",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 80.0, right: 80.0
              ),
              child: Container(
                height: 50.0,
                child:  RaisedButton(
                  onPressed: (){
                    _showLista();
                  },
                  child: Text("LISTA",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  color: Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //FUNCAO QUE ENVIA OS DADOS PARA PROXIMA TELA DE CADASTRO
  void _showCadastro({Contact contacts})async {
    final recContact = await Navigator.pushNamed(context, "/Cadastro"
    );
  }

//FUNCAO QUE ENVIA OS DADOS PARA TELA DE ORÇAMENTO
  void _showOrcamento({Orcamento orcamento}) async {
    final recContact = await Navigator.pushNamed(context, "/Orcamento"
    );
  }

  //FUNCAO QUE ENVIA OS DADOS PARA TELA DE LISTA
  void _showLista({Lista lista}) async {
    final recContact = await Navigator.pushNamed(context, "/Lista"
    );
  }
}
