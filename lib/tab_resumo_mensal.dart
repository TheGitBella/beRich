import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'be_rich_app_state.dart';

class TabResumoMensal extends StatefulWidget {
  @override
  _TabResumoMensalState createState() => _TabResumoMensalState();
}

class _TabResumoMensalState extends State<TabResumoMensal> {
  Map<String, bool> localExpenseStates = {}; // Para despesas
  Map<String, bool> localIncomeStates = {};   // Para receitas

  @override
  Widget build(BuildContext context) {
    final BeRichAppState appState = Provider.of<BeRichAppState>(context);
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final theme = Theme.of(context);
    final tableBorderColor = theme.primaryColor;

    // Consolidar todas as despesas em uma lista
    List<Map<String, dynamic>> allExpenses = [];
    appState.despesasTables.forEach((table) {
      List<Map<String, dynamic>> expenses = table['expensas'];
      expenses.forEach((expense) {
        allExpenses.add({
          'nome': expense['nome'],
          'valor': expense['valor'],
          'categoria': table['nome'], // Nome da tabela como categoria
          'paga': expense['paga'],
        });
      });
    });

    // Consolidar todas as receitas em uma lista
    List<Map<String, dynamic>> allIncomes = [];
    appState.receitasTables.forEach((table) {
      List<Map<String, dynamic>> incomes = table['expensas'];
      incomes.forEach((income) {
        allIncomes.add({
          'nome': income['nome'],
          'valor': income['valor'],
          'categoria': table['nome'], // Nome da tabela como categoria
          'recebido': income['recebido'] ?? false, // Adicionando o campo 'recebido'
        });
      });
    });

    // Inicializa o estado local dos checkboxes para despesas e receitas, se ainda não foi feito
    if (localExpenseStates.isEmpty) {
      for (var expense in allExpenses) {
        localExpenseStates[expense['nome']] = expense['paga'];
      }
    }
    if (localIncomeStates.isEmpty) {
      for (var income in allIncomes) {
        localIncomeStates[income['nome']] = income['recebido'];
      }
    }

    // Calcula os totais e totais restantes
    double totalExpenses = _calculateTotal(allExpenses);
    double totalIncomes = _calculateTotal(allIncomes);
    double totalRemainingExpenses = allExpenses
        .where((expense) => !(localExpenseStates[expense['nome']] ?? false))
        .fold(0.0, (sum, item) => sum + item['valor']);

    double totalRemainingIncomes = allIncomes
        .where((income) => !(localIncomeStates[income['nome']] ?? false)) // Receitas são consideradas recebidas por padrão
        .fold(0.0, (sum, item) => sum + item['valor']);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Resumo Mensal',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: tableBorderColor),
              ),
            ),
            // Tabela de Despesas
            Text(
              'Despesas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: tableBorderColor),
            ),
            Table(
              border: TableBorder.all(color: tableBorderColor),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Valor', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Categoria', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Recebido', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                    ),
                  ],
                ),
                ...allExpenses.map((expense) {
                  bool isPaid = localExpenseStates[expense['nome']] ?? false;

                  return TableRow(
                    decoration: BoxDecoration(
                      color: isPaid ? Colors.grey[300] : Colors.transparent,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          expense['nome'],
                          style: TextStyle(
                            decoration: isPaid ? TextDecoration.lineThrough : TextDecoration.none,
                            color: isPaid ? Colors.grey[700] : Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          currencyFormatter.format(expense['valor']),
                          style: TextStyle(
                            decoration: isPaid ? TextDecoration.lineThrough : TextDecoration.none,
                            color: isPaid ? Colors.grey[700] : Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(expense['categoria']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Checkbox(
                          value: isPaid,
                          onChanged: (bool? value) {
                            setState(() {
                              localExpenseStates[expense['nome']] = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            // Linha de Total Geral e Total Não Pago para Despesas
            _buildTotalRow('Total Geral Despesas', totalExpenses, tableBorderColor),
            _buildTotalRow('Total Não Pago', totalRemainingExpenses, tableBorderColor),
            SizedBox(height: 16.0),
            // Tabela de Receitas
            Text(
              'Receitas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: tableBorderColor),
            ),
            Table(
              border: TableBorder.all(color: tableBorderColor),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Valor', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Categoria', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Recebido', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                    ),
                  ],
                ),
                ...allIncomes.map((income) {
                  bool isReceived = localIncomeStates[income['nome']] ?? false;

                  return TableRow(
                    decoration: BoxDecoration(
                      color: isReceived ? Colors.grey[300] : Colors.transparent,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          income['nome'],
                          style: TextStyle(
                            decoration: isReceived ? TextDecoration.lineThrough : TextDecoration.none,
                            color: isReceived ? Colors.grey[700] : Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          currencyFormatter.format(income['valor']),
                          style: TextStyle(
                            decoration: isReceived ? TextDecoration.lineThrough : TextDecoration.none,
                            color: isReceived ? Colors.grey[700] : Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(income['categoria']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Checkbox(
                          value: isReceived,
                          onChanged: (bool? value) {
                            setState(() {
                              localIncomeStates[income['nome']] = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            // Linha de Total Geral e Total Não Recebido para Receitas
            _buildTotalRow('Total Geral Receitas', totalIncomes, tableBorderColor),
            _buildTotalRow('Total Não Recebido', totalRemainingIncomes, tableBorderColor),
          ],
        ),
      ),
    );
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold(0.0, (sum, item) => sum + item['valor']);
  }

  Widget _buildTotalRow(String label, double amount, Color borderColor) {
    return Container(
      color: borderColor,
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            NumberFormat.simpleCurrency(locale: 'pt_BR').format(amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
