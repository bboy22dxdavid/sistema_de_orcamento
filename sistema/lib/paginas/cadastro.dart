import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema/bancoDados/banco.dart';
import 'package:sistema/objetos/objContato.dart';
import 'package:sistema/objetos/objOrcamento.dart';
import 'package:sistema/paginas/inicio.dart';
import 'package:sistema/paginas/lista.dart';
import 'package:sistema/paginas/orcamento.dart';

/*
================================================================================
  TELA DE CADASTRO
   */
class Cadastro extends StatefulWidget {

  //intanciando a classe contatos
  final Contact contact;
  //construtor
  Cadastro({this.contact});

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //==INSTANCIANDO AS CLASSES==
  Contact _editedContats;
  ContactHelper helper = ContactHelper();

  //==VARIAVEIS GLOBAIS==
  bool _useEdited = false;

  //controladores
  final _nameCont = TextEditingController();
  final _emailCont = TextEditingController();
  final _phoneCont = TextEditingController();

  //variavel de foco
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    //iniciando as condicoes
    if(widget.contact == null){
      _editedContats = Contact();
      print(_editedContats);
    }else{
      _editedContats = Contact.fromMap(widget.contact.toMap());

      _nameCont.text = _editedContats.name;
      _emailCont.text = _editedContats.email;
      _phoneCont.text = _editedContats.phone;
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        //Iniciando o layout do app
        /*=======================================================================
                        INICIANDO A BARRA DO TITULO
           =====================================================================*/
        child: Scaffold(
          appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon( Icons.filter_list),
                  onPressed: (){
                    Navigator.pushNamed(context, "/Lista");
                  },
                )
              ],
              title: Text(_editedContats.name ?? "NOVO CONTATO"),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),
          /*=======================================================================
          INICIANDO O CORPO DO APP
           */
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              //iniciando condicao para validar o formulario
              if(_editedContats.name != null && _editedContats.name.isNotEmpty){
                helper.saveContact(_editedContats);
                print(_editedContats);
                _showDialog();

              }else{
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContats.img != null ?
                          FileImage( File(_editedContats.img)):
                          AssetImage("images/person.png")),
                    ),
                  ),
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                      //iniciando as condiçoes para verificar se o usuario tirou ou nao a imagem
                      if(file == null) return;
                      setState(() {
                        _editedContats.img = file.path;
                      });
                    });
                  }, //botao de troca de imagem
                ),

                /*========================================================
              INICIANDO FORMULARIO
               */
                TextField(
                  controller: _nameCont,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (Text) {
                    _useEdited = true;
                    setState(() {
                      _editedContats.name = Text;
                    });
                  },
                ),
                TextField(
                  controller: _phoneCont,
                  decoration: InputDecoration(labelText: "Telefone"),
                  onChanged: (Text) {
                     _useEdited = true;
                     _editedContats.phone = Text;
                  },
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _emailCont,
                  decoration: InputDecoration(labelText: "E-Mail"),
                  onChanged: (Text) {
                      _useEdited = true;
                      _editedContats.email = Text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ));
  }

  /*========================================================
              INICIANDO AS FUNÇÕES
 */
  Future<bool> _requestPop() {
    if (_useEdited) {
      showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("DESCARTAR ALTERAÇÕES?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("SIM"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  //FUNCAO QUE ENVIA OS DADOS PARA PROXIMA TELA DE inicio
  void _showInicio({inicio Ini}) async {
    final recContact = await Navigator.pushNamed(context, "/Inicio");
  }

  //FUNCAO QUE ENVIA OS DADOS PARA PROXIMA TELA DE inicio
  void _showOrcamento({Orcamento orcamento}) async {
    final recContact = await Navigator.pushNamed(context, "/Orcamento");
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Cliente Salvo!"),
          content: new Text(
              "Deseja adicionar um orçamento."),
          actions: <Widget>[
            // define os botões na base do dialogo
             FlatButton(
              child: new Text("SIM"),
              onPressed: () {
                _showOrcamento();
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
