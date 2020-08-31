

import 'package:flutter/material.dart';
import 'package:sistema/paginas/cadastro.dart';
import 'package:sistema/paginas/inicio.dart';
import 'package:sistema/paginas/lista.dart';
import 'package:sistema/paginas/orcamento.dart';

/*
  ================================================================================
  FUNÇÃO PRINCIPAL
   */
void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: inicio(),
    //Lista(),
    routes: {
      "/Cadastro": (context) => Cadastro(),
      "/Orcamento": (context) => Orcamento(),
      "/Lista": (context) => Lista(),
      "/Inicio": (context) => inicio(),
    },
  ));
}