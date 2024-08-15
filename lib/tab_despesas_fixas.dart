import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'be_rich_app_state.dart';

class TabDespesasFixas extends StatefulWidget {
  @override
  _TabDespesasFixasState createState() => _TabDespesasFixasState();
}

class _TabDespesasFixasState extends State<TabDespesasFixas> {

  Future<void> _showAddTableDialog() async {
    TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Novo Tipo de Despesa'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Digite o Tipo de Despesa'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Provider.of<BeRichAppState>(context, listen: false)
                      .addDespesasTable(nameController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddExpenseDialog(int tableIndex) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Nova Despesa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Nome da despesa'),
              ),
              TextField(
                controller: valueController,
                decoration: InputDecoration(hintText: 'Valor da despesa'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                double value = double.tryParse(valueController.text) ?? 0.0;
                if (nameController.text.isNotEmpty && value > 0) {
                  Provider.of<BeRichAppState>(context, listen: false)
                      .addDespesa(tableIndex, nameController.text, value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final theme = Theme.of(context);
    final tableBorderColor = theme.primaryColor;
    final backgroundColor = theme.primaryColor;
    final iconColor = Colors.white;

    List<Map<String, dynamic>> tables = Provider.of<BeRichAppState>(context).despesasTables;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: _showAddTableDialog,
                  style: TextButton.styleFrom(
                    backgroundColor: tableBorderColor,
                  ),
                  child: Text(
                    'Adicionar Tipo de Despesa',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            ...tables.asMap().entries.map((entry) {
              int tableIndex = entry.key;
              Map<String, dynamic> table = entry.value;
              List<Map<String, dynamic>> expenses = table['expensas'];

              double total = expenses.fold(0.0, (sum, item) => sum + item['valor']);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        table['nome'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: tableBorderColor),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          Provider.of<BeRichAppState>(context, listen: false)
                              .removeDespesasTable(tableIndex);
                        },
                        tooltip: 'Remover Tabela',
                        color: tableBorderColor,
                      ),
                    ],
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
                            child: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold, color: tableBorderColor)),
                          ),
                        ],
                      ),
                      ...expenses.asMap().entries.map((rowEntry) {
                        int rowIndex = rowEntry.key;
                        Map<String, dynamic> row = rowEntry.value;
                        bool isPaid = row['paga'];

                        return TableRow(
                          decoration: BoxDecoration(
                            color: isPaid ? Colors.grey[300] : Colors.transparent,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                row['nome'],
                                style: TextStyle(
                                  decoration: isPaid ? TextDecoration.lineThrough : TextDecoration.none,
                                  color: isPaid ? Colors.grey[700] : Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                currencyFormatter.format(row['valor']),
                                style: TextStyle(
                                  decoration: isPaid ? TextDecoration.lineThrough : TextDecoration.none,
                                  color: isPaid ? Colors.grey[700] : Colors.black,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: isPaid,
                                  onChanged: (value) {
                                    Provider.of<BeRichAppState>(context, listen: false)
                                        .toggleDespesaPaga(tableIndex, rowIndex);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    Provider.of<BeRichAppState>(context, listen: false)
                                        .removeDespesa(tableIndex, rowIndex);
                                  },
                                  tooltip: 'Remover Despesa',
                                  color: tableBorderColor,
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                      TableRow(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'TOTAL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                backgroundColor: backgroundColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              currencyFormatter.format(total),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                backgroundColor: backgroundColor,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.add_circle_outline, color: iconColor),
                                onPressed: () => _showAddExpenseDialog(tableIndex),
                                tooltip: 'Adicionar Despesa',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
