import 'dart:core';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class NotificationUtils{

  static Future<bool> showNotificationPermissionPage()async{
        await AwesomeNotifications().showNotificationConfigPage();
        return await AwesomeNotifications().isNotificationAllowed();
  }


  static Future<bool> requestPermissiontoSendNotification(BuildContext context)async{

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if(!isAllowed){
        await showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            content: Text("allow notification"),
            actions: [
              ElevatedButton(
                  onPressed: ()async{
              isAllowed = await  AwesomeNotifications().requestPermissionToSendNotifications();
              Navigator.pop(context);
              }, child: Text("YES"))
            ],
          );
        });
    }
    return isAllowed;
  }

  static Future<void> showBasicNotification(int id)async{
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          // icon: ,
          channelKey: 'basic_channel',
          // groupKey: '',
          wakeUpScreen: true,

          autoDismissible: false,
          color: Colors.red,
          displayOnForeground: true,
          // groupKey: 'basic_tests',
          title: "Successfully send local notification",
          body: "First local notification",

        ),
    );
  }

}