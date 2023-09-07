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
                return TarjetaConTexto(
                  numero: numero,
                  texto: texto,
                  onDelete: () {
                    // Lógica para eliminar el texto
                    textManager.deleteText(index);
                  },
                  onEdit: () {
                    // Lógica para editar el texto
                    _showEditDialog(context, textManager, index, texto);
                  },
                );
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

  void _showEditDialog(
    BuildContext context,
    TextManager textManager,
    int index,
    String currentText,
  ) {
    TextEditingController _editingController = TextEditingController();
    _editingController.text = currentText;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Texto"),
          content: TextField(
            controller: _editingController,
            decoration: InputDecoration(hintText: "Nuevo Texto"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Actualiza el texto en la lista con el nuevo valor
                textManager.texts[index] = _editingController.text;
                textManager.notifyListeners();
                Navigator.pop(context);
              },
              child: Text("Guardar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}

class TarjetaConTexto extends StatelessWidget {
  final int numero;
  final String texto;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  TarjetaConTexto({
    required this.numero,
    required this.texto,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              '$numero - ',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}