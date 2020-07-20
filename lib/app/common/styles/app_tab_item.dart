
import 'package:flutter/material.dart';

enum AppTabItem { cultinhos, oracoes, acompanhamento }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<AppTabItem, TabItemData> allTabs = {
    AppTabItem.cultinhos: TabItemData(title: 'Cultinhos', icon: Icons.dehaze),
    AppTabItem.oracoes: TabItemData(title: 'Orações', icon: Icons.email),
    AppTabItem.acompanhamento: TabItemData(title: 'Resumo', icon: Icons.show_chart),
  };

}