import 'dart:async';
import 'package:path/path.dart';
import 'package:sistema/objetos/objContato.dart';
import 'package:sistema/objetos/objOrcamento.dart';
import 'package:sqflite/sqflite.dart';

//Criando a tabela e as colunas de contato na base de dados
final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

//Criando a tabela e as colunas orcamento na base de dados
final String orcTable = "orcTable";
final String idColl = "idColl";
final String areaColumn = "areaColumn";
final String gramaColumn = "gramaColumn";
final String localColumn = "localColumn";
final String adcionalColumn = "adcionalColumn";
final String totalColumn = "totalColumn";

/*
===============================================================================
classe que obtem os contatos.
essa classe n pode ser instanciada, ela ira ter apenas um obj da classe
 */
class ContactHelper {
//instanciando a classe
  static final ContactHelper _instance = ContactHelper.internal();


//fabrica
  factory ContactHelper() => _instance;

//contrutor vazio.
  ContactHelper.internal();

//criando o banco de dados
  Database _db;

  //iniciando o banco de dados
  Future<Database> get db async {
    //iniciando as condiçoes para iniciar o banco de dados
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  //funcao que inicia o banco
  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath(); //caminho do banco
    final path = join(
        databasesPath, "bancodados.db"); //retornando o caminho e nome do arq

    //abrindo o banco de dados
    return await openDatabase(
        path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,"
              "$phoneColumn TEXT, $imgColumn TEXT)"
      );
      db.execute(
          "CREATE TABLE $orcTable($idColl INTEGER PRIMARY KEY , $areaColumn TEXT, $gramaColumn TEXT,"
              "$localColumn TEXT, $adcionalColumn TEXT, $totalColumn TEXT)"
      );
    });
  }

  /*
  =============================================================================
  INICIANDO O CRUDE
  =============================================================================*/

  /*FUNCAO DE SAVAR
  a funcao n ocorre instanteneamente, deve se aguardar receber os dados.
   */
  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;//instanciando o banco de dados.
    contact.id = await dbContact.insert(contactTable, contact.toMap());//obtendo a tabela e os contatos
    return contact;
  }

  /*
  FUNCAO DE OBTER UM DADO
   */
  Future<Contact> getContact(int id) async {
    Database dbContact = await db;//instanciando o banco de dados.
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);//dando uma query na tabela e obtendo os contatos e passando as regras

    //iniciando as condicoes para verificar ser achou os contatos
    if(maps.length > 0){
      return Contact.fromMap(maps.first);
    } else {
      return null;//verifica se nao achou contato
    }
  }

  /*
  FUNCAO PARA DELETAR UM CONTATO
  essa funcao nao deleta instanteneamente.
   */
  Future<int> deleteContact(int id) async {
    Database dbContact = await db;//instanciando o banco de dados.
    return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  /*
  FUNCAO QUE ATUALIZA UM CONTATO,
  essa funcao nao deleta instanteneamente, retorna um inteiro
   */
  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;//instanciando o banco de dados.
    return await dbContact.update(contactTable,
        contact.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contact.id]);
  }

  /*
  FUNCAO PARA OBTER TODOS OS CONTATOS.
  essa funcao retorna uma lista de contatos
   */
  Future<List> getAllContacts() async {
    Database dbContact = await db;//instanciando o banco de dados.
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");//criando uma query para obter uma lista de mapas

    List<Contact> listContact = List();//criando a lista de contatos vazia
    //iniciando o loop para pega todos os contatos
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  /*
  FUNCAO PARA OBTER O NUMERO DE CONTATOS
  essa funcao retorna um inteiro
   */
  Future<int> getNumber() async {
    Database dbContact = await db;//instanciando o banco de dados.
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));//obtendo a contagem dos dados na tabela
  }
/*
  FUNCAO QUE FECHA O BANCO DE DADOS
  essa funcao retorna um futuro vazio
   */
  Future close() async {
    Database dbContact = await db;//instanciando o banco de dados.
    dbContact.close();//fecha o banco de dados
  }

  /*
 ==============================================================================
  INICIANDO O CRUDE
 ==============================================================================
  Orcamento
   */
  /*FUNCAO DE SAVAR
  a funcao n ocorre instanteneamente, deve se aguardar receber os dados.
   */
  Future<ObjOrcamento> saveOrc(ObjOrcamento orc) async {
    Database dbOrc = await db;//instanciando o banco de dados.
    orc.idOc = await dbOrc.insert(orcTable, orc.toMap());//obtendo a tabela e os contatos
    return orc;
  }

  /*
  FUNCAO DE OBTER UM DADO
   */
  Future<ObjOrcamento> getOrc(int id) async {
    Database dbOrc = await db;//instanciando o banco de dados.
    List<Map> maps = await dbOrc.query(orcTable,
        columns: [idColl, areaColumn, gramaColumn, localColumn, adcionalColumn, totalColumn],
        where: "$idColl = ?",
        whereArgs: [id]);//dando uma query na tabela e obtendo os contatos e passando as regras

    //iniciando as condicoes para verificar ser achou os contatos
    if(maps.length > 0){
      return ObjOrcamento.fromMap(maps.first);
    } else {
      return null;//verifica se nao achou contato
    }
  }

  /*
  FUNCAO PARA DELETAR UM CONTATO
  essa funcao nao deleta instanteneamente.
   */
  Future<int> deleteOrc(int id) async {
    Database dbOrc = await db;//instanciando o banco de dados.
    return await dbOrc.delete(orcTable, where: "$idColl = ?", whereArgs: [id]);
  }

  /*
  FUNCAO QUE ATUALIZA UM CONTATO,
  essa funcao nao deleta instanteneamente, retorna um inteiro
   */
  Future<int> updateOrc(ObjOrcamento orc) async {
    Database dbOrc = await db;//instanciando o banco de dados.
    return await dbOrc.update(orcTable,
        orc.toMap(),
        where: "$idColl = ?",
        whereArgs: [orc.idOc]);
  }

  /*
  FUNCAO PARA OBTER TODOS OS CONTATOS.
  essa funcao retorna uma lista de contatos
   */
  Future<List> getAllOrcs() async {
    Database dbOrc = await db;//instanciando o banco de dados.
    List listMap = await dbOrc.rawQuery("SELECT * FROM $orcTable");//criando uma query para obter uma lista de mapas

    List<ObjOrcamento> listOrc = List();//criando a lista de contatos vazia
    //iniciando o loop para pega todos os contatos
    for(Map m in listMap){
      listOrc.add(ObjOrcamento.fromMap(m));
    }
    return listOrc;
  }

  /*
  FUNCAO PARA OBTER O NUMERO DE CONTATOS
  essa funcao retorna um inteiro
   */
  Future<int> getNumberOrc() async {
    Database dbOrc = await db;//instanciando o banco de dados.
    return Sqflite.firstIntValue(await dbOrc.rawQuery("SELECT COUNT(*) FROM $orcTable"));//obtendo a contagem dos dados na tabela
  }
/*
  FUNCAO QUE FECHA O BANCO DE DADOS
  essa funcao retorna um futuro vazio
   */
  Future closeDB() async {
    Database dbOrc = await db;//instanciando o banco de dados.
    dbOrc.close();//fecha o banco de dados
  }
}