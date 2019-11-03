import 'dart:convert';

import 'package:estados_listview/model/estado.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estados Brasileiros',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomePage(title: 'Lista de estados brasileiros'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Estado> _estados = List<Estado>();
  List<Estado> _estadosForDisplay = List<Estado>();

  Future<List<Estado>> fetchData() async {
    var url =
        'https://raw.githubusercontent.com/vipontes/json/master/estados.json';
    var response = await http.get(url);

    var estados = List<Estado>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        estados.add(Estado.fromJson(noteJson));
      }
    }
    return estados;
  }

  @override
  void initState() {
    fetchData().then((value) {
      setState(() {
        _estados.addAll(value);
        _estadosForDisplay = _estados;
      });

      print(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Estados do Brasil'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index - 1);
          },
          itemCount: _estadosForDisplay.length + 1,
        ));
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Pesquisar...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _estadosForDisplay = _estados.where((estado) {
              var estadoNome = estado.estadoNome.toLowerCase();
              return estadoNome.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _estadosForDisplay[index].estadoNome,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _estadosForDisplay[index].estadoSigla,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
