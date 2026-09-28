//Hugo Pereira malaquias RGM: 11251102309

import 'dart:io';

abstract class Exibivel {
  void exibirInformacoes();
}

abstract class ItemBiblioteca implements Exibivel {
  final int id;
  final String titulo;
  final int anoPublicacao;

  ItemBiblioteca(this.id, this.titulo, this.anoPublicacao);
}

class Livro extends ItemBiblioteca {
  final String autor;
  final String categoria;

  Livro(int id, String titulo, int anoPublicacao, this.autor, this.categoria)
    : super(id, titulo, anoPublicacao);

  @override
  void exibirInformacoes() {
    print('[Livro]');
    print('ID: $id');
    print('Título: $titulo');
    print('Autor: $autor');
    print('Ano: $anoPublicacao');
    print('Categoria: $categoria');
  }
}

class Revista extends ItemBiblioteca {
  final int numeroEdicao;

  Revista(int id, String titulo, int anoPublicacao, this.numeroEdicao)
    : super(id, titulo, anoPublicacao);

  @override
  void exibirInformacoes() {
    print('[Revista]');
    print('ID: $id');
    print('Título: $titulo');
    print('Ano: $anoPublicacao');
    print('Edição: $numeroEdicao');
  }
}

class Usuario {
  final int id;
  final String nome;
  final String email;

  int _quantidadeEmprestimos = 0;

  Usuario(this.id, this.nome, this.email);

  int get quantidadeEmprestimos => _quantidadeEmprestimos;

  bool adicionarEmprestimo() {
    if (_quantidadeEmprestimos >= 3) {
      return false;
    }

    _quantidadeEmprestimos++;
    return true;
  }

  bool removerEmprestimo() {
    if (_quantidadeEmprestimos <= 0) {
      return false;
    }

    _quantidadeEmprestimos--;
    return true;
  }

  void exibirInformacoes() {
    print('ID: $id');
    print('Nome: $nome');
    print('E-mail: $email');
    print('Empréstimos ativos: $_quantidadeEmprestimos');
  }
}

class Biblioteca {
  static const int anoMinimo = 1000;
  static const int anoMaximo = 2026;

  // esta armazenanfo itens e usuários.
  final List<ItemBiblioteca> _itens = <ItemBiblioteca>[];
  final List<Usuario> _usuarios = <Usuario>[];

  final Map<int, Set<int>> _emprestimosPorUsuario = <int, Set<int>>{};

  final Set<String> _categorias = <String>{};

