import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

Future<void> createPlantFoodNotifications() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: int.parse(uuid.v1()),
    channelKey: 'basic_chanel',
    title: '${Emojis.money_money_bag + Emojis.plant_cactus} Buy Plant Food!!!',
    body: 'Florest at 1 2 3 Main Street has 2 in stock',
    bigPicture: 'asset://assets/food2.jpeg',
    notificationLayout: NotificationLayout.BigPicture,
  ));
}
