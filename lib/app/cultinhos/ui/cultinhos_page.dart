import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/cultinho_list_tile.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/detalhes_cultinho_page.dart';
import 'package:culto_domestico_app/app/utils/lists/general_list_builder.dart';
import 'package:flutter/material.dart';

class CultinhosPage extends StatelessWidget {
  final List<Cultinho> cultinhos;

  const CultinhosPage({Key key, @required this.cultinhos}) : super(key: key);

  void _navegarParaDetalhesCultinho(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesCultinhoPage()));
  }

  Widget _buildBody(BuildContext context) {
    return GeneralListBuilder<Cultinho>(
      itemBuilder: (context, cultinho) => CultinhoListTile(cultinho: cultinho),
      items: cultinhos,
      separated: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cultinhos"),
        backgroundColor: AppStyle.PrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _navegarParaDetalhesCultinho(context),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }
}
