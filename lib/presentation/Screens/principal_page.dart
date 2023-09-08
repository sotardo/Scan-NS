import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/providers/text_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart'; // Importa esta línea para abrir el archivo
import 'dart:io';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  Future<void> _generateAndOpenPDF(BuildContext context, List<String> texts) async {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return texts.map((text) => pw.Text(text)).toList();
      },
    ));

    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/text_pdf.pdf");

    // Añade esta línea de código
    final bytes = await doc.save();

    // Cambia esta línea de código
    // await file.writeAsBytes(doc.save());
    // a esta línea de código
   final newPath = "${directory.path}/my_pdf.pdf";
  await file.rename(newPath);
  await file.writeAsBytes(bytes);

    // Abrir el PDF generado con la aplicación predeterminada
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Textos capturados"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              final textManager = Provider.of<TextManager>(context, listen: false);
              _generateAndOpenPDF(context, textManager.texts);
              
            },
          ),
        ],
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
