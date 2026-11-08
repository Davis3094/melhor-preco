import 'package:cloud_firestore/cloud_firestore.dart';

import '../models.dart';
import 'seed.dart';

enum OrdenarPor { preco, distancia }

/// Contrato de acesso aos dados. A interface não sabe se os dados vêm da
/// memória (modo local) ou do Firestore (nuvem).
abstract class Repositorio {
  String get origem;

  Future<List<Produto>> buscarProdutos(String termo);

  Future<List<ResultadoComparacao>> comparar(
    String produtoId, {
    OrdenarPor ordenarPor = OrdenarPor.preco,
  });

  /// Carga inicial: grava os dados de exemplo (usado só com Firestore).
  Future<void> popular() async {}
}

String _normalizar(String s) => s
    .toLowerCase()
    .replaceAll(RegExp('[áàâã]'), 'a')
    .replaceAll(RegExp('[éê]'), 'e')
    .replaceAll('í', 'i')
    .replaceAll(RegExp('[óôõ]'), 'o')
    .replaceAll('ú', 'u')
    .replaceAll('ç', 'c');

List<ResultadoComparacao> _ordenar(List<ResultadoComparacao> l, OrdenarPor o) {
  l.sort((a, b) => o == OrdenarPor.preco
      ? a.preco.valor.compareTo(b.preco.valor)
      : a.supermercado.distanciaKm.compareTo(b.supermercado.distanciaKm));
  return l;
}

/// Modo local: usa os dados de seed em memória. Permite rodar a PoC sem nuvem.
class RepositorioLocal extends Repositorio {
  @override
  String get origem => 'Dados locais (demonstração)';

  @override
  Future<List<Produto>> buscarProdutos(String termo) async {
    final t = _normalizar(termo.trim());
    if (t.isEmpty) return produtosSeed;
    return produtosSeed.where((p) => _normalizar(p.nome).contains(t)).toList();
  }

  @override
  Future<List<ResultadoComparacao>> comparar(String produtoId,
      {OrdenarPor ordenarPor = OrdenarPor.preco}) async {
    final lista = <ResultadoComparacao>[];
    for (final p in precosSeed.where((p) => p.produtoId == produtoId)) {
      final s = supermercadosSeed.firstWhere((s) => s.id == p.supermercadoId);
      lista.add(ResultadoComparacao(s, p));
    }
    return _ordenar(lista, ordenarPor);
  }
}

/// Modo nuvem: lê e grava no Cloud Firestore.
/// Coleções: `supermercados`, `produtos`, `precos`.
class RepositorioFirestore extends Repositorio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  String get origem => 'Cloud Firestore';

  @override
  Future<List<Produto>> buscarProdutos(String termo) async {
    final snap = await _db.collection('produtos').get();
    final todos = snap.docs.map((d) => Produto.fromMap(d.id, d.data())).toList();
    final t = _normalizar(termo.trim());
    if (t.isEmpty) return todos;
    return todos.where((p) => _normalizar(p.nome).contains(t)).toList();
  }

  @override
  Future<List<ResultadoComparacao>> comparar(String produtoId,
      {OrdenarPor ordenarPor = OrdenarPor.preco}) async {
    final precos = await _db
        .collection('precos')
        .where('produtoId', isEqualTo: produtoId)
        .get();
    final lista = <ResultadoComparacao>[];
    for (final d in precos.docs) {
      final preco = Preco.fromMap(d.data());
      final s = await _db.collection('supermercados').doc(preco.supermercadoId).get();
      if (s.exists) {
        lista.add(ResultadoComparacao(Supermercado.fromMap(s.id, s.data()!), preco));
      }
    }
    return _ordenar(lista, ordenarPor);
  }

  @override
  Future<void> popular() async {
    final batch = _db.batch();
    for (final s in supermercadosSeed) {
      batch.set(_db.collection('supermercados').doc(s.id), s.toMap());
    }
    for (final p in produtosSeed) {
      batch.set(_db.collection('produtos').doc(p.id), p.toMap());
    }
    for (final p in precosSeed) {
      batch.set(_db.collection('precos').doc('${p.produtoId}__${p.supermercadoId}'), p.toMap());
    }
    await batch.commit();
  }
}
