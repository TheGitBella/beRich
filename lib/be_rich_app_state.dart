import 'package:flutter/material.dart';

class BeRichAppState extends ChangeNotifier {
  // Lista para armazenar as tabelas de receitas
  List<Map<String, dynamic>> _receitasTables = [];
  List<Map<String, dynamic>> _despesasTables = [];

  // Getter para acessar as tabelas de receitas
  List<Map<String, dynamic>> get receitasTables => _receitasTables;
  List<Map<String, dynamic>> get despesasTables => _despesasTables;

  // Função para adicionar uma nova tabela de receitas
  void addReceitasTable(String nome) {
    _receitasTables.add({
      'nome': nome,
      'expensas': [
        {
          'nome': '',
          'valor': 0.0,
          'paga': false,
        }
      ],
    });
    notifyListeners();
  }

  // Função para remover uma tabela de receitas
  void removeReceitasTable(int tableIndex) {
    _receitasTables.removeAt(tableIndex);
    notifyListeners();
  }

  // Função para adicionar uma nova receita a uma tabela existente
  void addReceita(int tableIndex, String nome, double valor) {
    _receitasTables[tableIndex]['expensas'].add({
      'nome': nome,
      'valor': valor,
      'paga': false,
    });
    notifyListeners();
  }

  // Função para remover uma receita de uma tabela existente
  void removeReceita(int tableIndex, int rowIndex) {
    _receitasTables[tableIndex]['expensas'].removeAt(rowIndex);
    notifyListeners();
  }

  // Função para alternar o estado de pagamento de uma receita
  void toggleReceitaPaga(int tableIndex, int rowIndex) {
    _receitasTables[tableIndex]['expensas'][rowIndex]['paga'] =
    !_receitasTables[tableIndex]['expensas'][rowIndex]['paga'];
    notifyListeners();
  }

  // Função para adicionar uma nova tabela de despesas
  void addDespesasTable(String nome) {
    _despesasTables.add({
      'nome': nome,
      'expensas': [
        {
          'nome': '',
          'valor': 0.0,
          'paga': false,
        }
      ],
    });
    notifyListeners();
  }

  // Função para remover uma tabela de despesas
  void removeDespesasTable(int tableIndex) {
    _despesasTables.removeAt(tableIndex);
    notifyListeners();
  }

  // Função para adicionar uma nova despesa a uma tabela existente
  void addDespesa(int tableIndex, String nome, double valor) {
    _despesasTables[tableIndex]['expensas'].add({
      'nome': nome,
      'valor': valor,
      'paga': false,
    });
    notifyListeners();
  }

  // Função para remover uma despesa de uma tabela existente
  void removeDespesa(int tableIndex, int rowIndex) {
    _despesasTables[tableIndex]['expensas'].removeAt(rowIndex);
    notifyListeners();
  }

  // Função para alternar o estado de pagamento de uma despesa
  void toggleDespesaPaga(int tableIndex, int rowIndex) {
    _despesasTables[tableIndex]['expensas'][rowIndex]['paga'] =
    !_despesasTables[tableIndex]['expensas'][rowIndex]['paga'];
    notifyListeners();
  }

  // Calcular total de receitas por categoria
  Map<String, double> calcularTotalReceitasPorCategoria() {
    Map<String, double> totaisPorCategoria = {};

    for (var tabela in _receitasTables) {
      String categoria = tabela['nome'];
      double totalCategoria = 0.0;

      for (var receita in tabela['expensas']) {
        if (!receita['paga']) {
          totalCategoria += receita['valor'];
        }
      }

      if (totalCategoria > 0) {
        totaisPorCategoria[categoria] = totalCategoria;
      }
    }

    return totaisPorCategoria;
  }

  // Calcular total de despesas por categoria
  Map<String, double> calcularTotalDespesasPorCategoria() {
    Map<String, double> totaisPorCategoria = {};

    for (var tabela in _despesasTables) {
      String categoria = tabela['nome'];
      double totalCategoria = 0.0;

      for (var despesa in tabela['expensas']) {
        if (!despesa['paga']) {
          totalCategoria += despesa['valor'];
        }
      }

      if (totalCategoria > 0) {
        totaisPorCategoria[categoria] = totalCategoria;
      }
    }

    return totaisPorCategoria;
  }
}
