import 'package:flutter/material.dart';

import '../../widgets/barra_navegacao.dart';
import '../cultos/cultos_page.dart';
import '../oracoes/oracoes_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _aba,
        children: const [CultosPage(), OracoesPage()],
      ),
      bottomNavigationBar: BarraNavegacao(
        selecionado: _aba,
        onSelecionar: (indice) => setState(() => _aba = indice),
        itens: const [
          ItemNav(
            icone: Icons.menu_book_outlined,
            iconeAtivo: Icons.menu_book_rounded,
            rotulo: 'Cultinhos',
          ),
          ItemNav(
            icone: Icons.volunteer_activism_outlined,
            iconeAtivo: Icons.volunteer_activism_rounded,
            rotulo: 'Orações',
          ),
        ],
      ),
    );
  }
}
