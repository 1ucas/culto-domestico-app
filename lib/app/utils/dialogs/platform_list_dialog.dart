import 'dart:io';

import 'package:culto_domestico_app/app/utils/dialogs/platform_aware_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

class PlatformListDialog extends PlatformWidget {
  PlatformListDialog({
    @required this.title,
    @required this.content,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final List<PedidoOracao> content;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => this,
          );
  }

  Widget _buildContent() {
    return ListView.builder(
      itemBuilder: (_, index) {
        return CheckboxListTile(
            value: false,
            selected: content[index].respondida,
            title: Text(
              content[index].texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onChanged: (selected) {
              // TODO: Marcar oracoes
            });
      },
      itemCount: content.length,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    actions.add(
      PlatformListDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}

class PlatformListDialogAction extends PlatformWidget {
  PlatformListDialogAction({this.child, this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
