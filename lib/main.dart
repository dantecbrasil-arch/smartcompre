import 'package:flutter/material.dart';
import 'screens/produtos_screen.dart';
import 'screens/categorias_screen.dart';
import 'screens/listas_screen.dart';
import 'data/listas_repository.dart';
import 'data/catalogo/catalogo_repository.dart';
import 'data/catalogo/categorias_repository.dart';
import 'pages/estabelecimentos_page.dart';
import 'models/estabelecimento.dart';
import 'repositorios/estabelecimentos_repository.dart';
import 'screens/manual_usuario_screen.dart';

String _normalizarNomeLista(String valor) {
  final texto = valor
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ')
      .toLowerCase();

  if (texto.isEmpty) {
    return '';
  }

  final resultado = StringBuffer();
  var primeiraLetraCapitalizada = false;

  for (final rune in texto.runes) {
    final caractere = String.fromCharCode(rune);
    final ehLetra =
        caractere.toLowerCase() != caractere.toUpperCase();

    if (!primeiraLetraCapitalizada && ehLetra) {
      resultado.write(caractere.toUpperCase());
      primeiraLetraCapitalizada = true;
    } else {
      resultado.write(caractere);
    }
  }

  return resultado.toString();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ListasRepository.carregarListas();

await CatalogoRepository.instance
    .carregarCatalogo();

await CategoriasRepository.carregar();

runApp(const SmartCompreApp());
}

class SmartCompreApp extends StatelessWidget {
  const SmartCompreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCompre',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController localController =
      TextEditingController();

  final TextEditingController listaController =
      TextEditingController();
      Estabelecimento? estabelecimentoSelecionado;

  @override
  void dispose() {
    localController.dispose();
    listaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habilitarCriacao =
        localController.text.trim().isNotEmpty &&
        listaController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCompre'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.shopping_cart,
                  size: 130,
                  color: Colors.green,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Bem-vindo ao SmartCompre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: localController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Estabelecimento',
                     border: OutlineInputBorder(),
                     prefixIcon: Icon(Icons.store),
                     suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () async {
                    final estabelecimento =
                        await Navigator.push<Estabelecimento>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const EstabelecimentosPage(),
                      ),
                    );

                    if (estabelecimento != null) {
                      setState(() {
                        estabelecimentoSelecionado =
                            estabelecimento;

                        localController.text =
                            estabelecimento.nome;
                      });
                    }
                  },
                  ),

                  if (estabelecimentoSelecionado != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 12,
                        bottom: 8,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '📍 ${estabelecimentoSelecionado!.endereco}\n'
                          '🏷 ${estabelecimentoSelecionado!.tipo}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),


                const SizedBox(height: 15),

                TextField(
                  controller: listaController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Lista',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.list_alt),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: 250,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: habilitarCriacao
    ? () async {

        final estabelecimentoEscolhido =
            estabelecimentoSelecionado;
        Estabelecimento? estabelecimentoAtualizado;

        if (estabelecimentoEscolhido != null) {
          final estabelecimentos =
              await EstabelecimentosRepository().carregar();

          if (!context.mounted) return;

          for (final estabelecimento in estabelecimentos) {
            if (estabelecimento.id ==
                estabelecimentoEscolhido.id) {
              estabelecimentoAtualizado =
                  estabelecimento;
              break;
            }
          }

          if (estabelecimentoAtualizado == null) {
            setState(() {
              estabelecimentoSelecionado = null;
              localController.clear();
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Estabelecimento não encontrado. '
                  'Selecione-o novamente.',
                ),
              ),
            );
            return;
          }

          setState(() {
            estabelecimentoSelecionado =
                estabelecimentoAtualizado;
            localController.text =
                estabelecimentoAtualizado!.nome;
          });
        }

        final nomeLocal =
            estabelecimentoAtualizado?.nome ??
            localController.text.trim();
        final endereco =
            estabelecimentoAtualizado?.endereco ?? '';
        final tipoLista =
            estabelecimentoAtualizado?.tipo ?? '';
        final tipoProdutos =
            estabelecimentoAtualizado?.tipo ?? 'Outros';
        final nomeLista =
            _normalizarNomeLista(listaController.text);

        final listaId =
            DateTime.now().millisecondsSinceEpoch;

        ListasRepository.listasSalvas.add({
          'id': listaId,

  'nomeLocal': nomeLocal,

  'endereco': endereco,

  'tipo': tipoLista,

  'nomeLista': nomeLista,

  'data': DateTime.now().toIso8601String(),

  'total': 0.0,

  'produtos': [],
});

        await ListasRepository.salvarListas();

        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProdutosScreen(
              listaId: listaId,
              nomeLocal: nomeLocal,
              nomeLista: nomeLista,
              tipoEstabelecimento: tipoProdutos,
            ),
          ),
        );
      }
    : null,
                    child: const Text(
                      '🛒 Criar Lista',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 250,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ListasScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '📋 Minhas Listas',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),

               const SizedBox(height: 20),

               SizedBox(
                 width: 250,
                 height: 60,
                 child: ElevatedButton(
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (_) =>
                             const CategoriasScreen(),
                        ),
                      );
                   },
                   child: const Text(
                     '⚙ Categorias',
                     style: TextStyle(
                       fontSize: 22,
                     ),
                   ),
                 ),
               ),

               const SizedBox(height: 20),

               SizedBox(
                 width: 250,
                 height: 60,
                 child: ElevatedButton(
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (_) =>
                             const ManualUsuarioScreen(),
                       ),
                     );
                   },
                   child: const Text(
                     'Ajuda / Manual do Usuário',
                     textAlign: TextAlign.center,
                   ),
                 ),
               ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}