  ItemBiblioteca? _buscarItemPorId(int id) {
    for (final item in _itens) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  Usuario? _buscarUsuarioPorId(int id) {
    for (final usuario in _usuarios) {
      if (usuario.id == id) {
        return usuario;
      }
    }
    return null;
  }

  bool _itemEstaEmprestado(int itemId) {
    return _emprestimosPorUsuario.values.any(
      (itensEmprestados) => itensEmprestados.contains(itemId),
    );
  }

  int? _buscarUsuarioResponsavelPeloItem(int itemId) {
    for (final entrada in _emprestimosPorUsuario.entries) {
      if (entrada.value.contains(itemId)) {
        return entrada.key;
      }
    }
    return null;
  }

  bool _anoValido(int ano) {
    return ano >= anoMinimo && ano <= anoMaximo;
  }

  void _adicionarCategoriaSemDuplicar(String categoria) {
    final bool jaExiste = _categorias.any(
      (existente) => existente.toLowerCase() == categoria.toLowerCase(),
    );

    if (!jaExiste) {
      _categorias.add(categoria);
    }
  }

  void cadastrarLivro() {
    print('\n========== CADASTRO DE LIVRO ==========');

    final int? id = lerInt('ID: ');
    if (id == null || id <= 0) {
      print('ID inválido. Informe um número inteiro positivo.');
      return;
    }

    if (_buscarItemPorId(id) != null) {
      print('Já existe um item com esse ID.');
      return;
    }

    final String titulo = lerTexto('Título: ');
    if (titulo.isEmpty) {
      print('O título não pode ser vazio.');
      return;
    }

    final String autor = lerTexto('Autor: ');
    if (autor.isEmpty) {
      print('O autor não pode ser vazio.');
      return;
    }

    final int? ano = lerInt('Ano de publicação: ');
    if (ano == null || !_anoValido(ano)) {
      print('Ano inválido. Informe um ano entre $anoMinimo e $anoMaximo.');
      return;
    }

    final String categoria = lerTexto('Categoria: ');
    if (categoria.isEmpty) {
      print('A categoria não pode ser vazia.');
      return;
    }

    final livro = Livro(id, titulo, ano, autor, categoria);
    _itens.add(livro);
    _adicionarCategoriaSemDuplicar(categoria);

    print('Livro cadastrado com sucesso.');
  }

  void cadastrarRevista() {
    print('\n========== CADASTRO DE REVISTA ==========');

    final int? id = lerInt('ID: ');
    if (id == null || id <= 0) {
      print('ID inválido. Informe um número inteiro positivo.');
      return;
    }

    if (_buscarItemPorId(id) != null) {
      print('Já existe um item com esse ID.');
      return;
    }

    final String titulo = lerTexto('Título: ');
    if (titulo.isEmpty) {
      print('O título não pode ser vazio.');
      return;
    }

    final int? ano = lerInt('Ano de publicação: ');
    if (ano == null || !_anoValido(ano)) {
      print('Ano inválido. Informe um ano entre $anoMinimo e $anoMaximo.');
      return;
    }

    final int? edicao = lerInt('Número da edição: ');
    if (edicao == null || edicao <= 0) {
      print('Número de edição inválido.');
      return;
    }

    final revista = Revista(id, titulo, ano, edicao);
    _itens.add(revista);

    print('Revista cadastrada com sucesso.');
  }

  void cadastrarUsuario() {
    print('\n========== CADASTRO DE USUÁRIO ==========');

    final int? id = lerInt('ID: ');
    if (id == null || id <= 0) {
      print('ID inválido. Informe um número inteiro positivo.');
      return;
    }

    if (_buscarUsuarioPorId(id) != null) {
      print('Já existe um usuário com esse ID.');
      return;
    }

    final String nome = lerTexto('Nome: ');
    if (nome.isEmpty) {
      print('O nome não pode ser vazio.');
      return;
    }

    final String email = lerTexto('E-mail: ');
    if (email.isEmpty) {
      print('O e-mail não pode ser vazio.');
      return;
    }

    _usuarios.add(Usuario(id, nome, email));
    print('Usuário cadastrado com sucesso.');
  }

  void listarItens() {
    print('\n========== ITENS ==========');

    if (_itens.isEmpty) {
      print('Nenhum item cadastrado.');
      return;
    }

    for (final item in _itens) {
      item.exibirInformacoes();
      print(
        'Status: ${_itemEstaEmprestado(item.id) ? 'Emprestado' : 'Disponível'}',
      );
      print('----------------------------');
    }
  }

  void listarUsuarios() {
    print('\n========== USUÁRIOS ==========');

    if (_usuarios.isEmpty) {
      print('Nenhum usuário cadastrado.');
      return;
    }

    for (final usuario in _usuarios) {
      usuario.exibirInformacoes();
      print('----------------------------');
    }
  }

  void realizarEmprestimo() {
    print('\n========== REALIZAR EMPRÉSTIMO ==========');

    final int? usuarioId = lerInt('ID do usuário: ');
    if (usuarioId == null) {
      print('ID de usuário inválido.');
      return;
    }

    final Usuario? usuario = _buscarUsuarioPorId(usuarioId);
    if (usuario == null) {
      print('Usuário não encontrado.');
      return;
    }

    final int? itemId = lerInt('ID do item: ');
    if (itemId == null) {
      print('ID de item inválido.');
      return;
    }

    final ItemBiblioteca? item = _buscarItemPorId(itemId);
    if (item == null) {
      print('Item não encontrado.');
      return;
    }

    if (_itemEstaEmprestado(itemId)) {
      print('Este item já está emprestado.');
      return;
    }

    if (usuario.quantidadeEmprestimos >= 3) {
      print('Usuário atingiu o limite de empréstimos.');
      return;
    }

    final bool contadorAtualizado = usuario.adicionarEmprestimo();
    if (!contadorAtualizado) {
      print('Usuário atingiu o limite de empréstimos.');
      return;
    }

    final Set<int> itensDoUsuario = _emprestimosPorUsuario.putIfAbsent(
      usuario.id,
      () => <int>{},
    );
    itensDoUsuario.add(item.id);

    print('Empréstimo realizado com sucesso.');
  }

  void realizarDevolucao() {
    print('\n========== REALIZAR DEVOLUÇÃO ==========');

    final int? itemId = lerInt('ID do item: ');
    if (itemId == null) {
      print('ID de item inválido.');
      return;
    }

    final int? usuarioId = _buscarUsuarioResponsavelPeloItem(itemId);
    if (usuarioId == null) {
      print('Este item não possui empréstimo ativo.');
      return;
    }

    final Usuario? usuario = _buscarUsuarioPorId(usuarioId);
    if (usuario == null) {
      print('Erro: usuário responsável não encontrado.');
      return;
    }

    final Set<int>? itensDoUsuario = _emprestimosPorUsuario[usuarioId];
    if (itensDoUsuario == null) {
      print('Este item não possui empréstimo ativo.');
      return;
    }

    itensDoUsuario.remove(itemId);
    usuario.removerEmprestimo();

    if (itensDoUsuario.isEmpty) {
      _emprestimosPorUsuario.remove(usuarioId);
    }

    print('Devolução realizada com sucesso.');
  }

  void buscarItens() {
    print('\n========== BUSCAR ITENS ==========');
    print('1 - Buscar por título');
    print('2 - Buscar livros por categoria');

    final int? opcao = lerInt('Escolha uma opção: ');

    switch (opcao) {
      case 1:
        buscarPorTitulo();
        break;
      case 2:
        buscarPorCategoria();
        break;
      default:
        print('Opção inválida.');
    }
  }

  void buscarPorTitulo() {
    final String termo = lerTexto('Digite parte do título: ').toLowerCase();

    if (termo.isEmpty) {
      print('Informe um termo para a busca.');
      return;
    }

    // where(): filtranfo apenas os itens cujo título contém tal termo
    final List<ItemBiblioteca> encontrados = _itens
        .where((item) => item.titulo.toLowerCase().contains(termo))
        .toList();

    if (encontrados.isEmpty) {
      print('Nenhum item encontrado.');
      return;
    }

    final List<String> resumo = encontrados
        .map((item) => '${item.id} - ${item.titulo}')
        .toList();

    print('\nResultados:');
    for (final linha in resumo) {
      print(linha);
    }

    print('\nDetalhes:');
    for (final item in encontrados) {
      item.exibirInformacoes();
      print('----------------------------');
    }
  }

  void buscarPorCategoria() {
    final String termo = lerTexto('Digite a categoria: ').toLowerCase();

    if (termo.isEmpty) {
      print('Informe uma categoria.');
      return;
    }

    final List<Livro> encontrados = _itens
        .whereType<Livro>()
        .where((livro) => livro.categoria.toLowerCase() == termo)
        .toList();

    if (encontrados.isEmpty) {
      print('Nenhum livro encontrado nessa categoria.');
      return;
    }

    for (final livro in encontrados) {
      livro.exibirInformacoes();
      print('----------------------------');
    }
  }

  void gerarRelatorio() {
    print('\n========== RELATÓRIO DA BIBLIOTECA ==========');

    final List<Livro> livros = _itens.whereType<Livro>().toList();
    final List<Revista> revistas = _itens.whereType<Revista>().toList();

    // fold(): soma a quantidade de itens emprestados de todos os usuários.
    final int emprestimosAtivos = _emprestimosPorUsuario.values.fold<int>(
      0,
      (soma, itens) => soma + itens.length,
    );

    print('Total de itens: ${_itens.length}');
    print('Livros: ${livros.length}');
    print('Revistas: ${revistas.length}');
    print('Usuários cadastrados: ${_usuarios.length}');
    print('Empréstimos ativos: $emprestimosAtivos');

    if (livros.isEmpty) {
      print('Ano médio dos livros: não disponível');
      print('Livro mais antigo: não disponível');
      print('Livro mais recente: não disponível');
    } else {
      // map() + fold(): extrai os anos e soma todos eles.
      final int somaAnos = livros
          .map((livro) => livro.anoPublicacao)
          .fold<int>(0, (soma, ano) => soma + ano);

      final double anoMedio = somaAnos / livros.length;

      // reduce(): compara os livros até restar o mais antigo e o mais recente.
      final Livro maisAntigo = livros.reduce(
        (atual, proximo) =>
            atual.anoPublicacao <= proximo.anoPublicacao ? atual : proximo,
      );

      final Livro maisRecente = livros.reduce(
        (atual, proximo) =>
            atual.anoPublicacao >= proximo.anoPublicacao ? atual : proximo,
      );

      print('Ano médio dos livros: ${anoMedio.toStringAsFixed(1)}');
      print(
        'Livro mais antigo: ${maisAntigo.titulo} - ${maisAntigo.anoPublicacao}',
      );
      print(
        'Livro mais recente: ${maisRecente.titulo} - ${maisRecente.anoPublicacao}',
      );
    }

    if (_usuarios.isEmpty) {
      print('Usuário com mais empréstimos: não disponível');
    } else {
      final Usuario usuarioComMaisEmprestimos = _usuarios.reduce(
        (atual, proximo) =>
            atual.quantidadeEmprestimos >= proximo.quantidadeEmprestimos
            ? atual
            : proximo,
      );

      print(
        'Usuário com mais empréstimos: '
        '${usuarioComMaisEmprestimos.nome} - '
        '${usuarioComMaisEmprestimos.quantidadeEmprestimos} empréstimo(s)',
      );
    }

    if (_categorias.isEmpty) {
      print('Categorias cadastradas: nenhuma');
    } else {
      print('Categorias cadastradas: ${_categorias.join(', ')}');
    }
  }
}

String lerTexto(String mensagem) {
  stdout.write(mensagem);
  final String? entrada = stdin.readLineSync();

  // Null Safety: readLineSync pode retornar null.
  return entrada?.trim() ?? '';
}

int? lerInt(String mensagem) {
  final String entrada = lerTexto(mensagem);

  if (entrada.isEmpty) {
    return null;
  }

  return int.tryParse(entrada);
}

void mostrarMenu() {
  print('''

       Sistema Bibliotteca


1 - Cadastrar livro
2 - Cadastrar revista
3 - Cadastrar usuário
4 - Listar itens
5 - Listar usuários
6 - Realizar empréstimo
7 - Realizar devolução
8 - Buscar itens
9 - Relatório da biblioteca
0 - Sair
''');
}

void main() {
  final Biblioteca biblioteca = Biblioteca();

  while (true) {
    mostrarMenu();
    final int? opcao = lerInt('Escolha uma opção: ');

    switch (opcao) {
      case 1:
        biblioteca.cadastrarLivro();
        break;
      case 2:
        biblioteca.cadastrarRevista();
        break;
      case 3:
        biblioteca.cadastrarUsuario();
        break;
      case 4:
        biblioteca.listarItens();
        break;
      case 5:
        biblioteca.listarUsuarios();
        break;
      case 6:
        biblioteca.realizarEmprestimo();
        break;
      case 7:
        biblioteca.realizarDevolucao();
        break;
      case 8:
        biblioteca.buscarItens();
        break;
      case 9:
        biblioteca.gerarRelatorio();
        break;
      case 0:
        print('Sistema encerrado.');
        return;
      default:
        print('Opção inválida.');
    }
  }
}
