import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'dart:developer';
import 'package:provider/provider.dart'; // Importa Provider
import 'package:prueba/presentation/Screens/principal_page.dart';
import 'package:prueba/providers/text_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( ChangeNotifierProvider(
      create: (context) => TextManager(), // Crea una instancia de TextManager
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget es la raíz de tu aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Scalable OCR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Consumer<TextManager>(
        builder: (context, textManager, child) => CameraPage(textManager: textManager),
      ),
      routes:{  'principal': (context) => const PrincipalPage(),

        }
    );
  }
}

class CameraPage extends StatefulWidget {
  final TextManager textManager;

  const CameraPage({Key? key, required this.textManager}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escanear"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ScalableOCR(
                paintboxCustom: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4.0
                  ..color = const Color.fromARGB(153, 102, 160, 241),
                boxLeftOff: 5,
                boxBottomOff: 2.5,
                boxRightOff: 5,
                boxTopOff: 2.5,
                boxHeight: MediaQuery.of(context).size.height / 3,
                getRawData: (value) {
                  inspect(value);
                },
                getScannedText: (value) {
                  text = value;
                }),
            Text(text),
            ElevatedButton(
  onPressed: () {
    // Guardar el texto en la variable $text
    widget.textManager.setText(text);
    // Navegar a la otra pantalla
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrincipalPage(),
      ),
    );
  },
  child: Text("Guardar"),
),
const SizedBox( height: 30),
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, 'principal');
  },
  child: Text('Escaneos')
  
  ),
          ],
        ),
      ),
    );
  }
}