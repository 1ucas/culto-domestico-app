import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/services/cultinho_service.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/cultinho_list_tile.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/novo_cultinho_page.dart';
import 'package:culto_domestico_app/app/utils/lists/general_list_builder.dart';
import 'package:flutter/material.dart';

class CultinhosPage extends StatefulWidget {
  @override
  _CultinhosPageState createState() => _CultinhosPageState();
}

class _CultinhosPageState extends State<CultinhosPage> {
  Future<List<Cultinho>> cultinhos;

  @override
  void initState() {
    super.initState();
    cultinhos = CultinhoService().listarCultinhosFeitos();
  }

  void _navegarParaNovoCultinho(BuildContext context) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => NovoCultinho()))
        .then((_) {
      setState(() {
        cultinhos = CultinhoService().listarCultinhosFeitos();
      });
    });
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: cultinhos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GeneralListBuilder<Cultinho>(
              itemBuilder: (context, cultinho) => CultinhoListTile(
                  cultinho: cultinho,
                  onDelete: (id) {
                    CultinhoService().removerCultinho(id: id).then((_) {
                      cultinhos = CultinhoService().listarCultinhosFeitos();
                    });
                  }),
              items: snapshot.data,
              separated: false,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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
            onPressed: () => _navegarParaNovoCultinho(context),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }
}
