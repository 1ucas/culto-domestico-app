import 'package:culto_domestico_app/app/pedidos_oracao/ui/pedidos_oracao_page.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/cultinhos_page.dart';
import 'package:flutter/material.dart';

enum AppTabItem {
  cultinhos,
  oracoes,
  acompanhamento;

  WidgetBuilder get widgetBuilder {
    switch (this) {
      case AppTabItem.cultinhos:
        return (_) => CultinhosPage();
      case AppTabItem.oracoes:
        return (_) => PedidosOracaoPage();
      case AppTabItem.acompanhamento:
        return (_) => CultinhosPage();
    }
  }
}

class TabItemData {
  const TabItemData({required this.title, required this.icon});

  final String title;
  final IconData icon;

  static const Map<AppTabItem, TabItemData> allTabs = {
    AppTabItem.cultinhos: TabItemData(title: 'Cultinhos', icon: Icons.dehaze),
    AppTabItem.oracoes: TabItemData(title: 'Orações', icon: Icons.email),
    AppTabItem.acompanhamento:
        TabItemData(title: 'Resumo', icon: Icons.show_chart),
  };
}
