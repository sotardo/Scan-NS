import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/providers/text_manager.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Textos capturados"),
      ),
      body: Center(
        child: Consumer<TextManager>(
          builder: (context, textManager, child) => ListView.builder(
            itemCount: textManager.texts.length,
            itemBuilder: (context, index) => Text(textManager.texts[index]),
          ),
        ),
      ),
    );
  }
}