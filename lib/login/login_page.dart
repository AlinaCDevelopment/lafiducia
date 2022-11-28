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
import 'package:la_fiducia/login/google_signin_api.dart';
import 'package:la_fiducia/widgets/colors.dart';
import 'package:la_fiducia/widgets/socialButtons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:la_fiducia/login/sharedPref.dart';
import 'package:la_fiducia/pages/completRegistGoogle.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  final FacebookLogin plugin;

  const LoginPage({Key? key, required this.plugin}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final plugin = FacebookLogin(debug: false);
  bool _isLoading = false;
  var errorMsg;
  final TextEditingController mailController = new TextEditingController();
  final TextEditingController mailControllerRecupPass =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  var CodigoRecuperarPass;

  String? _sdkVersion;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;
  String? nomeUser;
  String mailez = '';

  Future<void> _updateLoginInfo() async {
    final plugin = widget.plugin;
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;
    String? nomeUser;

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
      nomeUser = profile!.name;
      _email = email;
      _imageUrl = imageUrl;
    });
  }

  Future<void> _getSdkVersion() async {
    final sdkVesion = await widget.plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVesion;
    });
  }

  String identifier = '';
  String tipooo = '';

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        setState(() {
          identifier = build.androidId;
          tipooo = 'android';
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

  Future<void> _onPressedLogInButton() async {
    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
      /*FacebookPermission.userFriends,*/
    ]);
    await _updateLoginInfo();
  }

  @override
  void initState() {
    super.initState();
    mailController.addListener(onListen);
    mailControllerRecupPass.addListener(onListen);
    passwordController.addListener(onListen);
  }

  @override
  void dispose() {
    mailController.removeListener(onListen);
    mailControllerRecupPass.addListener(onListen);
    passwordController.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return buildDraweeer(context);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  var i = 0;

  WillPopScope buildDraweeer(BuildContext context) {
    if (i == 0) {
      _deviceDetails();
      _getSdkVersion();
      _updateLoginInfo();
      i++;
    }
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
            title: Text('LOGIN',
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
          body: Container(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 12),
                            child: TextFormField(
                              controller: mailController,
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
                                  suffixIcon: mailController.text.isEmpty
                                      ? Container(width: 0)
                                      : IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color:
                                                Color.fromRGBO(181, 142, 0, 1),
                                          ),
                                          onPressed: mailController.clear,
                                        )),
                              autofillHints: [AutofillHints.email],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromRGBO(181, 142, 0, 1),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 12),
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
                                            color:
                                                Color.fromRGBO(181, 142, 0, 1),
                                          ),
                                          onPressed: passwordController.clear,
                                        )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  child: Text(
                    'MOT DE PASSE OUBLIÉ?',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      package: 'awesome_package',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 11.5,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    primary: Color.fromRGBO(45, 61, 75, 1),
                  ),
                  onPressed: () {
                    Widget _buildPopupRecupPass(BuildContext context) {
                      return AlertDialog(
                        actions: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 4.5,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                  Column(
                                    children: [
                                      Text("Entrer l'adresse e-mail",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(181, 142, 0, 1),
                                            fontFamily: 'Poppins',
                                            package: 'awesome_package',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Color.fromRGBO(181, 142, 0, 1),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 8),
                                        child: TextFormField(
                                          controller: mailControllerRecupPass,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: "ADRESSE E-MAIL*",
                                            hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  181, 142, 0, 1),
                                              fontFamily: 'Poppins',
                                              package: 'awesome_package',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            suffixIcon: mailControllerRecupPass
                                                    .text.isEmpty
                                                ? Container(width: 0)
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Color.fromRGBO(
                                                          181, 142, 0, 1),
                                                    ),
                                                    onPressed:
                                                        mailControllerRecupPass
                                                            .clear,
                                                  ),
                                          ),
                                          autofillHints: [AutofillHints.email],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          RecuperaPass(String mail) async {
                                            Map data = {
                                              "email": mail,
                                            };

                                            var jsonResponse = null;

                                            var response = await http
                                                .post(
                                              Uri.parse(
                                                  '${ApiDevLafiducia}/recuperar-password/'),
                                              body: data,
                                            )
                                                .then((result) {
                                              print(result.statusCode);
                                              print(result.body);

                                              if (result.statusCode == 200) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      _buildPopupMailEnviado(
                                                          context),
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      _buildPopupMailNaoRegistado(
                                                          context),
                                                );
                                              }
                                            });

                                            jsonResponse =
                                                json.decode(response.body);
                                          }

                                          RecuperaPass(
                                              mailControllerRecupPass.text);
                                        },
                                        child: const Text("Envoyer",
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                package: 'awesome_package',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                                fontSize: 16)),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color.fromRGBO(
                                                        181, 142, 0, 0.9)),
                                            side: MaterialStateProperty.all(
                                                BorderSide(
                                                    color: Color.fromRGBO(
                                                        181, 142, 0, 0.9),
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

                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupRecupPass(context),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        var email = mailController.text;
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email);

                        if (emailValid == true) {
                          if (passwordController.text == '') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialogPass(context),
                            );
                          } /* else if ('Diferente de 1') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogMailNaoRegist(context),
                                );
                              } */
                          else {
                            signIn(
                                mailController.text, passwordController.text);
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogMail(context),
                          );
                        }
                      },
                      child: const Text('LOGIN',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 16)),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(181, 142, 0, 0.9)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Center(
                        child: Text(
                          'OU ENTREZ AVEC',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ),
                    CustomWidgets.socialButtonRect('Login with Google',
                        googleColor, FontAwesomeIcons.googlePlusG, onTap: () {
                      signInGoogle();
                    }),
                    CustomWidgets.socialButtonRect(
                        'Login with Facebook',
                        facebookColor,
                        FontAwesomeIcons.facebookF, onTap: () async {
                      _onPressedLogInButton();
                      Future.delayed(Duration(seconds: 3), () {
                        signInFaceBook();
                      });
                    }),
                    if (tipooo == 'iOS')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Container(
                          height: 40,
                          child: SignInWithAppleButton(
                            onPressed: () async {
                              /*if (!await SignInWithApple.isAvailable()) {*/
                              final credential =
                                  await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                              );
                              Future signInApple() async {
                                signInJaRegistado(String appleId) async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  var response = await http.get(Uri.parse(
                                      '${ApiDevLafiducia}/verifica-appleId/${appleId}/'));

                                  if (response.statusCode == 200) {
                                    final jsonResponse =
                                        json.decode(response.body.toString());
                                    if (jsonResponse != null) {
                                      save('token', jsonResponse['token']);

                                      var prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'token', jsonResponse['token']);

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Menu(),
                                        ),
                                      );
                                    }
                                  } else if (response.statusCode == 400) {
                                    String data = "$credential";
                                    final dateList = data.split(",");

                                    String nomeApple =
                                        dateList[1] + dateList[2];
                                    String mailApple = dateList[3];

                                    String codApple = dateList[0];
                                    final codAppleFinal = codApple.split("(");

                                    /*Future.delayed(Duration(milliseconds: 800),
                                        () {*/
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Confirm(
                                          mail: mailApple,
                                          codigoApple: codAppleFinal[1],
                                          nome: nomeApple,
                                          tipoRegisto: 1.toString(),
                                          registoGoogleFace: 'Apple',
                                        ),
                                      ),
                                    );
                                    /* });*/
                                  }
                                }

                                String data = "$credential";
                                final dateList = data.split(",");

                                String codApple = dateList[0];
                                final codAppleFinal = codApple.split("(");

                                String nomeApple = dateList[1] + dateList[2];
                                String mailApple = dateList[3];

                                signInJaRegistado(codAppleFinal[1]);
                              }

                              signInApple();

                              // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                              // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                              /*} else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialogVersionIos(context),
                                );
                              }*/
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Center(
                          child: Text(
                            'NOUVEAUX CLIENTS',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(181, 142, 0, 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Center(
                    child: Text(
                      'Si vous n êtes pas encore inscrit, inscrivez-vous ici.',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        package: 'awesome_package',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => RegisterPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('CRÉER UN COMPTE',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              package: 'awesome_package',
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 16)),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(181, 142, 0, 0.9)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future signInGoogle() async {
    final user = await GoogleSignInApi.login();

    signInJaRegistado(String mail) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response = await http
          .get(Uri.parse('${ApiDevLafiducia}/verifica-email/${mail}/'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body.toString());
        if (jsonResponse != null) {
          save('token', jsonResponse['token']);

          var prefs = await SharedPreferences.getInstance();
          prefs.setString('token', jsonResponse['token']);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Menu(),
            ),
          );
        }
      } else if (response.statusCode == 400) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Confirm(
              mail: user!.email.toString(),
              codigoApple: '00000000',
              nome: user.displayName.toString(),
              tipoRegisto: 1.toString(),
              registoGoogleFace: 'Google',
            ),
          ),
        );
      }
    }

    signInJaRegistado(user!.email);
  }

  Future signInFaceBook() async {
    String MailX = _email.toString();

    signInJaRegistado(String mail) async {
      var response = await http
          .get(Uri.parse('${ApiDevLafiducia}/verifica-email/${mail}/'));

      if (_email.toString() == 'null') {
        setState(() {
          mailez = "Entrez l'e-mail";
        });
      } else {
        setState(() {
          mailez = MailX;
        });
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body.toString());
        if (jsonResponse != null) {
          save('token', jsonResponse['token']);

          var prefs = await SharedPreferences.getInstance();
          prefs.setString('token', jsonResponse['token']);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Menu(),
            ),
          );
          /*signInFaceBook();*/
        }
      } else if (response.statusCode == 400) {
        Future.delayed(Duration(milliseconds: 1000), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Confirm(
                mail: mailez,
                codigoApple: '00000000',
                nome: _profile!.name.toString(),
                tipoRegisto: 2.toString(),
                registoGoogleFace: 'Facebook',
              ),
            ),
          );
        });
      }
    }

    signInJaRegistado(MailX);
  }

  signIn(String mail, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': mail, 'password': pass};
    var jsonResponse = null;
    var response =
        await http.get(Uri.parse('${ApiDevLafiducia}/login/${mail}/${pass}'));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      /*print(jsonResponse);*/
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        save('token', jsonResponse['token']);

        var prefs = await SharedPreferences.getInstance();
        prefs.setString('token', jsonResponse['token']);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Menu()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      jsonResponse = json.decode(response.body);
      if (jsonResponse['sucess'] == 0) {
        Future<http.Response> postReenvio() async {
          var dataReenvio = {
            "email": jsonResponse['email'].toString(),
            "uniqueCode": jsonResponse['uniqueCode'].toString(),
          };

          var res = await http.post(
              Uri.parse('${ApiDevLafiducia}/reenviar-email/'),
              body: dataReenvio);

          return res;
        }

        showDialog(
          context: context,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: AlertDialog(
              actions: <Widget>[
                SizedBox(
                    height: MediaQuery.of(context).size.height / 5.5,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        Column(
                          children: [
                            Text(jsonResponse['message'],
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
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
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
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: AlertDialog(
              actions: <Widget>[
                SizedBox(
                    height: MediaQuery.of(context).size.height / 5.5,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        Column(
                          children: [
                            Text(jsonResponse['message'],
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
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
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
          ),
        );
      }
    }
  }

  Widget _buildPopupDialogVersionIos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      Text(
                          "Cet appareil n'est pas disponible pour la connexion Apple.",
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

  Widget _buildPopupMailEnviado(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Column(
                  children: [
                    Text("E-mail envoyé avec succès",
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
                  height: MediaQuery.of(context).size.height / 60,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                  width: MediaQuery.of(context).size.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok",
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

  Widget _buildPopupMailNaoRegistado(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Column(
                  children: [
                    Text("E-mail non enregistré",
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
                  height: MediaQuery.of(context).size.height / 60,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                  width: MediaQuery.of(context).size.width,
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

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Email não verificado'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Tente Novamente"),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
        new TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Reenviar email'),
        ),
      ],
    );
  }

  Widget _buildPopupDialogMailNaoRegist(BuildContext context) {
    return new AlertDialog(
      title: const Text('A cota ainda não se encontra registada'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Tente Novamente"),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
