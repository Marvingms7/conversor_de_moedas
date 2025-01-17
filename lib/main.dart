import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() async {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  final response = await http
      .get(Uri.parse('https://api.hgbrasil.com/finance?key=f2b7824c'));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControlador = TextEditingController();
  final dolarControlador = TextEditingController();
  final euroControlador = TextEditingController();

  late double dolar;
  late double euro;

  void _realMudanca(String text) {
    double real = double.parse(text);
    dolarControlador.text = (real / dolar).toStringAsFixed(2);
    euroControlador.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarMudanca(String text) {
    double dolar = double.parse(text);
    realControlador.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControlador.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroMudanca(String text) {
    double euro = double.parse(text);
    realControlador.text = (euro * this.euro).toStringAsFixed(2);
    dolarControlador.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(60, 253, 252, 252),
      appBar: AppBar(
        title: const Text('\$ Conversor \$'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text('Carregando Dados...',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao Carregar Dados...',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        textAlign: TextAlign.center),
                  );
                } else {
                  dolar = snapshot.data!['results']['currencies']['USD']['buy'];
                  euro = snapshot.data!['results']['currencies']['EUR']['buy'];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          size: 190.0,
                          color: Colors.amber,
                        ),
                        const Divider(),
                        buildTextField(
                            'Reais', 'R\$', realControlador, _realMudanca),
                        const Divider(),
                        buildTextField(
                            'Dólares', 'US\$', dolarControlador, _dolarMudanca),
                        const Divider(),
                        buildTextField(
                            'Euros', '€', euroControlador, _euroMudanca),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, m) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixText: prefix),
    style: const TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: m,
    keyboardType: TextInputType.number,
  );
}
