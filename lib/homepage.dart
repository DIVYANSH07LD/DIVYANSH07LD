import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:websocketprogram/controller/downloadcontroller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:websocketprogram/controller/signInController.dart';
import 'controller/notificationcontroller.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = '';
  final notificationcontroller _noti = Get.put(notificationcontroller());
  final downloadcontroller _down = Get.put(downloadcontroller());
  final GoogleSignController _googleSignController = Get.put(GoogleSignController());

  TimeOfDay? timeOfDay;
  String deviceTokentoSendNotification = '';
  Future<DateTime?> pickScheduleDate(BuildContext context,
      {required bool isUtc}) async {
    TimeOfDay? timeOfDay;
    DateTime now = isUtc ? DateTime.now().toUtc() : DateTime.now();
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(const Duration(days: 365)));

    if (newDate != null) {
      timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 1))),
      );

      if (timeOfDay != null) {
        return isUtc
            ? DateTime.utc(newDate.year, newDate.month, newDate.day,
            timeOfDay.hour, timeOfDay.minute)
            : DateTime(newDate.year, newDate.month, newDate.day, timeOfDay.hour,
            timeOfDay.minute);
      }
    }
    return null;
  }
  void schedule()async{
    DateTime? current =await pickScheduleDate(context,isUtc: false);
            print("________________${current}");
              if(current!=null){
                  _noti.timeschedulednotifications(datepick: current);
              }
  }


  @override
  void initState(){
    ///when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
        if(message!=null){
            print("New Notification");
        }
    });
    ///when app is open
    FirebaseMessaging.onMessage.listen((message) {
      print(FirebaseMessaging.onMessage.listen);
        if(message.notification!=null){
          title = message.notification!.title.toString();
              print(message.notification!.title.toString());
              print(message.notification!.body.toString());
              print(message.data.toString());
        }
    });
    ///when app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print(FirebaseMessaging.onMessageOpenedApp.listen);
        if(message.notification!=null){
          print(message.notification!.title.toString());
          print(message.notification!.body.toString());
          print(message.data.toString());
        }
    });
  }

  void fun(int feature){
    switch(feature){
      case 0:
        _noti.sendNotification(
            title: title.toString()
        );
        break;
      case 1:
        schedule();
        break;
      case 2:
        _down.startdownloading();
        break;
      case 3:
        _googleSignController.loginWithGoogle();
        break;
    }
  }

  ///get fcm token
  Future<void> _getfcmToken()async{
      final FirebaseMessaging _fcm = FirebaseMessaging.instance;
      final token = await _fcm.getToken();
      deviceTokentoSendNotification = token.toString();
      print(deviceTokentoSendNotification);
  }

  @override
  Widget build(BuildContext context) {
    _getfcmToken();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Custom Functions"),
      ),
      body: GridView.builder(
          itemCount: _gridtext.length,
          padding: const EdgeInsets.all(12),
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
            mainAxisSpacing: 12

      ),
          itemBuilder: (BuildContext context,index){
        return InkWell(
          onTap: (){
            fun(index);
          },
          child: Card(
            borderOnForeground: true,
            child: Container(
              decoration: BoxDecoration(
                gradient: _gridlineargradient[index],
              ),
              child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(_gridtext[index].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          fontSize: 15,fontWeight: FontWeight.bold
                        ),),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Icon(_gridicon[index].icon,color: Colors.indigo.shade50,)
                    ],
                  )),
            ),
          ),
        );
      })
      //   Center(
      //   child: Column(
      //     children: [
      //       ElevatedButton(
      //         onPressed: () {
      //           _noti.sendNotification();
      //           },
      //         child: Text('Notification'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () async{
      //         DateTime? current =await pickScheduleDate(context,isUtc: false);
      //         print("________________${current}");
      //           if(current!=null){
      //               _noti.timeschedulednotifications(datepick: current);
      //           }
      //           },
      //         child: Text('Scheduled Notification'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () async{
      //               _noti.listofnotifications();
      //
      //           },
      //         child: Text('Scheduled Notification'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  final List<String> _gridtext = [
    "Simple Notification",
    "Scheduled Notification",
    "Download Any File",
    "Google SignIn"
  ];
  final List<Icon> _gridicon = [
    const Icon(Icons.notifications_active),
    const Icon(Icons.timer),
    const Icon(Icons.download),
    const Icon(Icons.login)
  ];

  final List<LinearGradient> _gridlineargradient = [
    const LinearGradient(
        colors: [
          Color(0xFF2193b0),
          Color(0xFF6dd5ed),
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
    const LinearGradient(
        colors: [
          const Color(0xFF2980B9),
          const Color(0xFF6DD5FA),
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
    const LinearGradient(
        colors: [
          Color(0xFFf12711),
          const Color(0xFFf5af19),
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
    const LinearGradient(
        colors: [
          Color(0xFF22c1c3),
           Color(0xFFfdbb2d),
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
  ];


}

