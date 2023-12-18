import 'dart:io';

import 'package:culto_domestico_app/app/utils/dialogs/platform_aware_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class PlatformDialog extends PlatformWidget {
  PlatformDialog({required this.title});

  final String title;

  Widget buildContent();

  List<PlatformDialogAction> buildActions(BuildContext context);

  @nonVirtual
  Future<bool?> show(BuildContext context) async {
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

  @override
  @nonVirtual
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: buildContent(),
      actions: buildActions(context),
    );
  }

  @override
  @nonVirtual
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: buildContent(),
      actions: buildActions(context),
    );
  }
}

class PlatformDialogAction extends PlatformWidget {
  PlatformDialogAction({required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  @nonVirtual
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  @nonVirtual
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
