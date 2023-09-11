import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/providers/text_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:flutter/services.dart';


class PrincipalPage extends StatelessWidget {
  const PrincipalPage({Key? key}) : super(key: key);

 Future<void> _generateAndOpenPDF(BuildContext context, List<String> texts) async {
  final doc = pw.Document();
  final logo = pw.Container(
      height: 150,
      alignment: pw.Alignment.centerLeft,
      child: pw.Image(
        pw.ImageProxy(
          PdfImage.file(
            doc.document,
            bytes: (await rootBundle.load("assets/p.png")).buffer.asUint8List(),
          ),
        ),
      ),
    ); 

 doc.addPage(
      pw.Page(
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(text: "Credencial"), // titulo
              logo, // tu foto
              ...texts.map((text) => pw.Container(
        margin: pw.EdgeInsets.only(bottom: 10.0), // Espacio vertical entre textos
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 20,
          ),
        ),
      )).toList(),
            ],
          );
        },
      ),
    ); 


  final directory = await getTemporaryDirectory();

  final bytes = await doc.save();

  final newPath = await showDialog<String>(
    context: context,
    builder: (context) {
      TextEditingController fileNameController = TextEditingController();
      return AlertDialog(
        title: Text("Editar Nombre de Guardado"),
        content: TextField(
          controller: fileNameController,
          decoration: InputDecoration(hintText: "Nombre de archivo"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              String enteredFileName = fileNameController.text.trim();
              if (!enteredFileName.endsWith('.pdf')) {
                enteredFileName += '.pdf'; // Agregar extensión si no la tiene
              }
              Navigator.pop(context, enteredFileName);
            },
            child: Text("Guardar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text("Cancelar"),
          ),
        ],
      );
    },
  );

  if  (newPath != null) {
    final file = File("${directory.path}/$newPath");
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
  } else {
    final file = File("${directory.path}/text_pdf.pdf");
    OpenFile.open(file.path);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Textos capturados"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf_rounded),
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
                    textManager.deleteText(index);
                  },
                  onEdit: () {
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