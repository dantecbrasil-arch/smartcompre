import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/tipos_estabelecimento.dart';
import '../data/listas_repository.dart';
import 'detalhe_lista_screen.dart';

const _nomesMeses = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

enum _PeriodoListas {
  mesAtual,
  escolherMes,
  todas,
}

class _ListaNaTela {
  final int indiceOriginal;
  final Map<String, dynamic> lista;
  final DateTime? data;
  final String tipo;

  const _ListaNaTela({
    required this.indiceOriginal,
    required this.lista,
    required this.data,
    required this.tipo,
  });
}

class ListasScreen extends StatefulWidget {
  const ListasScreen({super.key});

  @override
  State<ListasScreen> createState() => _ListasScreenState();
}

class _ListasScreenState extends State<ListasScreen> {
  _PeriodoListas _periodo = _PeriodoListas.mesAtual;
  DateTime _mesSelecionado = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  String? _tipoSelecionado;

  DateTime? _lerData(dynamic valor) {
    if (valor is DateTime) {
      return valor;
    }

    if (valor is! String || valor.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(valor.trim());
  }

  String _tipoParaPasta(dynamic valor) {
    final tipo = valor is String ? valor.trim() : '';

    if (TiposEstabelecimento.todos.contains(tipo)) {
      return tipo;
    }

    return TiposEstabelecimento.outros;
  }

  List<_ListaNaTela> _obterListasDoPeriodo() {
    final agora = DateTime.now();
    final mesAlvo = _periodo == _PeriodoListas.mesAtual
        ? agora
        : _mesSelecionado;
    final resultado = <_ListaNaTela>[];

    for (final entrada
        in ListasRepository.listasSalvas.asMap().entries) {
      final lista = entrada.value;
      final data = _lerData(lista['data']);
      final incluir = switch (_periodo) {
        _PeriodoListas.mesAtual =>
          data != null &&
              data.year == agora.year &&
              data.month == agora.month,
        _PeriodoListas.escolherMes =>
          data != null &&
              data.year == mesAlvo.year &&
              data.month == mesAlvo.month,
        _PeriodoListas.todas => true,
      };

      if (!incluir) {
        continue;
      }

      resultado.add(
        _ListaNaTela(
          indiceOriginal: entrada.key,
          lista: lista,
          data: data,
          tipo: _tipoParaPasta(lista['tipo']),
        ),
      );
    }

    resultado.sort((a, b) {
      if (a.data == null || b.data == null) {
        if (a.data == null && b.data == null) {
          return a.indiceOriginal.compareTo(b.indiceOriginal);
        }

        return a.data == null ? 1 : -1;
      }

      final comparacaoData = b.data!.compareTo(a.data!);
      if (comparacaoData != 0) {
        return comparacaoData;
      }

      return a.indiceOriginal.compareTo(b.indiceOriginal);
    });

    return resultado;
  }

  Map<String, List<_ListaNaTela>> _agruparPorTipo(
    List<_ListaNaTela> listas,
  ) {
    final grupos = <String, List<_ListaNaTela>>{};

    for (final item in listas) {
      grupos.putIfAbsent(item.tipo, () => []).add(item);
    }

    return grupos;
  }

  Future<void> _escolherMes() async {
    var primeiroAno = DateTime.now().year;
    var ultimoAno = primeiroAno;

    for (final lista in ListasRepository.listasSalvas) {
      final data = _lerData(lista['data']);
      if (data == null) {
        continue;
      }

      if (data.year < primeiroAno) {
        primeiroAno = data.year;
      }
      if (data.year > ultimoAno) {
        ultimoAno = data.year;
      }
    }

    final anoInicial = _mesSelecionado.year < primeiroAno
        ? primeiroAno
        : _mesSelecionado.year > ultimoAno
            ? ultimoAno
            : _mesSelecionado.year;
    final mesInicial = anoInicial == _mesSelecionado.year
        ? _mesSelecionado.month
        : 1;
    var mesEscolhido = mesInicial;
    var anoEscolhido = anoInicial;
    final anos = List<int>.generate(
      ultimoAno - primeiroAno + 1,
      (index) => ultimoAno - index,
    );

    final dataEscolhida = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Escolher mês'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Mês',
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: mesEscolhido,
                        isExpanded: true,
                        items: List.generate(
                          _nomesMeses.length,
                          (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text(
                              '${_nomesMeses[index][0].toUpperCase()}'
                              '${_nomesMeses[index].substring(1)}',
                            ),
                          ),
                        ),
                        onChanged: (valor) {
                          if (valor == null) return;

                          setDialogState(() {
                            mesEscolhido = valor;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Ano',
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: anoEscolhido,
                        isExpanded: true,
                        items: anos
                            .map(
                              (ano) => DropdownMenuItem<int>(
                                value: ano,
                                child: Text('$ano'),
                              ),
                            )
                            .toList(),
                        onChanged: (valor) {
                          if (valor == null) return;

                          setDialogState(() {
                            anoEscolhido = valor;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      DateTime(anoEscolhido, mesEscolhido),
                    );
                  },
                  child: const Text('Selecionar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (dataEscolhida == null || !mounted) {
      return;
    }

    setState(() {
      _periodo = _PeriodoListas.escolherMes;
      _mesSelecionado = DateTime(
        dataEscolhida.year,
        dataEscolhida.month,
      );
      _tipoSelecionado = null;
    });
  }

  void _definirPeriodo(_PeriodoListas periodo) {
    setState(() {
      _periodo = periodo;
      _tipoSelecionado = null;
    });
  }

  String _rotuloMes(DateTime data) {
    return '${_nomesMeses[data.month - 1]} ${data.year}';
  }

  Future<void> _abrirLista(_ListaNaTela item) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheListaScreen(
          lista: item.lista,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    await ListasRepository.carregarListas();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _excluirLista(_ListaNaTela item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir Lista'),
          content: Text(
            'Deseja excluir "${item.lista['nomeLista']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) {
      return;
    }

    final listas = ListasRepository.listasSalvas;
    var indiceOriginal = item.indiceOriginal;

    if (indiceOriginal < 0 ||
        indiceOriginal >= listas.length ||
        !identical(listas[indiceOriginal], item.lista)) {
      indiceOriginal = listas.indexWhere(
        (lista) => identical(lista, item.lista),
      );
    }

    if (indiceOriginal == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A lista não foi encontrada para exclusão.'),
        ),
      );
      return;
    }

    setState(() {
      listas.removeAt(indiceOriginal);
    });

    await ListasRepository.salvarListas();

    if (!mounted) {
      return;
    }

    if (_tipoSelecionado != null &&
        !_obterListasDoPeriodo().any(
          (lista) => lista.tipo == _tipoSelecionado,
        )) {
      setState(() {
        _tipoSelecionado = null;
      });
    }
  }

  Widget _construirFiltros() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ChoiceChip(
            label: const Text('Mês atual'),
            selected: _periodo == _PeriodoListas.mesAtual,
            onSelected: (_) {
              _definirPeriodo(_PeriodoListas.mesAtual);
            },
          ),
          ChoiceChip(
            label: Text(
              _periodo == _PeriodoListas.escolherMes
                  ? 'Escolher mês · ${_rotuloMes(_mesSelecionado)}'
                  : 'Escolher mês',
            ),
            selected: _periodo == _PeriodoListas.escolherMes,
            onSelected: (_) => _escolherMes(),
          ),
          ChoiceChip(
            label: const Text('Todas'),
            selected: _periodo == _PeriodoListas.todas,
            onSelected: (_) {
              _definirPeriodo(_PeriodoListas.todas);
            },
          ),
        ],
      ),
    );
  }

