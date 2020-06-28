import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/cultinho_list_tile.dart';
import 'package:culto_domestico_app/app/utils/lists/general_list_builder.dart';
import 'package:flutter/material.dart';

class CultinhosPage extends StatelessWidget {
  final List<Cultinho> cultinhos;

  const CultinhosPage({Key key, @required this.cultinhos}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    return GeneralListBuilder<Cultinho>(
      itemBuilder: (context, cultinho) => CultinhoListTile(cultinho: cultinho),
      items: cultinhos,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cultinhos"),
      ),
      body: _buildBody(context),
    );
  }
}
