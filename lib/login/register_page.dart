import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:la_fiducia/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:la_fiducia/login/login_page.dart';
import 'package:la_fiducia/login/google_signin_api.dart';
import 'package:http/http.dart' as http;
import 'package:email_auth/email_auth.dart';
import 'package:la_fiducia/login/auth.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    fetchLocalidade();
    _getCitiesList();
    super.initState();
    emailController.addListener(onListen);
    passwordController.addListener(onListen);
    nomeController.addListener(onListen);
    telefoneController.addListener(onListen);
    moradaController.addListener(onListen);
    codigoPostalController.addListener(onListen);
  }

  @override
  void dispose() {
    emailController.removeListener(onListen);
    passwordController.removeListener(onListen);
    nomeController.removeListener(onListen);
    telefoneController.removeListener(onListen);
    moradaController.removeListener(onListen);
    codigoPostalController.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  List? listLocalidade;
  Future<List<dynamic>> fetchLocalidade() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/localidades/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listLocalidade = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  bool agree = false;
  bool _isLoading = false;
  var errorMsg;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nomeController = new TextEditingController();
  TextEditingController telefoneController = new TextEditingController();
  TextEditingController moradaController = new TextEditingController();
  TextEditingController codigoPostalController = new TextEditingController();
  var _locations = ['PETTIT', 'GRAND', 'MEDIUM'];
  var _selectedLocation;
  var i = 0;
  var teste;

  List citiesList = [];
  String? _myCity;
  String rgpd = '1';
  String tipoRegisto = 'APP';
  String identifier = '';
  String tipooo = '';

  String cityInfoUrl =
      'http://cleanions.bestweb.my/api/location/get_city_by_state_id';
  Future<String> _getCitiesList() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/localidades/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return citiesList = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        setState(() {
          identifier = build.androidId;
          tipooo = 'Android';
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          identifier = data.identifierForVendor;
          tipooo = 'iOS';
        }); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  String uniquecode = '';

  @override
  Widget build(BuildContext context) {
    if (i == 0) {
      _deviceDetails();
      i++;
    }
    DateTime now = new DateTime.now();
    fetchLocalidade();
    _getCitiesList();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: Image.asset('assets/next.png'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Menu(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            titleSpacing: 0,
            leadingWidth: 60,
            centerTitle: true,
            title: Text('REGISTER',
                style: TextStyle(
                  color: Color.fromRGBO(45, 61, 75, 1),
                  fontFamily: 'Poppins',
                  package: 'awesome_package',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            automaticallyImplyLeading:
                false, //optional: removes the default back arrow
          ),
          body: FutureBuilder<List<dynamic>>(
              future: fetchLocalidade(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
                Random _rnd = Random();

                String getRandomString(int length) =>
                    String.fromCharCodes(Iterable.generate(length,
                        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
                uniquecode = getRandomString(12);

                return ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        child: Text(
                          'LOGIN INFORMATION',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 8),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "ADRESSE E-MAIL*",
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: emailController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Color.fromRGBO(181, 142, 0, 1),
                                        ),
                                        onPressed: emailController.clear,
                                      )),
                            autofillHints: [AutofillHints.email],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 8),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "PASSWORD*",
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: passwordController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Color.fromRGBO(181, 142, 0, 1),
                                        ),
                                        onPressed: passwordController.clear,
                                      )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 8),
                          child: TextFormField(
                            controller: nomeController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "NOM*",
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: nomeController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Color.fromRGBO(181, 142, 0, 1),
                                        ),
                                        onPressed: nomeController.clear,
                                      )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 8),
                          child: TextFormField(
                            controller: telefoneController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "TELÉPHONE*",
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: telefoneController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Color.fromRGBO(181, 142, 0, 1),
                                        ),
                                        onPressed: telefoneController.clear,
                                      )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'LOCALITÉ*',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0, left: 0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              iconSize: 30,
                                              icon: (null),
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                              ),
                                              hint: Text(
                                                'Sélectionnez une ville*',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      112, 112, 112, 1),
                                                  fontFamily: 'Poppins',
                                                  package: 'awesome_package',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _myCity = newValue.toString();
                                                });
                                              },
                                              items: citiesList.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item['localidade'],
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      package:
                                                          'awesome_package',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value: item['id'].toString(),
                                                );
                                              }).toList(),
                                              value: _myCity,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 8),
                          child: TextFormField(
                            controller: moradaController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "ADRESSE*",
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: moradaController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Color.fromRGBO(181, 142, 0, 1),
                                        ),
                                        onPressed: moradaController.clear,
                                      )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 8),
                          child: TextFormField(
                              controller: codigoPostalController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: "CODE POSTAL*",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(112, 112, 112, 1),
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  suffixIcon: codigoPostalController
                                          .text.isEmpty
                                      ? Container(width: 0)
                                      : IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color:
                                                Color.fromRGBO(181, 142, 0, 1),
                                          ),
                                          onPressed:
                                              codigoPostalController.clear,
                                        )),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'RÉGLEMENTATION GÉNÉRALE DE LA PROTECTION DES DONNÉES.',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Material(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                    Color.fromRGBO(181, 142, 0, 1),
                              ),
                              child: Checkbox(
                                activeColor: Color.fromRGBO(181, 142, 0, 1),
                                value: agree,
                                onChanged: (value) {
                                  setState(() {
                                    agree = value ?? false;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                                'J´ACCEPTE LA COMMUNICATION DE MES DONNÉES DANS LE BUT DE TRAITER LES COLIS ET DE LES DISTRIBUER SELON LES CONDITIONS ÉTABLIES DANSLES INFORMATIONS SUR LA PROTECTION DES DONNÉES.',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: Color.fromRGBO(181, 142, 0, 1),
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            var email = emailController.text;
                            var phone = telefoneController.text;
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email);

                            bool phoneValid =
                                RegExp(r'[0-9]{6,13}$').hasMatch(phone);
                            if (emailValid == true) {
                              if (passwordController.text == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogPass(context),
                                );
                              } else if (nomeController.text == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogNom(context),
                                );
                              } else if (telefoneController.text == '' ||
                                  phoneValid == false) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogTelefone(context),
                                );
                              } else if (moradaController.text == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogMorada(context),
                                );
                              } else if (codigoPostalController.text == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogCodigoPostal(context),
                                );
                              } else if (_myCity == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogLocalidade(context),
                                );
                              } else if (agree == false) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogRgpd(context),
                                );
                              } else {
                                Register(
                                  emailController.text,
                                  passwordController.text,
                                  nomeController.text,
                                  telefoneController.text,
                                  moradaController.text,
                                  codigoPostalController.text,
                                  _myCity,
                                  rgpd,
                                  now.toString(),
                                  uniquecode,
                                  tipoRegisto.toString(),
                                  'Site',
                                  tipooo,
                                );
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialogMail(context),
                              );
                            }
                          },
                          child: const Text('TERMINER',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 16)),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(181, 142, 0, 0.9)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })),
    );
  }

  Register(String email, pass, nome, telefone, morada, codigoPostal, _myCity,
      rgpd, now, uniquecode, tipoRegisto, plataforma, tipo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': pass,
      'nome': nome,
      'telefone': telefone,
      'morada': morada,
      'cod_postal': codigoPostal,
      'localidade': _myCity,
      'rgpd': rgpd,
      'data_registo': now.toString(),
      'uniqueCode': uniquecode,
      'tipo_registo': tipoRegisto,
      'plataforma_registo': plataforma,
      'sistema_registo': tipo,
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse('${ApiDevLafiducia}/utilizadores'),
        body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        /*sharedPreferences.setString("token", jsonResponse['token']);*/
        print('ESTA ÈEEEEE A RESPOOSSTTTTTTAAAAA' + jsonResponse['token']);

        save('token', jsonResponse['token']);

        var prefs = await SharedPreferences.getInstance();
        prefs.setString('token', jsonResponse['token']);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Menu()),
            (Route<dynamic> route) => false);
      }
    } else if (response.statusCode == 400) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context),
      );
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      actions: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 6.8,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Column(
                  children: [
                    Text("Il y a eu une erreur dans le registre",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(181, 142, 0, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Réessayer",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 16)),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(181, 142, 0, 0.9)),
                          side: MaterialStateProperty.all(BorderSide(
                              color: Color.fromRGBO(181, 142, 0, 0.9),
                              width: 0.0,
                              style: BorderStyle.solid))),
                    ),
                  ],
                ),
              ],
            ))
      ],
    );
  }

  Widget _buildPopupDialogMail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Adresse e-mail incorrecte',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Eéessayer",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(181, 142, 0, 0.9)),
                            side: MaterialStateProperty.all(BorderSide(
                                color: Color.fromRGBO(181, 142, 0, 0.9),
                                width: 0.0,
                                style: BorderStyle.solid))),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialogPass(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Mot de passe non saisi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Réessayer",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(181, 142, 0, 0.9)),
                            side: MaterialStateProperty.all(BorderSide(
                                color: Color.fromRGBO(181, 142, 0, 0.9),
                                width: 0.0,
                                style: BorderStyle.solid))),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialogNom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Nom non saisi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Réessayer",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(181, 142, 0, 0.9)),
                            side: MaterialStateProperty.all(BorderSide(
                                color: Color.fromRGBO(181, 142, 0, 0.9),
                                width: 0.0,
                                style: BorderStyle.solid))),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialogTelefone(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Téléphone mal inséré',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Réessayer",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(181, 142, 0, 0.9)),
                            side: MaterialStateProperty.all(BorderSide(
                                color: Color.fromRGBO(181, 142, 0, 0.9),
                                width: 0.0,
                                style: BorderStyle.solid))),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialogLocalidade(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Emplacement non renseigné',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Réessayer",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(181, 142, 0, 0.9)),
                            side: MaterialStateProperty.all(BorderSide(
                                color: Color.fromRGBO(181, 142, 0, 0.9),
                                width: 0.0,
                                style: BorderStyle.solid))),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialogMorada(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Adresse non renseignée',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Réessayer",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(181, 142, 0, 0.9)),
                            side: MaterialStateProperty.all(BorderSide(
                                color: Color.fromRGBO(181, 142, 0, 0.9),
                                width: 0.0,
                                style: BorderStyle.solid))),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialogCodigoPostal(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Column(
                    children: [
                      Text('Code postal non saisi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(181, 142, 0, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Réessayer",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                package: 'awesome_package',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(181, 142, 0, 0.9)),
                            side: MaterialStateProperty.all(BorderSide(
                                color: Color.fromRGBO(181, 142, 0, 0.9),
                                width: 0.0,
                                style: BorderStyle.solid))),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialogRgpd(BuildContext context) {
    return new AlertDialog(
      actions: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 6.8,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Column(
                  children: [
                    Text(
                        "N'a pas accepté la politique de protection des données",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(181, 142, 0, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Réessayer",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 16)),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(181, 142, 0, 0.9)),
                          side: MaterialStateProperty.all(BorderSide(
                              color: Color.fromRGBO(181, 142, 0, 0.9),
                              width: 0.0,
                              style: BorderStyle.solid))),
                    ),
                  ],
                ),
              ],
            ))
      ],
    );
  }
}
