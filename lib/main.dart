import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:translator/translator.dart';

void main() => runApp(MaterialApp(
      title: "Leandro Puxa Wiskey",
      home: PaginaInicial(),
    ));

class PaginaInicial extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<PaginaInicial> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String cep = '';
  String pais;
  String estado;
  String cidade;
  String bairro;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  Future getWeather() async {
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=$cidade&$pais&appid=e12696f92ba0b9722892b4e18016ffaa");
    var results = jsonDecode(response.body);

    setState(() {
      double aux = results['main']['temp'];
      aux -= 273.15;
      this.temp = double.parse((aux).toStringAsFixed(2));
      final translator = GoogleTranslator();
      translator
          .translate(results['weather'][0]['description'], from: 'en', to: 'pt')
          .then((s) {
        this.description = s;
      });

      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  Future getLocate() async {
    http.Response response =
        await http.get("http://viacep.com.br/ws/$cep/json/");
    var results = jsonDecode(response.body);

    setState(() {
      this.bairro = results['bairro'];
      this.cidade = results['localidade'];
      this.estado = results['uf'];
      this.pais = 'Brasil';
    });
  }

  void initState() {
    super.initState();
    this.getWeatherLocal();
  }

  void getWeatherLocal() async {
    if (this.cep.toString().isEmpty) {
      this.cep = '89010918';
    }
    await this.getLocate();
    this.getWeather();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Stack(children: <Widget>[
        Image(
          image: AssetImage('assets/solchuva.jpg'),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    "$bairro, $cidade, $estado, $pais",
                    style: TextStyle(
                        backgroundColor: Colors.orange[200],
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(temp != null ? temp.toString() + "\u00B0" : "Loading",
                    style: TextStyle(
                        backgroundColor: Colors.orange[200],
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600)),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    description != null ? description.toString() : "Loading",
                    style: TextStyle(
                        backgroundColor: Colors.orange[200],
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ]),
        ),
      ]),
      Container(
        margin: new EdgeInsets.only(
          left: 15.0,
          right: 15.0,
        ),
        child: new Form(
          key: _key,
          autovalidate: _validate,
          child: _formUI(),
        ),
      ),
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text("Temperatura"),
                    trailing: Text(
                        temp != null ? temp.toString() + "\u00B0C" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Clima"),
                    trailing: Text(description != null
                        ? description.toString()
                        : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("umidade"),
                    trailing: Text(humidity != null
                        ? humidity.toString() + "%"
                        : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Velocidade do Vento"),
                    trailing: Text(windSpeed != null
                        ? windSpeed.toString() + " KM/H"
                        : "Loading"),
                  )
                ],
              )))
    ]));
  }

  Widget _formUI() {
    return new Column(children: <Widget>[
      new TextFormField(
        decoration: new InputDecoration(hintText: 'Cep'),
        keyboardType: TextInputType.number,
        maxLength: 8,
        validator: _validarCep,
        onSaved: (String val) {
          cep = val;
        },
      ),
      new RaisedButton(
        onPressed: _sendForm,
        child: new Text('Buscar'),
      )
    ]);
  }

  String _validarCep(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    value.replaceAll(RegExp('-'), '');
    if (value.length == 0) {
      return "Informe o cep";
    } else if (!regExp.hasMatch(value)) {
      return "O cep deve conter apenas caracteres de 0-9";
    }
    return null;
  }

  _sendForm() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      if (this.cep.toString().isNotEmpty) {
        await this.getLocate();
      }
      this.getWeather();
    }
  }
}
