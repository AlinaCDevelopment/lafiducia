import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:la_fiducia/pages/loading.dart';
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
import 'package:awesome_notifications/awesome_notifications.dart';

class CheckOut3 extends StatefulWidget {
  @override
  _CheckOut3State createState() => _CheckOut3State();
}

class _CheckOut3State extends State<CheckOut3> {
  @override
  void initState() {
    super.initState();
  }

  Future fetchStr() async {
    await new Future.delayed(const Duration(seconds: 2), () {});
    return 'Hello World';
  }

  Future createPlantFoodNotifications() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 4,
      channelKey: 'basic_chanel',
      title: 'La fiducia commande!!!',
      body: 'Votre commande a été passée avec succès!',
      /*bigPicture: 'asset://assets/notification_map.png',
      notificationLayout: NotificationLayout.BigPicture,*/
    ));
  }

  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Colors.white,

            titleSpacing: 0,
            leadingWidth: 60,
            centerTitle: true,
            title: Text('CHECK-OUT',
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
          bottomNavigationBar: Container(
              color: Color.fromRGBO(45, 61, 75, 1),
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                      future: fetchStr(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          createPlantFoodNotifications();
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            alignment: Alignment.center,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Menu(),
                                  ),
                                );
                              },
                              child: const Text('REVENIR AU MENU',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 15)),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(181, 142, 0, 0.9)),
                              ),
                            ),
                          );
                        }
                        return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(181, 142, 0, 0.9)));
                      })
                ],
              )),
          body: Center(
            child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: RichText(
                  textAlign: TextAlign.center,
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
                              'Vôtre commande est passez avec succès, rappelez nous si vous n`avez pas reçu de confirmation dans les 5 minutes à venir dans nos horaires d`ouverture. 268 743 15 ',
                          style: TextStyle(
                            overflow: TextOverflow.clip,
                            color: Color.fromRGBO(45, 61, 75, 1),
                            fontFamily: 'Poppins',
                            package: 'awesome_package',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      TextSpan(
                        text:
                            '                                                                                                                    ',
                        style: TextStyle(
                          color: const Color(0xFFB58E00),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: SizedBox(height: 30)),
                      TextSpan(
                        text: 'Merci',
                        style: TextStyle(
                          color: const Color(0xFFB58E00),
                          fontFamily: 'Poppins',
                          package: 'awesome_package',
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )),
          ),

          /*Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                  'J´ACCEPTE LA COMMUNICATION DE MES DONNÉES DANS LE BUT DE TRAITER LES COLIS ET DE LES DISTRIBUER SELON LES CONDITIONS ÉTABLIES DANSLES INFORMATIONS SUR LA PROTECTION DES DONNÉES.',
                  textAlign: TextAlign.center,
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
        )*/
        ));
  }
}
