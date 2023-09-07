import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/providers/text_manager.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Texto capturado"),
      ),
      body: Center(
        child: Consumer<TextManager>(
          builder: (context, textManager, child) => Text(textManager.text),
          
        ),
      ),
    );
  }
}