import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:connectivity/connectivity.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "QR Generator",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  get onTextSubmitted => null;

  @override
  State<Inicio> createState() => _InicioState();
}

String? finalTipo = 'URL';
String? finalShape = 'square';
String? finalColor = '#FF0000';
String? finalFormato = 'png';
String? finalData = '';
final data = TextEditingController();
Map<String, dynamic>? payload;
Uri url = Uri.parse("https://api.qrcode-monkey.com/qr/custom");

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "QR Generator",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TipoQR(onTipoSelected: (String? tipo) {
            setState(() {
              finalTipo = tipo;
              print('Valor seleccionado para Color: $finalTipo');
            });
          }),
          Forma(
            onShapeSelected: (String? forma) {
              setState(() {
                finalShape = forma;
              });
              print('Valor seleccionado: $forma');
            },
          ),
          ColorSelector(
            onColorSelected: (String? color) {
              setState(() {
                finalColor = _convertirColorHex(color);
              });
              print('Valor seleccionado para Color: $finalColor');
            },
          ),
          Formato(
            onFormatoSelected: (String? formato) {
              setState(() {
                finalFormato = formato;
              });
              print('Valor seleccionado para formato: $formato');
            },
          ),
          //DataQR
          TextField(
              controller: data,
              decoration: InputDecoration(hintText: 'Ingrese texto')),
          SizedBox(height: 20),
          Center(
            child: Boton(
              onPressed: () {
                finalData = data.text;
                if (finalData?.isNotEmpty ?? false) {
                   crearJSON();
                 // verificarConexionInternet().then((conectado) {
                 //   if (conectado) {
                //     print('Hay conexión a Internet.');
                //   //} else {
                //      print('No hay conexión a Internet.');
                 //   }
                 // });
                  enviarSolicitud();
                } else {
                  print('El texto no puede estar vacío.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.blue,
                      content: Text(
                        'El texto no puede estar vacío.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
String _convertirColorHex(String? nombreColor) {
  print('Color recibido: $nombreColor');
  switch (nombreColor) {
    case 'Rojo':
      return '#FF0000';
    case 'Azul':
      return '#0000FF';
    case 'Verde':
      return '#00FF00';
    case 'Negro':
      return '#000000';
    default:
      // Si el color no se encuentra en la lista, puedes devolver un valor predeterminado o lanzar una excepción
      return '#000000'; // Color blanco como valor predeterminado
  }
}

class Boton extends StatelessWidget {
  final VoidCallback onPressed;

  const Boton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      ),
      child: Text(
        'Enviar',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

void crearJSON() {
  payload = {
    "data": finalData,
    "config": {
      "body": finalShape,
      "eye": "frame0",
      "eyeBall": "ball7",
      "bodyColor": "#000000",
      "bgColor": "#FFFFFF",
      "eye1Color": finalColor,
      "eye2Color": finalColor,
      "eye3Color": finalColor,
      "eyeBall1Color": finalColor,
      "eyeBall2Color": finalColor,
      "eyeBall3Color": finalColor,
      "gradientColor1": finalColor,
      "gradientColor2": finalColor,
      "gradientType": "linear",
      "gradientOnEyes": "true",
    },
    "size": 500,
    "download": "imageUrl",
    "file": finalFormato
  };

  // Convertir el mapa a JSON
  String jsonString = jsonEncode(payload);

  print(jsonString);
}

void enviarSolicitud() async {
  try {
    var response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print("\n[+] Status : Éxito!!\n");

      Map<String, dynamic> output = jsonDecode(response.body);
      String link = output['imageUrl'];

      print(link);
    } else {
      print("[-] Status : Error ${response.statusCode}");
    }
  } catch (e) {
    print("[-] Error al realizar la solicitud: $e");
  }
}

Future<bool> verificarConexionInternet() async {
  try {
    final response = await http.head(Uri.parse('http://www.google.com'));
    return response.statusCode == 200;
  } catch (e) {  
    return false;
  }
}

class Formato extends StatefulWidget {
  final Function(String?) onFormatoSelected;

  const Formato({super.key, required this.onFormatoSelected});

  @override
  _FormatoState createState() => _FormatoState();
}

class _FormatoState extends State<Formato> {
  String? _selectedValue = 'png'; // Inicializar el valor seleccionado

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            'Formato descarga:',
            style: TextStyle(fontSize: 18, fontFamily: 'Helvetica'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue;
              });
              widget.onFormatoSelected(newValue); // Llamar a la función externa
            },
            items: <String>['png', 'jpg', 'pdf']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class TipoQR extends StatefulWidget {
  final Function(String?) onTipoSelected;

  const TipoQR({super.key, required this.onTipoSelected});

  @override
  _TipoQRState createState() => _TipoQRState();
}

class _TipoQRState extends State<TipoQR> {
  String? _selectedValue = 'URL'; // Inicializar el valor seleccionado

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            'Tipo QR:',
            style: TextStyle(fontSize: 18, fontFamily: 'Helvetica'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue;
              });
              widget.onTipoSelected(newValue); // Llamar a la función externa
            },
            items: <String>['URL', 'Text Plain', 'Email', 'Phone']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class Forma extends StatefulWidget {
  final Function(String?) onShapeSelected;

  const Forma({super.key, required this.onShapeSelected});

  @override
  _FormaState createState() => _FormaState();
}

class _FormaState extends State<Forma> {
  String? _selectedValue = 'square';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            'Forma:    ',
            style: TextStyle(fontSize: 18, fontFamily: 'Helvetica'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue; // Actualizar el valor seleccionado
              });
              widget.onShapeSelected(newValue); // Llamar a la función externa
            },
            items: <String>[
              'square',
              'mosaic',
              'dot',
              'circle',
              'circle-zebra',
              'circle-zebra-vertical',
              'circular',
              'edge-cut',
              'edge-cut-smooth',
              'japnese',
              'leaf',
              'pointed',
              'pointed-edge-cut',
              'pointed-in',
              'pointed-in-smooth',
              'pointed-smooth',
              'round',
              'rounded-in',
              'rounded-in-smooth',
              'rounded-pointed',
              'star',
              'diamond'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ColorSelector extends StatefulWidget {
  final Function(String?) onColorSelected;

  const ColorSelector({super.key, required this.onColorSelected});

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  String? _selectedValue = 'Rojo';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            'Color:    ',
            style: TextStyle(fontSize: 18, fontFamily: 'Helvetica'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue; // Actualizar el valor seleccionado
              });
              widget.onColorSelected(newValue); // Llamar a la función externa
            },
            items: <String>['Rojo', 'Azul', 'Verde', 'Negro']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
