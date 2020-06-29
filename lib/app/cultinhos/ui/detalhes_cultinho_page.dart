
import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:flutter/material.dart';

class DetalhesCultinhoPage extends StatelessWidget {

  final Cultinho cultinho;

  const DetalhesCultinhoPage({Key key, this.cultinho}) : super(key: key);

  Widget _buildContents() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cultinho"),
      ),
      body: _buildContents(),
    );
  }
}