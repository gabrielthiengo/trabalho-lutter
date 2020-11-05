import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static String baseURL = "https://economia.awesomeapi.com.br/json";

  var moedas = [
    'USD-BRL',
    'EUR-BRL',
    'BTC-BRL',
    'USDT-BRL',
    'CAD-BRL',
    'GBP-BRL',
    'ARS-BRL',
    'LTC-BRL',
    'JPY-BRL',
    'CHF-BRL',
    'AUD-BRL',
    'CNY-BRL',
    'ILS-BRL',
  ];
  List<String> qtdDias = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  String dropdownMoeda = 'USD-BRL';
  String dropdownDias = '1';
  var response;
  bool loading = false;

  getCotacoes() async {
    setState(() {
      loading = true;
    });

    try {
      var res = await http.get('$baseURL/$dropdownMoeda/$dropdownDias');

      setState(() {
        response = jsonDecode(res.body);
        loading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acompanhamento Monetário'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informe a modeda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              width: double.infinity,
              child: DropdownButton(
                value: dropdownMoeda,
                iconSize: 24,
                elevation: 16,
                isExpanded: true,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownMoeda = newValue;
                  });

                  getCotacoes();
                },
                items: moedas.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Informe o número de dias',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              width: double.infinity,
              child: DropdownButton(
                value: dropdownDias,
                iconSize: 24,
                elevation: 16,
                isExpanded: true,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownDias = newValue;
                  });

                  getCotacoes();
                },
                items: qtdDias.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            response != null
                ? SizedBox(
                    height: 320,
                    child: ListView.builder(
                        itemCount: response == null ? 0 : response.length,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  "Menor Valor: " + response[index]['low']),
                              subtitle: Text(
                                  "Maior Valor: " + response[index]['high']),
                            ),
                          );
                        }),
                  )
                : !loading
                    ? Center(
                        heightFactor: 3,
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                              size: 50,
                            ),
                            Text('Faça uma busca para exibir os dados',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ))
                          ],
                        ),
                      )
                    : Center(
                        heightFactor: 5,
                        child: CircularProgressIndicator(),
                      )
          ],
        ),
      ),
    );
  }
}
