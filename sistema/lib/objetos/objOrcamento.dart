/*
===============================================================================
classe que cria os atributos do orcamento.
 */
import 'package:sistema/bancoDados/banco.dart';

class ObjOrcamento {
  //INSTANCIANDO A CLASSE DO BANCO DE DADOS
  ContactHelper db;
//atributos da classe
  int idOc;
  String area;
  String grama;
  String local;
  String adcional;
  String total;

  ObjOrcamento(); //construtor vazio
/*
  ******************************************************************************
  contrutor, para armazena os dados em formato de map.
   */
  ObjOrcamento.fromMap(Map map){
    idOc = map[idColl];
    area = map[areaColumn];
    grama = map[gramaColumn];
    local = map[localColumn];
    adcional = map[adcionalColumn];
    total = map[totalColumn];
  }

// funcao que retorna um mapa
  Map toMap() {
    Map<String, dynamic> map = {
      areaColumn: area,
      gramaColumn: grama,
      localColumn: local,
      adcionalColumn: adcional,
      totalColumn: total
    };
    //condicao para armazena o id
    if (idOc != null) {
      map[idColl] = idOc;
    }
    return map; //retornando o mapa
  }

//para melhorar a forma de leitura do mapa
  @override
  String toString() {
    return "Orc(id: $idOc, area: $area, grama: $grama, local: $local, adcional: $adcional, total: $total)";
  }
}