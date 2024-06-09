import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
String? finalColor = 'Rojo';
String? finalFormato = 'png';
String? finalData = '';
final data = TextEditingController();

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
                finalColor = color;
              });
              print('Valor seleccionado para Color: $color');
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
                  imprimirContenido();
                  // Aquí puedes realizar cualquier acción adicional si el texto no está vacío
                } else {
                  print('El texto no puede estar vacío.');
                  // Aquí puedes mostrar un mensaje de error al usuario indicando que el texto no puede estar vacío
                }
              },
            ),
          )
        ],
      ),
    );
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

void imprimirContenido() {
  print('Tipo: $finalTipo');
  print('Forma: $finalShape');
  print('Color: $finalColor');
  print('Formato: $finalFormato');
  print('Data: $finalData');
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

class Colork extends StatefulWidget {
  final Function(String?) onColorSelected;

  const Colork({super.key, required this.onColorSelected});

  @override
  _FormaState createState() => _FormaState();
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