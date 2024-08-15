import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'be_rich_app_state.dart';

class TabDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BeRichAppState>(
      builder: (context, appState, child) {
        // Calcular totais por categoria (receitas e despesas)
        Map<String, double> receitasPorCategoria = appState.calcularTotalReceitasPorCategoria();
        Map<String, double> despesasPorCategoria = appState.calcularTotalDespesasPorCategoria();

        // Calcular totais
        double totalReceitas = receitasPorCategoria.values.fold(0, (prev, value) => prev + value);
        double totalDespesas = despesasPorCategoria.values.fold(0, (prev, value) => prev + value);

        // Cores para o gráfico
        final List<Color> coresReceitas = [Colors.lightGreenAccent];
        final List<Color> coresDespesas = [Colors.redAccent];

        // Criar dados para os gráficos de pizza
        List<PieChartSectionData> dadosReceitas = receitasPorCategoria.entries.map((entry) {
          int index = receitasPorCategoria.entries.toList().indexOf(entry);
          double porcentagem = (entry.value / totalReceitas) * 100;
          return PieChartSectionData(
            value: entry.value,
            title: '${entry.key}\n${porcentagem.toStringAsFixed(1)}%',
            color: coresReceitas[index % coresReceitas.length],
            radius: 130,
            borderSide: BorderSide(color: Colors.white, width: 2),
            titleStyle: TextStyle(
              fontSize: 14, // Aumente o tamanho do texto da porcentagem
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

        List<PieChartSectionData> dadosDespesas = despesasPorCategoria.entries.map((entry) {
          int index = despesasPorCategoria.entries.toList().indexOf(entry);
          double porcentagem = (entry.value / totalDespesas) * 100;
          return PieChartSectionData(
            value: entry.value,
            title: '${entry.key}\n${porcentagem.toStringAsFixed(1)}%',
            color: coresDespesas[index % coresDespesas.length],
            radius: 130,
            borderSide: BorderSide(color: Colors.white, width: 2),
            titleStyle: TextStyle(
              fontSize: 14, // Aumente o tamanho do texto da porcentagem
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

        Widget legenda(List<MapEntry<String, double>> entradas, List<Color> cores) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entradas.asMap().entries.map((entry) {
              int index = entry.key;
              var categoria = entry.value.key;
              var valor = entry.value.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0), // Adicione um espaçamento vertical
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: cores[index % cores.length],
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$categoria: R\$ ${valor.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Receitas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  height: 300, // Aumente a altura do container
                  child: PieChart(
                    PieChartData(
                      sections: dadosReceitas,
                      centerSpaceRadius: 0,
                      sectionsSpace: 0,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                legenda(receitasPorCategoria.entries.toList(), coresReceitas),
                SizedBox(height: 20),
                Text(
                  'Despesas',
                  style: TextStyle(
                    fontSize: 20, // Ajuste o tamanho do título, se necessário
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: dadosDespesas,
                      centerSpaceRadius: 0,
                      sectionsSpace: 0,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                legenda(despesasPorCategoria.entries.toList(), coresDespesas),
              ],
            ),
          ),
        );
      },
    );
  }
}
