import 'package:flutter/cupertino.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  late AndroidInitializationSettings initializationSettingsAndroid;
  late DarwinInitializationSettings initializationSettingsIOs;
  late InitializationSettings initSetttings;

  Future<void> setup() async {
    initializationSettingsAndroid =
        const AndroidInitializationSettings('notification_icon');
    initializationSettingsIOs = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    await localNotification.initialize(initSetttings);
  }

  void onSelectNotification(String payload) {}

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {},
          child: const Text('Okay'),
        ),
      ],
    );
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('id', 'channel ',
            channelDescription: 'description',
            priority: Priority.high,
            importance: Importance.max,
            // sound: '@raw/notificationsound',
            playSound: true);
    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails(
            presentSound: true, sound: 'notificationsound');
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);
    await localNotification.show(0, 'title', 'body', notificationDetails);
  }

  Future<void> scheduleNotification(String tipoActivity, String descripcion,
      DateTime scheduledNDateTime, int idChannel) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('second id', 'second channel ',
            channelDescription: 'second description',
            priority: Priority.high,
            importance: Importance.max,
            // sound: '@raw/notificationsound',
            playSound: true);
    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);
    await localNotification.zonedSchedule(
        idChannel,
        tipoActivity,
        descripcion,
        tz.TZDateTime.from(
          scheduledNDateTime,
          tz.local,
        ),
        notificationDetails,
        payload:
            'Realizar funcion con el para elegir la pagina segun la notificacion',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> showDailyAtTime(List<String> nombreApellido, int hora, int min,
      String mensaje, int idChannel, String channelName) async {
    String saludo = (hora <= 11)
        ? 'Buenos dias'
        : (hora <= 18)
            ? 'Buenas tardes'
            : 'Buenas noches';
    var time = DateTime(hora, min, 0);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'CHANNEL_ID ${idChannel.toString()}', 'CHANNEL_NAME $channelName',
            channelDescription: "CHANNEL_DESCRIPTION $channelName",
            importance: Importance.max,
            priority: Priority.high,
            // sound: '@raw/notificationsound',
            playSound: true);
    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);
    String nombre = nombreApellido[0];
    String apellido = nombreApellido[1];
    await localNotification.zonedSchedule(
        idChannel,
        '$saludo $nombre  $apellido',
        mensaje,
        tz.TZDateTime.from(
          time,
          tz.local,
        ),
        notificationDetails,
        payload: 'Test Payload',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotification(int id) async {
    await localNotification.cancel(id);
  }

  Future<void> deleteAllNotification() async {
    await localNotification.cancelAll();
  }
}
