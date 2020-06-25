import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(onPressed: () => {}, child: Text('Abrir Painel / Perfil Familia / Perfil da Pessoa'),),
          RaisedButton(onPressed: () => {}, child: Text('Abrir Lista Cultinhos Feitos'),),
          RaisedButton(onPressed: () => {}, child: Text('Abrir Registro Cultinho'),),  // Botão (  +  )
          RaisedButton(onPressed: () => {}, child: Text('Abrir Registro Pedidos de Oração'),),
          RaisedButton(onPressed: () => {}, child: Text('Abrir Sugestões de Leitura'),),
        ],
      ),
    );
  }
}

/*
Cultinho -> 1) Hino ?  2) Passagem lida. 3) Quem orou? 4) Pedidos de oração
 */