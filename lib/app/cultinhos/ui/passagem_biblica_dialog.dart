import 'package:culto_domestico_app/app/cultinhos/ui/passagem_selector.dart';
import 'package:culto_domestico_app/app/utils/dialogs/platform_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PassagemBiblicaDialog extends PlatformDialog {
  PassagemBiblicaDialog() : super(title: "Passagem Lida");

  final _passagemSelector = PassagemSelector();

  @override
  Widget buildContent() {
    return SingleChildScrollView(child: _passagemSelector);
  }

  @override
  List<PlatformDialogAction> buildActions(BuildContext context) {
    final actions = <PlatformDialogAction>[];
    actions.add(
      PlatformDialogAction(
        child: Text("Cancelar"),
        onPressed: () => Navigator.of(context).pop(null),
      ),
    );
    actions.add(
      PlatformDialogAction(
        child: Text("Ok"),
        onPressed: () {
          var passagens = _passagemSelector.validate();
          if (passagens != null) {
            Navigator.of(context).pop(passagens);
          }
        },
      ),
    );
    return actions;
  }
}
