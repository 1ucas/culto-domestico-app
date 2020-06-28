import 'package:culto_domestico_app/app/utils/lists/empty_list_content.dart';
import 'package:flutter/material.dart';

typedef ListItemBuilder<T> = Widget Function(BuildContext context, T item);

class GeneralListBuilder<T> extends StatelessWidget {
  const GeneralListBuilder(
      {Key key, @required this.items, @required this.itemBuilder})
      : super(key: key);

  final List<T> items;
  final ListItemBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      return _buildList(items);
    } else {
      return EmptyListContent();
    }
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
      itemCount: items.length + 2,
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.5,
        thickness: 1,
      ),
    );
  }
}
