import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BeRichAppState extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _receitasTables = [];
  List<Map<String, dynamic>> _despesasTables = [];

  List<Map<String, dynamic>> get receitasTables => _receitasTables;
  List<Map<String, dynamic>> get despesasTables => _despesasTables;

  // Carregar dados do Firestore
  Future<void> loadTables() async {
    try {
      final receitasSnapshot = await _firestore.collection('receitas').get();
      final despesasSnapshot = await _firestore.collection('despesas').get();

      _receitasTables = receitasSnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Adicionando o ID do documento para futuras operações
          'nome': doc['nome'],
          'expensas': List<Map<String, dynamic>>.from(doc['expensas'])
        };
      }).toList();

      _despesasTables = despesasSnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Adicionando o ID do documento para futuras operações
          'nome': doc['nome'],
          'expensas': List<Map<String, dynamic>>.from(doc['expensas'])
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Erro ao carregar dados: $e");
    }
  }

  // Salvar dados no Firestore
  Future<void> _saveReceitasTables() async {
    final batch = _firestore.batch();

    for (var tabela in _receitasTables) {
      var docRef = _firestore.collection('receitas').doc(tabela['id'] ?? '');
      batch.set(docRef, tabela);
    }

    await batch.commit();
  }

  Future<void> _saveDespesasTables() async {
    final batch = _firestore.batch();

    for (var tabela in _despesasTables) {
      var docRef = _firestore.collection('despesas').doc(tabela['id'] ?? '');
      batch.set(docRef, tabela);
    }

    await batch.commit();
  }

  // Funções para adicionar e remover tabelas e receitas/despesas
  void addReceitasTable(String nome) {
    var docRef = _firestore.collection('receitas').doc();
    _receitasTables.add({
      'id': docRef.id,
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
    _saveReceitasTables();
  }

  void removeReceitasTable(int tableIndex) async {
    var tableId = _receitasTables[tableIndex]['id'];
    _receitasTables.removeAt(tableIndex);
    notifyListeners();
    await _firestore.collection('receitas').doc(tableId).delete();
    _saveReceitasTables();
  }

  void addReceita(int tableIndex, String nome, double valor) {
    _receitasTables[tableIndex]['expensas'].add({
      'nome': nome,
      'valor': valor,
      'paga': false,
    });
    notifyListeners();
    _saveReceitasTables();
  }

  void removeReceita(int tableIndex, int rowIndex) {
    _receitasTables[tableIndex]['expensas'].removeAt(rowIndex);
    notifyListeners();
    _saveReceitasTables();
  }

  void toggleReceitaPaga(int tableIndex, int rowIndex) {
    _receitasTables[tableIndex]['expensas'][rowIndex]['paga'] =
    !_receitasTables[tableIndex]['expensas'][rowIndex]['paga'];
    notifyListeners();
    _saveReceitasTables();
  }

  void addDespesasTable(String nome) {
    var docRef = _firestore.collection('despesas').doc();
    _despesasTables.add({
      'id': docRef.id,
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
    _saveDespesasTables();
  }

  void removeDespesasTable(int tableIndex) async {
    var tableId = _despesasTables[tableIndex]['id'];
    _despesasTables.removeAt(tableIndex);
    notifyListeners();
    await _firestore.collection('despesas').doc(tableId).delete();
    _saveDespesasTables();
  }

  void addDespesa(int tableIndex, String nome, double valor) {
    _despesasTables[tableIndex]['expensas'].add({
      'nome': nome,
      'valor': valor,
      'paga': false,
    });
    notifyListeners();
    _saveDespesasTables();
  }

  void removeDespesa(int tableIndex, int rowIndex) {
    _despesasTables[tableIndex]['expensas'].removeAt(rowIndex);
    notifyListeners();
    _saveDespesasTables();
  }

  void toggleDespesaPaga(int tableIndex, int rowIndex) {
    _despesasTables[tableIndex]['expensas'][rowIndex]['paga'] =
    !_despesasTables[tableIndex]['expensas'][rowIndex]['paga'];
    notifyListeners();
    _saveDespesasTables();
  }

  // Calcular totais
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
