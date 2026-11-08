import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melhor_preco/dados/repositorio.dart';
import 'package:melhor_preco/main.dart';

void main() {
  test('comparação ordena do menor para o maior preço', () async {
    final r = await RepositorioLocal().comparar('arroz-5kg');
    expect(r.first.supermercado.id, 'economia-total');
    expect(r.first.preco.valor, 27.90);
    for (var i = 1; i < r.length; i++) {
      expect(r[i].preco.valor >= r[i - 1].preco.valor, isTrue);
    }
  });

  test('busca ignora acentos e maiúsculas', () async {
    final r = await RepositorioLocal().buscarProdutos('CAFE');
    expect(r.single.id, 'cafe-500g');
  });

  testWidgets('jornada: buscar produto e ver comparação', (tester) async {
    await tester.pumpWidget(MelhorPrecoApp(repositorio: RepositorioLocal()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'leite');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leite Integral 1L'));
    await tester.pumpAndSettle();
    expect(find.text('Economia Total'), findsOneWidget);
    expect(find.text('Melhor preço'), findsOneWidget);
  });
}
