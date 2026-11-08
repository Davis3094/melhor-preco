import 'package:firebase_core/firebase_core.dart';

/// Configuração do Firebase (chaves públicas de configuração do app Web).
///
/// Enquanto [usarFirebase] for false, o app roda em modo local (sem nuvem).
/// Veja o README.md para o passo a passo de criação do projeto.
const bool usarFirebase = true;

/// Se true, grava os dados de exemplo no Firestore ao iniciar.
/// Use uma vez para popular o banco e depois volte para false.
const bool popularNaInicializacao = false;

const FirebaseOptions opcoes = FirebaseOptions(
  apiKey: 'AIzaSyBj8nVH2Tu9xthZOLG6IE5J9VGKoi4ebJM',
  authDomain: 'melhor-preco-97058.firebaseapp.com',
  projectId: 'melhor-preco-97058',
  storageBucket: 'melhor-preco-97058.firebasestorage.app',
  messagingSenderId: '945961075693',
  appId: '1:945961075693:web:e14eb3038753379d90dde4',
);
