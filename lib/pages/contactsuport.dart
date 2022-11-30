import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:la_fiducia/login/register_page.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:la_fiducia/login/auth.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_fiducia/widgets/colors.dart';
import 'package:la_fiducia/widgets/socialButtons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:la_fiducia/login/sharedPref.dart';

import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:la_fiducia/pages/checkOut2.dart';
import 'package:la_fiducia/pages/menu.dart';

class ContactSuport extends StatefulWidget {
  @override
  _ContactSuportState createState() => _ContactSuportState();
}

class _ContactSuportState extends State<ContactSuport> {
  @override
  void initState() {
    super.initState();
  }

  bool agree = false;

  final TextEditingController nomController = new TextEditingController();
  final TextEditingController mailController = new TextEditingController();
  final TextEditingController mensagemController = new TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Menu()),
                      (Route<dynamic> route) => false);
                },
              ),
            );
          },
        ),

        titleSpacing: 0,
        leadingWidth: 60,
        centerTitle: true,
        title: Text('CONTACT ET SUPPORT',
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
      body: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    "VOTRE NOM:",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Color.fromRGBO(181, 142, 0, 1),
                      fontFamily: 'Poppins',
                      package: 'awesome_package',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 200,
                ),
                Container(
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
                      padding: EdgeInsets.only(bottom: 4.0, left: 6.0),
                      child: TextFormField(
                        controller: nomController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Escrivez votre nom ici...",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(190, 190, 190, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    "E-MAIL:",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Color.fromRGBO(181, 142, 0, 1),
                      fontFamily: 'Poppins',
                      package: 'awesome_package',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 200,
                ),
                Container(
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
                      padding: EdgeInsets.only(bottom: 4.0, left: 6.0),
                      child: TextFormField(
                        controller: mailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Entrez votre e-mail ici...",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(190, 190, 190, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    "MESSAGE:",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Color.fromRGBO(181, 142, 0, 1),
                      fontFamily: 'Poppins',
                      package: 'awesome_package',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 200,
                ),
                Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromRGBO(181, 142, 0, 1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.0, left: 6.0),
                      child: TextFormField(
                        maxLines: null,
                        controller: mensagemController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Entrez votre message ici...",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(190, 190, 190, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        'RÉGLEMENTATION GÉNÉRALE DE LA PROTECTION DES DONNÉES:',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Color.fromRGBO(181, 142, 0, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 120,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: RichText(
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                      children: [
                        TextSpan(
                            text:
                                'La collecte de ces données est simplement que nous aurons assez de données pour répondre à votre commentaire, pour en savoir plus, ',
                            style: TextStyle(
                              color: Color.fromRGBO(45, 61, 75, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            )),
                        TextSpan(
                          text: 'cliquez ici',
                          style: TextStyle(
                            color: const Color(0xFFB58E00),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 120,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        'RÉGLEMENTATION GÉNÉRALE DE LA PROTECTION DES DONNÉES:',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Color.fromRGBO(181, 142, 0, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Material(
                        color: Colors.white,
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
                        width: MediaQuery.of(context).size.width * 0.79,
                        child: Text(
                            "J'autorise la collecte et le traitement de mes données conformément à cette politique de confidentialité.",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Color.fromRGBO(45, 61, 75, 1),
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  alignment: Alignment.center,
                  child: OutlinedButton(
                    onPressed: () {
                      var email = mailController.text;
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email);
                      if (emailValid == true) {
                        if (agree == false) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _naoAceitou(context),
                          );
                        } else if (mensagemController.text == '') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogMensagemBranco(context),
                          );
                        } else if (nomController.text == '') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _Naotemnome(context),
                          );
                        } else {
                          PostFormulario(nomController.text,
                              mailController.text, mensagemController.text);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialEnviadoSucesso(context),
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
                    child: const Text('ENVOYER',
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
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text('ADRESSE',
                        style: TextStyle(
                          color: Color.fromRGBO(45, 61, 75, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ))),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            const IconData(0xf193, fontFamily: 'MaterialIcons'),
                            color: Color.fromRGBO(181, 142, 0, 1),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 30,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.35,
                                child:
                                    Text('RESTAURANT - PIZZERIA "LA FIDUCIA"',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color.fromRGBO(45, 61, 75, 1),
                                          fontFamily: 'Poppins',
                                          package: 'awesome_package',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 1000,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.35,
                                child: Text('2, RUE PRINCE JEAN',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 1000,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.35,
                                child: Text('L-9052 ETTELBRUCK',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3000,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            const IconData(0xf187, fontFamily: 'MaterialIcons'),
                            color: Color.fromRGBO(181, 142, 0, 1),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 30,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.35,
                                child: Text('+352 26 87 43 15',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            const IconData(0xe73b, fontFamily: 'MaterialIcons'),
                            color: Color.fromRGBO(181, 142, 0, 1),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 30,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.35,
                                child: Text(
                                    'Ouvert de 11h30 à 14h00 et 17h30 à 21h30 et Mercredi ouvert de 17h30 à 21h30.',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 1000,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.35,
                                child: Text('Fermé le Mardi',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 61, 75, 1),
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ])),
        ],
      ),
    );
  }

  PostFormulario(String mail, nome, morada) async {
    Map data = {
      "nome": mail,
      'email': nome,
      "mensagem": morada,
    };

    var jsonResponse = null;

    var response = await http
        .post(
      Uri.parse('${ApiDevLafiducia}/enviar-formulario'),
      body: data,
    )
        .then((result) {
      print(result.statusCode);
      print(result.body);
    });
    ;

    jsonResponse = json.decode(response.body);
    print('é istooooooo!!!' + jsonResponse.toString());
  }

  Widget _buildPopupDialEnviadoSucesso(BuildContext context) {
    return new AlertDialog(
      actions: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Column(
                  children: [
                    Text('Message envoyé avec succès!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(181, 142, 0, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    Text('Nous vous répondrons dans les plus brefs délais.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(45, 61, 75, 1),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactSuport()),
                        );
                      },
                      child: const Text("J'ACCEPTE",
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

  Widget _Naotemnome(BuildContext context) {
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
                      Text('Nom non saisi ',
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
                    height: MediaQuery.of(context).size.height / 50,
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

  Widget _naoAceitou(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: new AlertDialog(
        actions: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 7,
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
                    height: MediaQuery.of(context).size.height / 50,
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
                      Text('Adresse Email incorrecte',
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
                    height: MediaQuery.of(context).size.height / 50,
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

  Widget _buildPopupDialogMensagemBranco(BuildContext context) {
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
                      Text('Message non saisi',
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
                    height: MediaQuery.of(context).size.height / 50,
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
}
