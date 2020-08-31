import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sistema/bancoDados/banco.dart';
import 'package:sistema/objetos/objContato.dart';
import 'package:sistema/objetos/objOrcamento.dart';
import 'package:sistema/paginas/cadastro.dart';
import 'package:sistema/paginas/inicio.dart';
import 'package:sistema/paginas/orcamento.dart';
import 'package:url_launcher/url_launcher.dart';


//iniciando o enumerador
enum OrderOptions {orderaz, orderza}

class Lista extends StatefulWidget {

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  /*===========================================
          INSTANCIANDO AS CLASSES
   */
  ContactHelper helper = ContactHelper();

  //criando as listas
  List<Contact> contacts = List();
  List<ObjOrcamento> orcament = List();


  @override
  void initState() {
    Contact c = Contact();
    ObjOrcamento obj = ObjOrcamento();

    //funçoes que listam os contatos e orcamentos
    _getAllContact();
    _getAllOrc();



    helper.getAllContacts().then((list){
      print(list);
    });

    helper.getAllOrcs().then((list1){
      print(list1);
    });


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Iniciando o layout do app
      /*=======================================================================
                          INICIANDO A BARRA DO TITULO
        =======================================================================*/
      appBar: AppBar(
        title: Text("LISTA"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              )
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      //botao flutuante
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/Orcamento");
        },//funcao anonima,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      /*=========================================================================
                              INICIANDO O CORPO DO APP
        =========================================================================*/
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index){
          return  _contactCard(context, index);
        },
      ),
    );
  }

  /*======================================================================
                         INICIANDO AS FUNÇÕES
    ======================================================================*/
  //funcao que retorna todos os contatos
  void _getAllContact(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }

  //funçao que retorna todos os orçamentos
  void _getAllOrc(){
    helper.getAllOrcs().then((list1){
      setState(() {
        orcament = list1;
      });
    });
  }

  //FUNCAO QUE ENVIA OS DADOS PARA TELA DE ORÇAMENTO
  void _showOrcamento({ObjOrcamento objOrcamento})async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => Orcamento(objOrcamento: objOrcamento,))
    );

    //iniciando condicao para verificar se o contato e nulo
    if(recContact != null){
      if(objOrcamento != null){
        await helper.updateOrc(recContact);
        _getAllOrc();
      }else{
        await helper.saveOrc(recContact);
      }
      _getAllOrc();
    }
  }

  /*
  FUNCAO QUE RETORNA O WIDGES DOS ELEMENTOS DA LISTA
   */
  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card (
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(//inicio da linha do elemento da lista
            children: <Widget>[
              Container(//iniciando a imagem do contato
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].img != null ?
                        FileImage(File(contacts[index].img)) :
                        AssetImage("images/person.png"),
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(//iniciando os textos de dados do contato
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18.0,
                      ),
                    ),
                    Text(contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 18.0,
                      ),
                    ),
                    Text(orcament[index].total?? "",
                      style: TextStyle(fontSize: 18.0,
                          fontWeight: FontWeight.bold
                     ),
                    ),
                  ],
                ),
              )
            ],
          ) ,
        ),
      ),
      onTap: (){
        _ShowOptions(context, index);
      },
    );
  }

  //FUNCAO PARA MOSTRA AS OPÇÕES
  void _ShowOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder:(context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("LIGAR",
                          style: TextStyle(color: Colors.red,
                              fontSize:  20.0),
                        ),
                        onPressed: (){
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("EDITAR",
                          style: TextStyle(color: Colors.red,
                              fontSize:  20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                          _showCadastro(contacts: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("EXCLUIR",
                          style: TextStyle(color: Colors.red,
                              fontSize:  20.0),
                        ),
                        onPressed: (){
                          helper.deleteContact(contacts[index].id);
                          helper.deleteOrc(orcament[index].idOc);
                          setState(() {
                            contacts.removeAt(index);
                            orcament.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("EDITAR ORÇAMENTO",
                          style: TextStyle(color: Colors.red,
                              fontSize:  20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                          _showOrcament(objOrcament: orcament[index]);
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  //FUNCAO QUE ENVIA OS DADOS PARA PROXIMA TELA
  void _showCadastro({Contact contacts})async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => Cadastro(contact: contacts ))
    );

    //iniciando condicao para verificar se o contato e nulo
    if(recContact != null){
      if(contacts != null){
        await helper.updateContact(recContact);
        _getAllContact();
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContact();
    }
  }

  //FUNCAO QUE ENVIA OS DADOS PARA PROXIMA TELA DE ORCAMENTO
  void _showOrcament({ObjOrcamento objOrcament})async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => Orcamento(objOrc: objOrcament ))
    );

    //iniciando condicao para verificar se o orçamento  e nulo
    if(recContact != null){
      if(objOrcament != null){
        await helper.updateOrc(recContact);
        _getAllOrc();
      }else{
        await helper.saveOrc(recContact);
      }
      _getAllOrc();
    }
  }

  //funcao que ira ordenar os contatos
  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return  b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

  //FUNCAO QUE RETORNA PARA TELA ANTERIOR
  void _showInicio({inicio ine}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => inicio())
    );
  }
}

