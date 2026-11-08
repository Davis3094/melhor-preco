import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dados/repositorio.dart';
import 'firebase_config.dart';
import 'models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Repositorio repo = RepositorioLocal();
  if (usarFirebase) {
    await Firebase.initializeApp(options: opcoes);
    repo = RepositorioFirestore();
    if (popularNaInicializacao) {
      // Em segundo plano: se o banco não existir/estiver bloqueado, o app abre assim mesmo.
      repo
          .popular()
          .timeout(const Duration(seconds: 20))
          .then((_) => debugPrint('Firestore populado com os dados de exemplo.'))
          .catchError((e) => debugPrint('Falha ao popular o Firestore: $e'));
    }
  }
  runApp(MelhorPrecoApp(repositorio: repo));
}

class MelhorPrecoApp extends StatelessWidget {
  final Repositorio repositorio;
  const MelhorPrecoApp({super.key, required this.repositorio});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'O Melhor Preço',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B7F4B)),
        useMaterial3: true,
      ),
      home: BuscaPage(repositorio: repositorio),
    );
  }
}

/// Jornada da PoC (Persona 1 – Carlos): localização → pesquisa → comparação.
class BuscaPage extends StatefulWidget {
  final Repositorio repositorio;
  const BuscaPage({super.key, required this.repositorio});

  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  final _cep = TextEditingController();
  final _busca = TextEditingController();
  List<Produto> _produtos = [];
  bool _carregando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _pesquisar();
  }

  Future<void> _pesquisar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final r = await widget.repositorio.buscarProdutos(_busca.text);
      if (mounted) setState(() => _produtos = r);
    } catch (e) {
      if (mounted) setState(() => _erro = 'Não foi possível carregar os produtos.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O Melhor Preço'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1. Sua localização',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _cep,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CEP (opcional na PoC)',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('2. Pesquise um produto',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _busca,
                  onChanged: (_) => _pesquisar(),
                  decoration: const InputDecoration(
                    labelText: 'Ex.: arroz, leite, café',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(child: _lista()),
                Text('Fonte dos dados: ${widget.repositorio.origem}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lista() {
    if (_carregando) return const Center(child: CircularProgressIndicator());
    if (_erro != null) return Center(child: Text(_erro!));
    if (_produtos.isEmpty) {
      return const Center(child: Text('Nenhum produto encontrado.'));
    }
    return ListView.separated(
      itemCount: _produtos.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final p = _produtos[i];
        return ListTile(
          title: Text(p.nome),
          subtitle: Text(p.categoria),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ComparacaoPage(repositorio: widget.repositorio, produto: p),
            ),
          ),
        );
      },
    );
  }
}

class ComparacaoPage extends StatefulWidget {
  final Repositorio repositorio;
  final Produto produto;
  const ComparacaoPage({super.key, required this.repositorio, required this.produto});

  @override
  State<ComparacaoPage> createState() => _ComparacaoPageState();
}

class _ComparacaoPageState extends State<ComparacaoPage> {
  OrdenarPor _ordem = OrdenarPor.preco;
  late Future<List<ResultadoComparacao>> _futuro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    _futuro = widget.repositorio.comparar(widget.produto.id, ordenarPor: _ordem);
  }

  String _reais(double v) => 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto.nome),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('3. Compare os preços',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SegmentedButton<OrdenarPor>(
                  segments: const [
                    ButtonSegment(value: OrdenarPor.preco, label: Text('Menor preço')),
                    ButtonSegment(value: OrdenarPor.distancia, label: Text('Mais perto')),
                  ],
                  selected: {_ordem},
                  onSelectionChanged: (s) => setState(() {
                    _ordem = s.first;
                    _carregar();
                  }),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder<List<ResultadoComparacao>>(
                    future: _futuro,
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return const Center(child: Text('Erro ao carregar os preços.'));
                      }
                      final lista = snap.data!;
                      if (lista.isEmpty) {
                        return const Center(child: Text('Preço indisponível para este produto.'));
                      }
                      final menor = lista.map((r) => r.preco.valor).reduce((a, b) => a < b ? a : b);
                      final maior = lista.map((r) => r.preco.valor).reduce((a, b) => a > b ? a : b);
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                for (final r in lista) _cartao(r, r.preco.valor == menor),
                              ],
                            ),
                          ),
                          Text('Economia comparando o mais caro com o mais barato: ${_reais(maior - menor)}',
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cartao(ResultadoComparacao r, bool melhor) {
    final cor = Theme.of(context).colorScheme;
    return Card(
      color: melhor ? cor.primaryContainer : null,
      child: ListTile(
        leading: Icon(melhor ? Icons.emoji_events : Icons.store),
        title: Text(r.supermercado.nome),
        subtitle: Text(
            '${r.supermercado.bairro} • ${r.supermercado.distanciaKm.toStringAsFixed(1).replaceAll('.', ',')} km'
            '${r.preco.promocao ? ' • Promoção' : ''}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_reais(r.preco.valor),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (melhor) const Text('Melhor preço', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
