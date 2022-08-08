import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService extends GetxService{
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  IOSInitializationSettings? initializationSettingsIOS;
  InitializationSettings? initializationSettings;


  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page

  }


  Future showNotification(String title,String body)async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }

  void handleSendNotification(String playerId,String title,String content,String chatId) async {
    var notification = OSCreateNotification(
        playerIds: [playerId],
        content: content,
        additionalData: {"chatId":chatId},
        heading: title,
        collapseId: playerId
        );
    await OneSignal.shared.postNotification(notification);
  }

  setOneSignalNotificationSettings()async{
    OneSignal.shared.setLogLevel(OSLogLevel.error, OSLogLevel.none);
    await OneSignal.shared.setAppId("8a0c8f0b-ccd8-4520-abd7-c1ff050650ba");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted)async{
    });
  }

  @override
  void onInit() {
    initializationSettingsIOS=IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,);
    flutterLocalNotificationsPlugin.initialize(initializationSettings!,);
    setOneSignalNotificationSettings();
    super.onInit();
  }
}