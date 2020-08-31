/*
===============================================================================
classe que cria os atributos do contato.
 */
import 'package:sistema/bancoDados/banco.dart';

class Contact {
  //INSTANCIANDO A CLASSE DO BANCO DE DADOS
  ContactHelper db;

//atributos da classe
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();//construtor vazio
/*
  ******************************************************************************
  contrutor, para armazena os dados em formato de map.
   */
  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }
// funcao que retorna um mapa
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    //condicao para armazena o id
    if(id != null){
      map[idColumn] = id;
    }
    return map;//retornando o mapa
  }

//para melhorar a forma de leitura do mapa
  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }

}