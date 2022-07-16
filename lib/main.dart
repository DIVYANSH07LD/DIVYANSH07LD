import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'homepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Future<void> backGroundHandler(RemoteMessage message)async{
    print(message.data.toString());
    print(message.notification);
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }

  FirebaseMessaging.onBackgroundMessage(backGroundHandler);

  // AwesomeNotifications().initialize(
  //    null,
  //     [
  //       NotificationChannel(
  //           channelName: 'Basic Notification',
  //           channelKey: 'test_channel',
  //           channelGroupKey: 'basic_tests',
  //           playSound: true,
  //           channelDescription: 'Notification for Test',
  //         channelShowBadge: true
  //           ),
  //       NotificationChannel(
  //         channelGroupKey: 'schedule_tests',
  //         channelKey: 'scheduled',
  //         channelName: 'Scheduled notifications',
  //         channelDescription: 'Notifications with schedule functionality',
  //         defaultColor: Color(0xFF9D50DD),
  //         ledColor: Color(0xFF9D50DD),
  //         vibrationPattern: lowVibrationPattern,
  //         importance: NotificationImportance.High,
  //         defaultRingtoneType: DefaultRingtoneType.Alarm,
  //         criticalAlerts: true,
  //           channelShowBadge: true
  //
  //       ),
  //     ],
  //   channelGroups: [
  //       NotificationChannelGroup(
  //         channelGroupkey: "basic_tests",
  //         channelGroupName:  "Basic tests",
  //
  //       ),
  //       NotificationChannelGroup(
  //         channelGroupkey: 'schedule_tests',
  //         channelGroupName: 'Schedule tests'
  //     ),
  //
  //   ],
  //   debug: true,
  // );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

   @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Flutter Custom App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


