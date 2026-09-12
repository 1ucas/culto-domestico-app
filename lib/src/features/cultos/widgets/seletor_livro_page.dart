import 'package:flutter/material.dart';

import '../../../models/livro.dart';
import '../../../theme/cores.dart';
import '../../../theme/tipografia.dart';
import '../../../widgets/rotulos.dart';

/// Escolha do livro. A busca ignora acentos, porque ninguém digita "Êxodo" com
/// o circunflexo no teclado do celular.
class SeletorLivroPage extends StatefulWidget {
  const SeletorLivroPage({super.key, this.selecionado});

  final Livro? selecionado;

  @override
  State<SeletorLivroPage> createState() => _SeletorLivroPageState();
}

class _SeletorLivroPageState extends State<SeletorLivroPage> {
  final _busca = TextEditingController();
  String _termo = '';

  @override
  void dispose() {
    _busca.dispose();
    super.dispose();
  }

  List<Livro> get _resultados {
    if (_termo.isEmpty) return Livro.values;
    final termo = semAcentos(_termo);
    return Livro.values
        .where((livro) =>
            semAcentos(livro.nome).contains(termo) ||
            semAcentos(livro.abreviacao).contains(termo))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final resultados = _resultados;

    return Scaffold(
      backgroundColor: cores.superficie,
      appBar: AppBar(
        backgroundColor: cores.superficie,
        title: const Text('Livro'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: TextField(
              controller: _busca,
              autofocus: widget.selecionado == null,
              textCapitalization: TextCapitalization.words,
              style: Tipo.campo.copyWith(color: cores.texto),
              decoration: InputDecoration(
                hintText: 'Buscar livro',
                filled: true,
                fillColor: cores.superficieAlt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Raio.pilula),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Raio.pilula),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Raio.pilula),
                  borderSide: BorderSide(color: cores.marcaTom.cor, width: 1.6),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: cores.textoSuave,
                ),
              ),
              onChanged: (valor) => setState(() => _termo = valor.trim()),
            ),
          ),
          Expanded(
            child: resultados.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum livro com esse nome',
                      style: Tipo.corpo.copyWith(color: cores.textoSuave),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: resultados.length,
                    itemBuilder: (context, indice) {
                      final livro = resultados[indice];
                      final anterior =
                          indice == 0 ? null : resultados[indice - 1];
                      final abreTestamento = anterior == null ||
                          anterior.testamento != livro.testamento;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (abreTestamento)
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                20,
                                indice == 0 ? 8 : 26,
                                20,
                                10,
                              ),
                              child: Micro(livro.testamento.nome),
                            ),
                          _ItemLivro(
                            livro: livro,
                            selecionado: livro == widget.selecionado,
                            onTap: () => Navigator.of(context).pop(livro),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ItemLivro extends StatelessWidget {
  const _ItemLivro({
    required this.livro,
    required this.selecionado,
    required this.onTap,
  });

  final Livro livro;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selecionado ? cores.marcaTom.fundo : cores.superficieAlt,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                livro.abreviacao,
                style: Tipo.pilula.copyWith(
                  color: selecionado ? cores.marcaTom.cor : cores.textoSuave,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                livro.nome,
                style: Tipo.corpoForte.copyWith(color: cores.texto),
              ),
            ),
            Text(
              '${livro.numCapitulos} cap.',
              style: Tipo.apoio.copyWith(color: cores.textoSuave),
            ),
            if (selecionado) ...[
              const SizedBox(width: 10),
              Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: cores.marcaTom.cor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

const _comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ';
const _semAcento = 'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC';

String semAcentos(String texto) {
  final minusculo = texto.toLowerCase();
  final buffer = StringBuffer();
  for (var i = 0; i < minusculo.length; i++) {
    final caractere = minusculo[i];
    final indice = _comAcento.indexOf(caractere);
    buffer.write(indice >= 0 ? _semAcento[indice] : caractere);
  }
  return buffer.toString();
}
