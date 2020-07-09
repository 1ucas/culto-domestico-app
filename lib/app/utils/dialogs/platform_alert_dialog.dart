import 'package:culto_domestico_app/app/utils/dialogs/platform_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends PlatformDialog {
  PlatformAlertDialog({
    @required String title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null),
        super(title: title);

  final String content;
  final String cancelActionText;
  final String defaultActionText;

  @override
  List<PlatformDialogAction> buildActions(BuildContext context) {
    final actions = <PlatformDialogAction>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformDialogAction(
          child: Text(cancelActionText),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      PlatformDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }

  @override
  Widget buildContent() {
    return Text(content);
  }
}
