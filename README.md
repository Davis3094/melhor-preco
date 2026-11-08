# O Melhor Preço — Prova de Conceito (2ª entrega)

Projeto Integrador · Senac EAD · Análise e Desenvolvimento de Sistemas · 2026

## Integrantes
- Cássia Gonçalves de Souza
- Lucas Vilar D'Avis
- Matheus de Oliveira Matos
- Oseias Gonçalves dos Santos
- Rafael Ferreira Rodrigues Alfredo
- Rayany Isabelle Antunes

## 1. Revisita do projeto e definição da PoC

**Projeto:** aplicativo Mobile/Web que compara preços de produtos entre supermercados de uma região (sem venda, pagamento ou entrega).

**Risco principal:** o valor do app depende de o consumidor conseguir, em poucos passos, achar onde um produto está mais barato. Funcionalidades como leitura de código de barras, GPS e cadastro de usuário dependem de serviços externos e não provam essa hipótese.

**Jornada escolhida (Persona 1 – Carlos Silva, etapas 3 a 5 da jornada):** informar localização → pesquisar produto → comparar preços entre supermercados.

**Hipótese da PoC:** o usuário consegue ir de "quero um produto" até "sei qual supermercado tem o menor preço" em menos de 3 telas e em poucos segundos.

**Mudança em relação à 1ª entrega (justificada):** a 1ª entrega previa localização por GPS ou CEP. Na PoC a distância é um dado fixo por supermercado, porque a geolocalização não é necessária para validar a hipótese de comparação. GPS/CEP, lista de compras, código de barras e cadastro de supermercados ficam para a versão final.

## 2. Arquitetura

```
Flutter (Web)  ──►  Repositorio (interface)
                       ├─ RepositorioLocal      → dados de exemplo em memória
                       └─ RepositorioFirestore  → Cloud Firestore (nuvem)
```

- **Frontend:** Flutter 3 / Material 3 (`lib/main.dart`).
- **Backend e dados:** Cloud Firestore, com coleções `supermercados`, `produtos` e `precos` (`lib/dados/repositorio.dart`).
- **Dados de exemplo:** 4 supermercados, 6 produtos, 22 preços (`lib/dados/seed.dart`).
- A interface só conhece a classe `Repositorio`, então trocar entre modo local e nuvem não altera as telas.

### Modelagem de dados
| Coleção | Campos |
|---|---|
| `supermercados` | nome, bairro, distanciaKm |
| `produtos` | nome, categoria |
| `precos` | produtoId, supermercadoId, valor, promocao |

## 3. Como executar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) e Edge ou Chrome.

```bash
flutter pub get
flutter test
flutter run -d edge
```

Por padrão o app roda em **modo local**, sem precisar de nuvem.

### Ativar o Cloud Firestore (modo nuvem)
1. Crie um projeto em https://console.firebase.google.com.
2. Adicione um app **Web** e copie as chaves (`apiKey`, `appId`, `messagingSenderId`, `projectId`).
3. Cole as chaves em `lib/firebase_config.dart` e troque `usarFirebase` para `true`.
4. No console, crie o banco **Firestore** em modo de teste.
5. Rode o app e carregue os dados de exemplo uma vez (chame `repositorio.popular()`, por exemplo em um botão temporário ou no `main`).

## 4. Testes
`flutter test` executa 3 testes: ordenação por menor preço, busca sem acento/caixa e a jornada completa (buscar → comparar).

## 5. Estrutura de pastas
```
lib/
  main.dart               telas (busca e comparação)
  models.dart             Supermercado, Produto, Preco
  firebase_config.dart    chaves do Firebase e chave liga/desliga
  dados/
    repositorio.dart      acesso a dados (local e Firestore)
    seed.dart             dados de exemplo
test/widget_test.dart
```

## 6. Roteiro do vídeo (máx. 1 minuto)
1. (0–10 s) "Esse é o O Melhor Preço. Vou mostrar a jornada do Carlos para achar o supermercado mais barato."
2. (10–25 s) Digitar "arroz" na busca e mostrar a lista filtrando.
3. (25–45 s) Abrir o produto e mostrar os preços ordenados, com o selo "Melhor preço" e a economia.
4. (45–55 s) Alternar para "Mais perto".
5. (55–60 s) Mostrar o repositório no GitHub e encerrar.
