import '../models.dart';

/// Dados de exemplo usados na PoC (modo local e carga inicial do Firestore).
const supermercadosSeed = <Supermercado>[
  Supermercado(id: 'mercado-central', nome: 'Mercado Central', bairro: 'Centro', distanciaKm: 1.2),
  Supermercado(id: 'super-bairro', nome: 'Super do Bairro', bairro: 'Vila Nova', distanciaKm: 0.6),
  Supermercado(id: 'economia-total', nome: 'Economia Total', bairro: 'Jardim das Flores', distanciaKm: 2.8),
  Supermercado(id: 'hiper-popular', nome: 'Hiper Popular', bairro: 'Parque Industrial', distanciaKm: 4.1),
];

const produtosSeed = <Produto>[
  Produto(id: 'arroz-5kg', nome: 'Arroz Tipo 1 5kg', categoria: 'Mercearia'),
  Produto(id: 'feijao-1kg', nome: 'Feijão Carioca 1kg', categoria: 'Mercearia'),
  Produto(id: 'leite-1l', nome: 'Leite Integral 1L', categoria: 'Laticínios'),
  Produto(id: 'cafe-500g', nome: 'Café Torrado 500g', categoria: 'Mercearia'),
  Produto(id: 'oleo-900ml', nome: 'Óleo de Soja 900ml', categoria: 'Mercearia'),
  Produto(id: 'acucar-1kg', nome: 'Açúcar Refinado 1kg', categoria: 'Mercearia'),
];

const precosSeed = <Preco>[
  // Arroz
  Preco(produtoId: 'arroz-5kg', supermercadoId: 'mercado-central', valor: 29.90),
  Preco(produtoId: 'arroz-5kg', supermercadoId: 'super-bairro', valor: 31.50),
  Preco(produtoId: 'arroz-5kg', supermercadoId: 'economia-total', valor: 27.90, promocao: true),
  Preco(produtoId: 'arroz-5kg', supermercadoId: 'hiper-popular', valor: 28.75),
  // Feijão
  Preco(produtoId: 'feijao-1kg', supermercadoId: 'mercado-central', valor: 7.99),
  Preco(produtoId: 'feijao-1kg', supermercadoId: 'super-bairro', valor: 8.49),
  Preco(produtoId: 'feijao-1kg', supermercadoId: 'economia-total', valor: 7.49),
  Preco(produtoId: 'feijao-1kg', supermercadoId: 'hiper-popular', valor: 7.29, promocao: true),
  // Leite
  Preco(produtoId: 'leite-1l', supermercadoId: 'mercado-central', valor: 5.49),
  Preco(produtoId: 'leite-1l', supermercadoId: 'super-bairro', valor: 5.29),
  Preco(produtoId: 'leite-1l', supermercadoId: 'economia-total', valor: 4.99, promocao: true),
  Preco(produtoId: 'leite-1l', supermercadoId: 'hiper-popular', valor: 5.19),
  // Café
  Preco(produtoId: 'cafe-500g', supermercadoId: 'mercado-central', valor: 22.90),
  Preco(produtoId: 'cafe-500g', supermercadoId: 'super-bairro', valor: 24.50),
  Preco(produtoId: 'cafe-500g', supermercadoId: 'economia-total', valor: 21.90),
  // Óleo
  Preco(produtoId: 'oleo-900ml', supermercadoId: 'mercado-central', valor: 6.99),
  Preco(produtoId: 'oleo-900ml', supermercadoId: 'super-bairro', valor: 7.49),
  Preco(produtoId: 'oleo-900ml', supermercadoId: 'hiper-popular', valor: 6.59),
  // Açúcar
  Preco(produtoId: 'acucar-1kg', supermercadoId: 'mercado-central', valor: 4.99),
  Preco(produtoId: 'acucar-1kg', supermercadoId: 'super-bairro', valor: 5.39),
  Preco(produtoId: 'acucar-1kg', supermercadoId: 'economia-total', valor: 4.59),
  Preco(produtoId: 'acucar-1kg', supermercadoId: 'hiper-popular', valor: 4.49, promocao: true),
];