  Widget _construirPastas(
    List<_ListaNaTela> listas,
    Map<String, List<_ListaNaTela>> grupos,
  ) {
    if (listas.isEmpty) {
      return Center(
        child: Text(
          ListasRepository.listasSalvas.isEmpty
              ? 'Nenhuma lista salva ainda.'
              : 'Nenhuma lista encontrada para este período.',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    final tipos = TiposEstabelecimento.todos
        .where(grupos.containsKey)
        .toList();

    return ListView.builder(
      itemCount: tipos.length,
      itemBuilder: (context, index) {
        final tipo = tipos[index];
        final quantidade = grupos[tipo]!.length;

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.folder),
            title: Text(tipo),
            subtitle: Text(
              '$quantidade ${quantidade == 1 ? 'lista' : 'listas'}',
            ),
            onTap: () {
              setState(() {
                _tipoSelecionado = tipo;
              });
            },
          ),
        );
      },
    );
  }

  Widget _construirListas(
    List<_ListaNaTela> listas,
    NumberFormat formatoMoeda,
    DateFormat formatoData,
  ) {
    if (listas.isEmpty) {
      return const Center(
        child: Text('Nenhuma lista neste tipo para o período selecionado.'),
      );
    }

    return ListView.builder(
      itemCount: listas.length,
      itemBuilder: (context, index) {
        final item = listas[index];
        final lista = item.lista;
        final quantidadeItens = (lista['produtos'] as List).length;
        final dataFormatada = item.data == null
            ? 'Data não informada'
            : formatoData.format(item.data!);

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            onTap: () => _abrirLista(item),
            leading: const Icon(Icons.list_alt),
            title: Text(lista['nomeLista']),
            subtitle: Text(
              '📍 ${lista['nomeLocal'] ?? 'Local não informado'}\n'
              '🏠 ${lista['endereco'] ?? '-'}\n'
              '🏷 ${item.tipo}\n'
              '📅 $dataFormatada\n'
              '🛒 $quantidadeItens itens\n'
              '💰 Total: ${formatoMoeda.format(lista['total'])}',
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => _excluirLista(item),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatoMoeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
    );
    final formatoData = DateFormat('dd/MM/yyyy');
    final listas = _obterListasDoPeriodo();
    final grupos = _agruparPorTipo(listas);
    final tipoSelecionado = _tipoSelecionado;

    return PopScope<void>(
      canPop: tipoSelecionado == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && tipoSelecionado != null) {
          setState(() {
            _tipoSelecionado = null;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: tipoSelecionado == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _tipoSelecionado = null;
                    });
                  },
                ),
          title: Text(tipoSelecionado ?? '📋 Minhas Listas'),
        ),
        body: Column(
          children: [
            _construirFiltros(),
            Expanded(
              child: tipoSelecionado == null
                  ? _construirPastas(listas, grupos)
                  : _construirListas(
                      grupos[tipoSelecionado] ?? const [],
                      formatoMoeda,
                      formatoData,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
