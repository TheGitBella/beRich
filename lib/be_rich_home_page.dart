import 'package:be_rich_app/tab_controle_ideal.dart';
import 'package:be_rich_app/tab_creditos.dart';
import 'package:be_rich_app/tab_dashboard.dart';
import 'package:be_rich_app/tab_despesas_fixas.dart';
import 'package:be_rich_app/tab_dividas.dart';
import 'package:be_rich_app/tab_extrato_mensal.dart';
import 'package:be_rich_app/tab_investimentos.dart';
import 'package:be_rich_app/tab_metas.dart';
import 'package:be_rich_app/tab_receitas_fixas.dart';
import 'package:be_rich_app/tab_resumo_mensal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'be_rich_app_state.dart';

class BeRichHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<BeRichAppState>();

    return DefaultTabController(
      length: 11,
      child: Scaffold(
        appBar: AppBar(
          title: Text('beRich'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.deepOrange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.deepOrange,
                tabs: [
                  Tab(icon: Icon(Icons.bar_chart), text: 'Dashboard'),
                  Tab(icon: Icon(Icons.home), text: 'Receitas Fixas'),
                  Tab(icon: Icon(Icons.money_off), text: 'Despesas Fixas'),
                  Tab(icon: Icon(Icons.assessment), text: 'Controle Ideal'),
                  Tab(icon: Icon(Icons.flag), text: 'Metas'),
                  Tab(icon: Icon(Icons.show_chart), text: 'Investimentos'),
                  Tab(icon: Icon(Icons.credit_card), text: 'Dívidas'),
                  Tab(icon: Icon(Icons.credit_score), text: 'Créditos'),
                  Tab(icon: Icon(Icons.list), text: 'Extrato Mensal'),
                  Tab(icon: Icon(Icons.pie_chart), text: 'Resumo Mensal'),
                  Tab(icon: Icon(Icons.settings), text: 'Configurações'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            TabDashboard(),
            TabReceitasFixas(),
            TabDespesasFixas(),
            TabControleIdeal(),
            TabMetas(),
            TabInvestimentos(),
            TabDividas(),
            TabCreditos(),
            TabExtratoMensal(),
            TabResumoMensal(),
            Center(child: Text('Conteúdo da Aba Configurações')),
          ],
        ),
      ),
    );
  }
}
