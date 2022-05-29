import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../notificationscreen.dart';


class notificationcontroller extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    listofnotifications();
  }
  void  sendNotification(){
    AwesomeNotifications().isNotificationAllowed().then((value) {
      if(!value){
          AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: createUniqueID(AwesomeNotifications.maxID),
            channelKey: 'test_channel',
                 displayOnForeground: true,
                  displayOnBackground: true,
                 title: "New Notification",
             body: "I hope it works",
          ));
      Fluttertoast.showToast(msg: "Notification created");
      AwesomeNotifications().actionStream.listen((event) {
        Get.to(()=>NotificationScreen());
      });
  }


  int createUniqueID(int maxValue){
    Random random = new Random();
    return random.nextInt(maxValue);
  }


  Future<void> timeschedulednotifications({DateTime? datepick})async{
        String timezoneIdentifier = AwesomeNotifications.localTimeZoneIdentifier;
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: createUniqueID(AwesomeNotifications.maxID),
                channelKey: 'scheduled',
                displayOnForeground: true,
                displayOnBackground: true,
                title: "Daily Goal Reminder",
                body: "I hope it works",
               payload: {'uuid': 'uuid-test'},
            ),
        schedule:NotificationCalendar.fromDate(date: datepick!, preciseAlarm: true)
        );
        Fluttertoast.showToast(msg: "Notification Scheduled on ${datepick}");
  }


  Future<void> listofnotifications()async{
      List<NotificationModel> activenoti = await AwesomeNotifications().listScheduledNotifications();
      for(NotificationModel schedule in activenoti){
        debugPrint(
            'pending Notification List : ['
                'id:${schedule.content!.id},uidddd${ createUniqueID(AwesomeNotifications.maxID)}'
                'title :${schedule.content!.title},'
                'schedule:${schedule.schedule.toString()}]'
        );
      }
  }
@override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
  }

}