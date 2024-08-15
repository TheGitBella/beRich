import 'package:be_rich_app/be_rich_home_page.dart';
import 'package:be_rich_app/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'be_rich_app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BeRichApp());
}

class BeRichApp extends StatelessWidget {
  const BeRichApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BeRichAppState(),
      child: MaterialApp(
        title: 'beRich',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: LoginPage(),
        routes: {
          '/home': (context) => BeRichHomePage(),
        },
      ),
    );
  }
}
