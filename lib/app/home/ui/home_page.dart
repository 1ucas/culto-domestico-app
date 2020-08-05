import 'package:culto_domestico_app/app/common/styles/app_bottom_bar.dart';
import 'package:culto_domestico_app/app/common/styles/app_tab_item.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/cultinhos_page.dart';
import 'package:culto_domestico_app/app/local/data/pedidos_oracao_local_data.dart';
import 'package:culto_domestico_app/app/local/data/pedidos_oracao_repository.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/ui/pedidos_oracao_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentTab = AppTabItem.cultinhos;

  final Map<AppTabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    AppTabItem.cultinhos: GlobalKey<NavigatorState>(),
    AppTabItem.oracoes: GlobalKey<NavigatorState>(),
    //AppTabItem.acompanhamento: GlobalKey<NavigatorState>(),
  };

  Map<AppTabItem, WidgetBuilder> get widgetBuilders {
    return {
      AppTabItem.cultinhos: (_) => CultinhosPage(),
      AppTabItem.oracoes: (_) => PedidosOracaoPage(),
      //AppTabItem.acompanhamento: (_) => DashboardPage(),
    };
  }

  void _select(AppTabItem item) {
    if (item == _currentTab) {
      navigatorKeys[item].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = item;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<PedidosOracaoRepository>(
      create: (context) => PedidosOracaoLocalData(),
      child: AppBottomBar(
        navigatorKeys: navigatorKeys,
        widgetBuilders: widgetBuilders,
        currentTab: _currentTab,
        onSelectTab: _select,
      ),
    );
  }
}

/*
Cultinho -> 1) Hino ?  2) Passagem lida. 3) Quem orou? 4) Pedidos de oração
 */
