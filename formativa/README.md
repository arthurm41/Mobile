# Mapa de Locais

Aplicativo Flutter para pesquisar estabelecimentos por cidade e categoria, consultar detalhes e administrar registros armazenados no Cloud Firestore.

## Objetivo e requisitos

O aplicativo atende à situação proposta na avaliação: selecionar cidades, pesquisar locais, filtrar resultados, abrir detalhes, favoritar e realizar operações de cadastro, edição e exclusão.

| Código | Funcionalidade | Implementação |
|---|---|---|
| RF01 | Selecionar cidade | São Paulo, Campinas e Jundiaí na tela principal |
| RF02 | Pesquisar por nome ou categoria | Pesquisa na tela principal e nos resultados |
| RF03 | Consultar Firestore | Stream de documentos da coleção `locais` |
| RF04 | Filtrar cidade e categoria | Filtros aplicados aos documentos recebidos |
| RF05–RF07 | Cadastrar, editar e excluir | Formulário em Bottom Sheet; exclusão confirmada |
| RF08–RF09 | Detalhes e favoritos | Tela de detalhes; favorito atualizado no Firestore |
| RF10 | Navegação | Mapa, resultados e detalhes |

O projeto usa Flutter/Dart, `firebase_core` e `cloud_firestore`. A representação do mapa é ilustrativa; um mapa real é uma extensão opcional da atividade.

## Organização

- `lib/models/local.dart`: modelo, conversão Firestore e filtros.
- `lib/services/local_service.dart`: leitura e operações CRUD.
- `lib/screens/`: mapa, resultados e detalhes.
- `lib/widgets/`: formulário e cartão de resultado.
- `lib/dialogs/`: confirmação de exclusão.

## Modelo Firestore

Coleção: `locais`. Cada documento deve conter:

| Campo | Tipo |
|---|---|
| `nome` | String |
| `categoria` | String |
| `cidade` | String |
| `avaliacao` | Number, entre 0 e 5 |
| `distancia` | Number, igual ou maior que 0 |
| `horario` | String |
| `descricao` | String |
| `favorito` | Boolean |

O ID do documento é usado como `Local.id`. O cadastro usa `add()`, a leitura usa `snapshots()`, edição e favoritos usam `update()`, e a exclusão usa `delete()`.

## Configuração Firebase necessária

**A configuração incluída neste repositório ainda contém valores de demonstração e não conecta a um projeto Firebase real.** Para usar o Firestore:

1. Crie ou selecione um projeto no Firebase Console e habilite o Cloud Firestore.
2. Instale e autentique a Firebase CLI; instale a FlutterFire CLI (`dart pub global activate flutterfire_cli`).
3. Na pasta deste projeto, execute `flutterfire configure` e selecione o projeto e a plataforma Android. O comando deve gerar as opções reais em `lib/firebase_options.dart`.
4. No Firebase Console, crie a coleção `locais` e cadastre documentos de exemplo para testar a leitura.
5. Configure regras de segurança apropriadas ao projeto. Não publique regras abertas de teste.
6. Execute `flutter pub get` e `flutter run` em um dispositivo Android.

Sem essa configuração, o aplicativo apresenta a falha de inicialização ou de leitura em vez de tratar o banco como uma lista vazia. As credenciais do Firebase precisam vir do projeto do responsável e não podem ser inventadas neste código.

## Validação local

Execute na pasta do projeto:

```powershell
flutter analyze
flutter test
flutter build apk
```

Testes automatizados incluídos: filtros de texto/cidade/categoria, interface em caso de falha do Firebase e validação de avaliação e distância.

## Roteiro de testes com Firebase

Os casos abaixo precisam ser executados após conectar o projeto Firebase; não são declarados como aprovados apenas pelos testes automatizados.

| ID | Procedimento | Resultado |
|---|---|---|
| T01 | Abrir o aplicativo e verificar documentos do Firestore | Pendente de Firebase real |
| T02 | Pesquisar por “Academia” | Pendente de Firebase real |
| T03 | Selecionar Campinas | Pendente de Firebase real |
| T04 | Filtrar por categoria | Pendente de Firebase real |
| T05 | Cadastrar e confirmar documento no Firestore | Pendente de Firebase real |
| T06 | Reabrir resultados e conferir persistência | Pendente de Firebase real |
| T07 | Editar nome ou horário | Pendente de Firebase real |
| T08 | Excluir com confirmação | Pendente de Firebase real |
| T09 | Marcar e desmarcar favorito | Pendente de Firebase real |
| T10 | Navegar entre mapa, resultados e detalhes | Pendente de Firebase real |
| T11 | Simular erro de conexão e conferir mensagem | Erro local coberto por teste; falta validar no Android |

## Entrega da avaliação

Após configurar e testar o Firebase, complete a entrega com pelo menos dez documentos em `locais`, evidências das três telas, uma captura do Firestore com os documentos e o resultado dos testes manuais. Não foram incluídas capturas nem evidências de acesso ao Firebase porque dependem do projeto e do dispositivo do responsável.
