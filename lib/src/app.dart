import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/cultos_repository.dart';
import 'data/deposito.dart';
import 'data/oracoes_repository.dart';
import 'features/inicio/inicio_page.dart';
import 'state/cultos_store.dart';
import 'state/oracoes_store.dart';
import 'theme/tema.dart';

class CultoDomesticoApp extends StatelessWidget {
  const CultoDomesticoApp({super.key, Deposito? deposito})
      : _deposito = deposito;

  final Deposito? _deposito;

  @override
  Widget build(BuildContext context) {
    final deposito = _deposito ?? DepositoPreferencias();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CultosStore(CultosRepository(deposito))..carregar(),
        ),
        ChangeNotifierProvider(
          create: (_) => OracoesStore(OracoesRepository(deposito))..carregar(),
        ),
      ],
      child: MaterialApp(
        title: 'Culto Doméstico',
        debugShowCheckedModeBanner: false,
        theme: AppTema.claro,
        darkTheme: AppTema.escuro,
        themeMode: ThemeMode.system,
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const InicioPage(),
      ),
    );
  }
}
