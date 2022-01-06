import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:la_fiducia/util/customSwitch.dart';
import 'package:flutter/gestures.dart';
import 'package:la_fiducia/widgets/build_botao.dart';
import 'package:la_fiducia/widgets/bolinhas.dart';
import 'package:la_fiducia/carro/cart.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:la_fiducia/login/login_page.dart';
import 'package:la_fiducia/login/register_page.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:la_fiducia/pages/iformations.dart';
import 'package:la_fiducia/pages/contactsuport.dart';
import 'package:la_fiducia/pages/propousDenous.dart';
import 'package:la_fiducia/widgets/bannerDiaSemana.dart';
import 'package:la_fiducia/pages/mesCommandes.dart';
import 'package:la_fiducia/login/google_signin_api.dart';
import 'dart:async';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:uuid/uuid.dart';

String finalEmail = '';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuState();
  }
}

class _MenuState extends State<Menu> {
  var uuid = Uuid();

  Future createPlantFoodNotifications() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 4,
      channelKey: 'basic_chanel',
      title: 'Commande La fiducia!',
      body: 'Votre commande a été passée avec succès!',
      /*bigPicture: 'asset://assets/notification_map.png',
      notificationLayout: NotificationLayout.BigPicture,*/
    ));
  }

  final plugin = FacebookLogin(debug: true);
  SharedPreferences? sharedPreferences;
  int _current = 0;
  bool isSwitched = false;
  final CarouselController _controller = CarouselController();
  late String stringResponse;

  String? _sdkVersion;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;

  late List listProdutos;
  Future<List<dynamic>> fetchCategoria() async {
    final response = await http
        .get(Uri.parse('${ApiDevLafiducia}/produtos-categorias/${24}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listProdutos = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    getToken();
    fetchData();
    fetchBanners();
    fetchProdCarrinho();
    fetchPratoSemana();
    fetchPratodia();
    fetchFolga();
    fetchFerias();
    super.initState();
    _getSdkVersion();
    _updateLoginInfo();
  }

  /*loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Menu()),
          (Route<dynamic> route) => false);
    }
  }*/

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        setState(() {
          identifier = build.androidId;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          identifier = data.identifierForVendor;
        }); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  /*static Future<List<String>> getDeviceDetails() async {
    String deviceName = '';
    String deviceVersion = '';
    String identifier = '';
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    //if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }*/

  List? listProdutosCarrinho;
  Future<List<dynamic>> fetchProdCarrinho() async {
    final response = await http.get(
        Uri.parse('${ApiDevLafiducia}/produto-carrinho-temp/${identifier}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listProdutosCarrinho = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  late List listResponse;
  Future<List<dynamic>> fetchData() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/categorias'));
    /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
    return listResponse = json.decode(response.body);
  }

  late List listSugest;
  Future<List<dynamic>> fetchBanners() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/sugestoes'));
    /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
    return listSugest = json.decode(response.body);
  }

  List? listPatoDia;
  Future<List<dynamic>> fetchPratodia() async {
    final response = await http.get(Uri.parse('${ApiDevLafiducia}/prato-dia/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listPatoDia = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listPatoDia = json.decode(response.body);
    }
  }

  List? listPratoSemana;
  Future<List<dynamic>> fetchPratoSemana() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/sugestao-semana/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listPratoSemana = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listPatoDia = json.decode(response.body);
    }
  }

  List listEstadoFerias = [];
  var FechadoFerias;
  Future<List<dynamic>> fetchFerias() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/ferias-restaurante/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        FechadoFerias = 200;
      });

      return listEstadoFerias = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        FechadoFerias = 400;
      });
      throw Exception('Failed to load album');
    }
  }

  List listEstadoFolga = [];
  var FechadoFolga;
  Future<List<dynamic>> fetchFolga() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/ferias-restaurante/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        FechadoFolga = 200;
      });

      return listEstadoFolga = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        FechadoFolga = 400;
      });
      throw Exception('Failed to load album');
    }
  }

  List<Map<dynamic, dynamic>> lists = [];
  List<Map<dynamic, dynamic>> lists2 = [];

  var retrievedName;
  String identifier = '';
  String limite = '';
  var Valuez;
  var teste = 0;
  String token = '';
  var i = 0;
  var parts2;

  Future getToken() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      token = (prefs.getString("token") ?? "");
    });
  }

  Future deleteToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    /*print('este é o toooooookeeeeeen' + token);*/
    fetchPratoSemana();
    fetchPratodia();

    if (token != '') {
      String _decodeBase64(String str) {
        String output = str.replaceAll('-', '+').replaceAll('_', '/');

        switch (output.length % 4) {
          case 0:
            break;
          case 2:
            output += '==';
            break;
          case 3:
            output += '=';
            break;
          default:
            throw Exception('Illegal base64url string!"');
        }

        return utf8.decode(base64Url.decode(output));
      }

      Map<String, dynamic> parseJwt(String token) {
        final parts = token.split('.');

        final payload = _decodeBase64(parts[1]);
        final payloadMap = json.decode(payload);

        return payloadMap;
      }

      setState(() {
        parts2 = parseJwt(token)['result'];
      });
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: Image.asset('assets/menu_hamburger.png'),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                );
              },
            ),
            centerTitle: true,
            titleSpacing: MediaQuery.of(context).size.width / 9.44,
            title: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Positivo.png',
                  fit: BoxFit.scaleDown,
                  height: 64,
                ),
              ],
            ),
            actions: <Widget>[
              Column(
                children: [
                  if (FechadoFerias == 200 && FechadoFolga == 200)
                    FutureBuilder(
                        future: fetchProdCarrinho(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (teste == 0) {
                            _deviceDetails();

                            teste++;
                          }

                          if ((listProdutosCarrinho?.length ?? 0) != 0) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 12.0, top: 30.0),
                              child: GestureDetector(
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: <Widget>[
                                    if ((listProdutosCarrinho?.length ?? 0) ==
                                        0)
                                      Image.asset(
                                        "assets/carroInativo.png",
                                        width: 40,
                                      ),
                                    if ((listProdutosCarrinho?.length ?? 0) > 0)
                                      Image.asset(
                                        "assets/carroAtivo.png",
                                        width: 40,
                                      ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 35.0),
                                      child: CircleAvatar(
                                        radius: 8.0,
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        child: Text(
                                          (listProdutosCarrinho?.length ?? 0)
                                              .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if (listProdutosCarrinho!.isNotEmpty)
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Cart(),
                                      ),
                                    );
                                },
                              ),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 12.0, top: 30.0),
                              child: GestureDetector(
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/carroInativo.png",
                                      width: 40,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if (listProdutosCarrinho!.isNotEmpty)
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Cart(),
                                      ),
                                    );
                                },
                              ),
                            );
                          }
                        }),
                ],
              ),
              /* PUSH NOTIFICATIONS */
              /*IconButton(
                icon: Image.asset('assets/next.png'),
                onPressed: () {
                  createPlantFoodNotifications();
                },
              ),*/
            ],
          ),
          drawer: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Stack(
              children: [
                if (token != '')
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.165,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: SizedBox(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.16,
                                    width: MediaQuery.of(context).size.width *
                                        0.16,
                                    child: Initicon(
                                      backgroundColor:
                                          Color.fromRGBO(181, 142, 0, 0.9),
                                      text: ("${parts2[0]['nome']}"),
                                      size: 80,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 62, right: 20),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'BIENVENUE!',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${parts2[0]['nome']}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(145, 45, 40, 1),
                      ),
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Infromations(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.09,
                                width: MediaQuery.of(context).size.width * 0.09,
                                child: IconButton(
                                  icon: Image.asset('assets/user.png'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Infromations(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Text(
                                '   INFORMATIONS PERSONNELLES',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.5,
                                ),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: Colors.blue,
                                width: 0.0,
                                style: BorderStyle.none)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(145, 45, 40, 1),
                      ),
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropousDeNous(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.09,
                                width: MediaQuery.of(context).size.width * 0.09,
                                child: IconButton(
                                  icon: Image.asset('assets/sobre-nos.png'),
                                  onPressed: () {},
                                ),
                              ),
                              Text(
                                '   À PROPOS DE NOUS',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.5,
                                ),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: Colors.blue,
                                width: 0.0,
                                style: BorderStyle.none)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(145, 45, 40, 1),
                      ),
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MesCommandes(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.09,
                                width: MediaQuery.of(context).size.width * 0.09,
                                child: IconButton(
                                  icon: Image.asset('assets/food-delivery.png'),
                                  onPressed: () {},
                                ),
                              ),
                              Text(
                                '   MES COMMANDES',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.5,
                                ),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: Colors.blue,
                                width: 0.0,
                                style: BorderStyle.none)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(145, 45, 40, 1),
                      ),
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ContactSuport(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.09,
                                width: MediaQuery.of(context).size.width * 0.09,
                                child: IconButton(
                                  icon: Image.asset('assets/letter.png'),
                                  onPressed: () {},
                                ),
                              ),
                              Text(
                                '   CONTACT ET SUPPORT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.5,
                                ),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: Colors.blue,
                                width: 0.0,
                                style: BorderStyle.none)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(145, 45, 40, 1),
                      ),
                    ],
                  ),
                if (token != '')
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                /*child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/notification.png'),
                                                onPressed: () {},
                                              ),
                                            ),
                                            Text(
                                              '   NOTIFICATIONS',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                package: 'awesome_package',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        /*Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: CustomSwitch(
                                            value: isSwitched,
                                            onChanged: (value) {
                                              setState(() {
                                                isSwitched = value;
                                                print(isSwitched);
                                              });
                                              if (isSwitched == true) {
                                                NotificationApi
                                                    .showNotification(
                                                  title: 'teste',
                                                  body:
                                                      'OI!!!isto é a primeira push!!!',
                                                  payload: 'sarah.abs',
                                                );
                                              }
                                            },
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),*/
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: OutlinedButton(
                                  onPressed: () {
                                    GoogleSignInApi.logout();
                                    deleteToken();
                                    _onPressedLogOutButton();

                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPage(plugin: plugin)));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage('assets/logout.png'),
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                22,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                36,
                                      ),
                                      const Text('LOG OUT',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              package: 'awesome_package',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    )),
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(181, 142, 0, 0.9)),
                                  ),
                                ),
                              ),
                            ],
                          ))),
                if (token == '')
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Positioned(
                              top: MediaQuery.of(context).size.width * 0.14,
                              left: MediaQuery.of(context).size.width * 0.0,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.18,
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  child: IconButton(
                                    icon: Image.asset('assets/avatar.png'),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: Text(
                                'BIENVENUE!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              top: MediaQuery.of(context).size.width * 0.12,
                              right: MediaQuery.of(context).size.width * 0.3,
                            ),
                            Positioned(
                                top: MediaQuery.of(context).size.width * 0.21,
                                left: MediaQuery.of(context).size.width * 0.25,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'CONNECTEZ-VOUS',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: ' ICI',
                                        style: TextStyle(
                                          color: const Color(0xFFB58E00),
                                          fontFamily: 'Poppins',
                                          package: 'awesome_package',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () =>
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginPage(plugin: plugin),
                                                ),
                                                (route) => false,
                                              ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                top: MediaQuery.of(context).size.width * 0.28,
                                left: MediaQuery.of(context).size.width * 0.25,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              'SI VOUS NÊTES PAS ENCORE INSCRIT,',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )),
                            Positioned(
                              top: MediaQuery.of(context).size.width * 0.32,
                              left: MediaQuery.of(context).size.width * 0.25,
                              child: RichText(
                                text: TextSpan(
                                  text: 'INSCRIVEZ-VOUS ICI',
                                  style: TextStyle(
                                    color: const Color(0xFFB58E00),
                                    fontFamily: 'Poppins',
                                    package: 'awesome_package',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () =>
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                RegisterPage(),
                                          ),
                                          (route) => false,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(145, 45, 40, 1),
                      ),
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropousDeNous(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.09,
                                width: MediaQuery.of(context).size.width * 0.09,
                                child: IconButton(
                                  icon: Image.asset('assets/sobre-nos.png'),
                                  onPressed: () {},
                                ),
                              ),
                              Text(
                                '   À PROPOS DE NOUS',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.5,
                                ),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: Colors.blue,
                                width: 0.0,
                                style: BorderStyle.none)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(145, 45, 40, 1),
                      ),
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ContactSuport(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.09,
                                width: MediaQuery.of(context).size.width * 0.09,
                                child: IconButton(
                                  icon: Image.asset('assets/letter.png'),
                                  onPressed: () {},
                                ),
                              ),
                              Text(
                                '   CONTACT ET SUPPORT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  package: 'awesome_package',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.5,
                                ),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: Colors.blue,
                                width: 0.0,
                                style: BorderStyle.none)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(145, 45, 40, 1),
                      ),
                    ],
                  ),
                if (token == '')
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                /*child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/notification.png'),
                                                onPressed: () {},
                                              ),
                                            ),
                                            Text(
                                              '   NOTIFICATIONS',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                package: 'awesome_package',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: CustomSwitch(
                                            value: isSwitched,
                                            onChanged: (value) {
                                              setState(() {
                                                isSwitched = value;
                                                print(isSwitched);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),*/
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: OutlinedButton(
                                  onPressed: () {
                                    deleteToken();

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoginPage(plugin: plugin),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('LOGIN OU ENREGISTRÉS',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          package: 'awesome_package',
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 16)),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    )),
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(181, 142, 0, 0.9)),
                                  ),
                                ),
                              ),
                            ],
                          ))),
              ],
            ),
          ),
          body: ListView(
            primary: true,
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.9,
                child: Bolinhas(),
              ),
              BuildBanner(),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: Buildbotao(),
              ),
            ],
          ),
        ));
  }

  Widget _buildPopupDialogIndisponivel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: new AlertDialog(
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
                      Text('Indisponivel',
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
                        child: const Text("Tente mais tarde",
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

  Future<void> _onPressedLogOutButton() async {
    await plugin.logOut();
    await _updateLoginInfo();
  }

  Future<void> _getSdkVersion() async {
    final sdkVesion = await plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVesion;
    });
  }

  Future<void> _updateLoginInfo() async {
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }
}
