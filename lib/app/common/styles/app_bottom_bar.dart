import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/common/styles/app_tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
    required this.widgetBuilders,
    required this.navigatorKeys,
  }) : super(key: key);

  final AppTabItem currentTab;
  final ValueChanged<AppTabItem> onSelectTab;
  final Map<AppTabItem, WidgetBuilder> widgetBuilders;
  final Map<AppTabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (context, index) {
        final item = AppTabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) {
            return item.widgetBuilder(context);
          },
        );
      },
      tabBar: CupertinoTabBar(
        backgroundColor: AppStyle.PrimaryColor,
        items: [
          _buildItem(AppTabItem.cultinhos),
          _buildItem(AppTabItem.oracoes),
          //_buildItem(AppTabItem.acompanhamento),
        ],
        onTap: (index) => onSelectTab(AppTabItem.values[index]),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(AppTabItem tabItem) {
    final color = currentTab == tabItem ? Colors.white : Colors.black54;
    final itemData = TabItemData.allTabs[tabItem]!;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      label: itemData.title,
    );
  }
}
