import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:websocketprogram/utils.dart';
import 'package:get/get.dart';

import 'controller/notificationcontroller.dart';
import 'homepage.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
     null,
      [
        NotificationChannel(
            channelName: 'Basic Notification',
            channelKey: 'test_channel',
            channelGroupKey: 'basic_tests',
            playSound: true,
            channelDescription: 'Notification for Test',
          channelShowBadge: true
            ),
        NotificationChannel(
          channelGroupKey: 'schedule_tests',
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Notifications with schedule functionality',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFF9D50DD),
          vibrationPattern: lowVibrationPattern,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          criticalAlerts: true,
            channelShowBadge: true

        ),
      ],
    channelGroups: [
        NotificationChannelGroup(
          channelGroupkey: "basic_tests",
          channelGroupName:  "Basic tests",

        ),
      NotificationChannelGroup(
          channelGroupkey: 'schedule_tests',
          channelGroupName: 'Schedule tests'
      ),

    ],
    debug: true,
  );


  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

   @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'CHat ApP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


