import 'package:flutter/material.dart';

class NovaOracaoPage extends StatelessWidget {
  
  Widget _buildSeveridade() {
    return Container();
  }

  Widget _buildCategoria() {
    return Container();
  }

  Widget _buildTitulo() {
    return Container();
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _buildTitulo(),
        _buildCategoria(),
        _buildSeveridade(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Oração"),
      ),
      body: _buildContent(context),
    );
  }
}
