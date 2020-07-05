import 'dart:io';

import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/utils/dialogs/list_dialog_item.dart';
import 'package:culto_domestico_app/app/utils/dialogs/platform_aware_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformListDialog extends PlatformWidget {
  PlatformListDialog({
    @required this.title,
    @required this.content,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final List<ListDialogItem> content;
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
    return Center(
      child: Container(
        width: 300,
        child: ListView.builder(
          itemBuilder: (_, index) {
            return ChangeNotifierProvider<ListDialogItem>(
              create: (_) => content[index],
              child: Consumer<ListDialogItem>(
                builder: (context, model, _) => CheckboxListTile(
                  value: content[index].selected,
                  selected: content[index].selected,
                  activeColor: AppStyle.PrimaryColor,
                  title: Text(
                    content[index].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  onChanged: (selected) {
                    content[index].setSelected(selected);
                  },
                ),
              ),
            );
          },
          itemCount: content.length,
        ),
      ),
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
        onPressed: () => Navigator.of(context).pop(content.map((e) => e.selected).toList()),
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
