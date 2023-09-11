import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:prueba/presentation/Screens/principal_page.dart';
import 'package:prueba/providers/text_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TextManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Scalable OCR',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Consumer<TextManager>(
        builder: (context, textManager, child) =>
            CameraPage(textManager: textManager),
      ),
      routes: {
        'principal': (context) => const PrincipalPage(),
      },
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
        title: Text("Escaneo"),
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
              },
            ),
            Text(text),
            ElevatedButton(
              onPressed: () {
                widget.textManager.setText(text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrincipalPage(),
                  ),
                );
              },
              style:ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0 ), // Ajusta el padding según tus preferencias
              ),
             ),
              child: Icon(Icons.camera_alt_outlined)
            ),
            const SizedBox(height: 100),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'principal');
              },
              style:ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 80.0, vertical: 5.0 ), // Ajusta el padding según tus preferencias
              ),
             ),
              child: Text('Ir a Escaneos',
              style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}