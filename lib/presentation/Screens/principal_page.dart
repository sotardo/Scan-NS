import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/providers/text_manager.dart';

class Texto {
  final String texto;

  Texto({required this.texto});
}

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Textos capturados"),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer<TextManager>(
          builder: (context, textManager, child) {
            final texts = textManager.texts;
            final itemCount = texts.length;
            return ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final numero = index + 1;
                final texto = texts[index];
                return TarjetaConTexto(numero: numero, texto: texto);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.add),
        ),
    );
  }
}

class TarjetaConTexto extends StatelessWidget {
  final int numero;
  final String texto;

  TarjetaConTexto({required this.numero, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              '$numero - ',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 12), // Agrega un espacio adicional entre el número y el texto
            Expanded(
              child: Text(
                texto,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}