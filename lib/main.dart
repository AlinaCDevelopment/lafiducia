import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:la_fiducia/pages/loading.dart';
import 'package:la_fiducia/pages/menu.dart';
import 'package:la_fiducia/login/register_page.dart';
import 'package:flutter/services.dart';
import 'package:la_fiducia/pages/manutencao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications()
      .initialize('resource://drawable/res_notification_app_icon', [
    NotificationChannel(
      channelKey: 'basic_chanel',
      channelName: 'Basic Notifications',
      channelDescription: 'teste Notificacao',
      defaultColor: Colors.teal,
      importance: NotificationImportance.High,
      channelShowBadge: true,
    )
  ]);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Poppins'),
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      /*'/home': (context) => Home(),*/
      '/register_page': (context) => RegisterPage(),
      '/menu': (context) => Menu(),
      '/manutencao': (context) => Manutencao(),
    },
  ));
}
