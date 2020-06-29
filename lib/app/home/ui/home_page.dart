import 'package:culto_domestico_app/app/cultinhos/services/cultinho_service.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/cultinhos_page.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/ui/pedidos_oracao_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // RaisedButton(
          //   onPressed: () => {},
          //   child: Text('Abrir Painel / Perfil Familia / Perfil da Pessoa'),
          // ),
          RaisedButton(
            onPressed: () => _navegarParaCultinhosFeitos(context),
            child: Text('Abrir Lista Cultinhos Feitos'),
          ),
          // RaisedButton(
          //   onPressed: () => {},
          //   child: Text('Abrir Registro Cultinho'),
          // ), // Botão (  +  )
          RaisedButton(
            onPressed: () => _navegarParaPedidosOracao(context),
            child: Text('Abrir Registro Pedidos de Oração'),
          ),
          // RaisedButton(
          //   onPressed: () => {},
          //   child: Text('Abrir Sugestões de Leitura'),
          // ),
        ],
      ),
    );
  }

  void _navegarParaPedidosOracao(BuildContext context) {
    Navigator.push<PedidosOracaoPage>(
        context,
        MaterialPageRoute(
          builder: (_) => PedidosOracaoPage(
            itens: PedidosOracaoService().listarPedidosOracao(),
          ),
        ));
  }

  void _navegarParaCultinhosFeitos(BuildContext context) {
    Navigator.push<PedidosOracaoPage>(
        context,
        MaterialPageRoute(
          builder: (_) => CultinhosPage(
            cultinhos: CultinhoService().listarCultinhosFeitos(),
          ),
        ));
  }

}

/*
Cultinho -> 1) Hino ?  2) Passagem lida. 3) Quem orou? 4) Pedidos de oração
 */
