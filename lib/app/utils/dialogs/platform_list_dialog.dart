import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/utils/dialogs/platform_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformListDialog extends PlatformDialog {
  PlatformListDialog({
    @required String title,
    @required this.content,
    @required this.defaultActionText,
    this.readonly = false
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null),
        super(title: title);

  final List<ListDialogItem> content;
  final String defaultActionText;
  final bool readonly;

  Widget buildItem(ListDialogItem item, int index) {
    Widget wid;
    if (readonly) {
      wid = Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          "${index+1} - ${content[index].title}",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      );
    } else {
      wid = CheckboxListTile(
        value: content[index].selected,
        selected: content[index].selected,
        activeColor: AppStyle.PrimaryColor,
        title: Text(
          content[index].title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        onChanged: (selected) {
          content[index].setSelected(selected);
        },
      );
    }
    return wid;
  }

  Widget buildContent() {
    return Container(
      width: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (_, index) {
          return ChangeNotifierProvider<ListDialogItem>(
            create: (_) => content[index],
            child: Consumer<ListDialogItem>(
              builder: (context, model, _) => buildItem(content[index], index),
            ),
          );
        },
        itemCount: content.length,
      ),
    );
  }

  @override
  List<PlatformDialogAction> buildActions(BuildContext context) {
    final actions = <PlatformDialogAction>[];
    actions.add(
      PlatformDialogAction(
        child: Text(defaultActionText),
        onPressed: () =>
            Navigator.of(context).pop(content.map((e) => e.selected).toList()),
      ),
    );
    return actions;
  }
}

abstract class ListDialogItem<T> with ChangeNotifier {
  ListDialogItem({@required this.item, selected = false}) {
    _selected = selected;
  }

  T item;
  bool _selected;

  bool get selected => _selected;
  String get title;

  void setSelected(bool selected) {
    this._selected = selected;
    notifyListeners();
  }
}
