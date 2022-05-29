import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:websocketprogram/controller/downloadcontroller.dart';

import 'controller/notificationcontroller.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notificationcontroller _noti = Get.put(notificationcontroller());
  final downloadcontroller _down = Get.put(downloadcontroller());

  TimeOfDay? timeOfDay;

  Future<DateTime?> pickScheduleDate(BuildContext context,
      {required bool isUtc}) async {
    TimeOfDay? timeOfDay;
    DateTime now = isUtc ? DateTime.now().toUtc() : DateTime.now();
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(Duration(days: 365)));

    if (newDate != null) {
      timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now.add(Duration(minutes: 1))),
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

  void fun(int feature){
    switch(feature){
      case 0:
        _noti.sendNotification();
        break;

      case 1:
        schedule();
        break;
      case 2:
        _down.startdownloading();
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Custom Functions"),
      ),
      body: GridView.builder(
          itemCount: _gridtext.length,
          padding: EdgeInsets.all(12),
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
                          style: TextStyle(
                            color: Colors.white,
                          fontSize: 15,fontWeight: FontWeight.bold
                        ),),
                      ),
                      SizedBox(
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

  List<String> _gridtext = [
    "Simple Notification",
    "Scheduled Notification",
    "Download Any File",

  ];
  List<Icon> _gridicon = [
    Icon(Icons.notifications_active),
    Icon(Icons.timer),
    Icon(Icons.download),
  ];

  List<LinearGradient> _gridlineargradient = [
    LinearGradient(
        colors: [
          Color(0xFF2193b0),
          Color(0xFF6dd5ed),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
    LinearGradient(
        colors: [
          Color(0xFF2980B9),
          Color(0xFF6DD5FA),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
    LinearGradient(
        colors: [
          Color(0xFFf12711),
          Color(0xFFf5af19),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp)
  ];


}

