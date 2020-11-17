// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() => runApp(new MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   GlobalKey<FormState> _key = new GlobalKey();
//   bool _validate = false;
//   String cidade;
//   String pais;
//   String cep;
//   var temperatura;
//   var tempoDescricao;
//   var tempoAgora;
//   var umidadeAr;
//   var vento;

//   Future getWeather() async {
//     http.Response response = await http.get(
//         "http://api.openweathermap.org/data/2.5/weather?q=$cidade&$pais&appid=e12696f92ba0b9722892b4e18016ffaa");
//     var results = jsonDecode(response.body);

//     setState(() {
//       this.temperatura = results['main']['temp'];
//       this.tempoDescricao = results['weather'][0]['deion'];
//       this.tempoAgora = results['weather'][0]['main'];
//       this.umidadeAr = results['main']['humidity'];
//       this.vento = results['wind']['speed'];
//     });
//   }

//   Future getLocate() async {
//     http.Response response =
//         await http.get("http://viacep.com.br/ws/$cep/json/");
//     var results = jsonDecode(response.body);

//     setState(() {
//       this.cidade = results['localidade'];
//       this.pais = 'Brazil';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Previsão do tempo'),
//         ),
//         body: new SingleChildScrollView(
//           child: new Container(
//             margin: new EdgeInsets.all(15.0),
//             child: new Form(
//               key: _key,
//               autovalidate: _validate,
//               child: _formUI(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _formUI() {
//     return new Column(
//       children: <Widget>[
//         new TextFormField(
//           decoration: new InputDecoration(
//             hintText: 'País',
//           ),
//           maxLength: 60,
//           validator: _validarPais,
//           onSaved: (String val) {
//             pais = val;
//           },
//         ),
//         new TextFormField(
//           decoration: new InputDecoration(hintText: 'Cidade'),
//           maxLength: 60,
//           validator: _validarCidade,
//           onSaved: (String val) {
//             cidade = val;
//           },
//         ),
//         new TextFormField(
//           decoration: new InputDecoration(hintText: 'Cep'),
//           maxLength: 8,
//           validator: _validarCep,
//           onSaved: (String val) {
//             cep = val;
//           },
//         ),
//         new SizedBox(height: 15.0),
//         new RaisedButton(
//           onPressed: _sendForm,
//           child: new Text('Enviar'),
//         ),
//         Container(
//           Row(children: const <Widget>[
//             Icon(Icons.cloud_queue),
//             Text('Clima: ' + tempoDescricao.toString(),
//                 style: TextStyle(
//                   fontSize: 30,
//                 )),
//           ]),
//         ),
//         Container(
//           color: Colors.blue[200],
//           child: Text('temperatura ' + temperatura.toString(),
//               style: TextStyle(
//                 fontSize: 30,
//               )),
//         ),
//         Container(
//           color: Colors.deepPurple[200],
//           child: Text('Umidade Ar ' + umidadeAr.toString(),
//               style: TextStyle(
//                 fontSize: 30,
//               )),
//         ),
//         Container(
//           color: Colors.cyan[300],
//           child: Text(
//               cidade.toString() != null
//                   ? 'Cidade cep: ' + cidade.toString()
//                   : "",
//               style: TextStyle(
//                 fontSize: 30,
//               )),
//         ),
//       ],
//     );
//   }

//   String _validarCidade(String value) {
//     String patttern = r'(^[a-zA-Z ]*$)';
//     RegExp regExp = new RegExp(patttern);
//     if (this.cep.toString().isEmpty) {
//       if (value.length == 0) {
//         return "Informe o país";
//       } else if (!regExp.hasMatch(value)) {
//         return "o país deve conter apenas caracteres de a-z ou A-Z";
//       }
//     }
//     return null;
//   }

//   String _validarPais(String value) {
//     String patttern = r'(^[a-zA-Z ]*$)';
//     RegExp regExp = new RegExp(patttern);
//     if (this.cep.toString().isEmpty) {
//       if (value.length == 0) {
//         return "Informe a cidade";
//       } else if (!regExp.hasMatch(value)) {
//         return "A cidade deve conter apenas caracteres de a-z ou A-Z";
//       }
//     }
//     return null;
//   }

//   String _validarCep(String value) {
//     String patttern = r'(^[0-9]*$)';
//     RegExp regExp = new RegExp(patttern);
//     if (value.length == 0) {
//       return "Informe o cep";
//     } else if (!regExp.hasMatch(value)) {
//       return "O cep deve conter apenas caracteres de 0-9";
//     }
//     return null;
//   }

//   _sendForm() async {
//     if (_key.currentState.validate()) {
//       _key.currentState.save();
//       if (this.cep.toString().isNotEmpty) {
//         await this.getLocate();
//       }
//       this.getWeather();
//     } else {
//       setState(() {
//         _validate = true;
//       });
//     }
//   }
// }
