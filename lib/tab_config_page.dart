import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_page.dart';

class TabConfigPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      print('Erro ao deslogar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o usuário atual
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user?.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
            SizedBox(height: 20),
            if (user?.displayName != null)
              Text(
                user!.displayName!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            if (user?.email != null)
              Text(
                user!.email!,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: Text('Deslogar'),
            ),
          ],
        ),
      ),
    );
  }
}
