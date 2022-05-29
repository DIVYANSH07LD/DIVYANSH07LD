import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class downloadcontroller extends GetxController{



  Dio dio = Dio();

  var progress = 0.0.obs;

  Future<bool> startdownloading()async{
          String url = "https://static.remove.bg/remove-bg-web/588fbfdd2324490a4329d4ad22d1bd436e1d384a/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg";
    // file of name which we save in our storage
          String fileName = "File.jpg";

          Directory? directory;
          try{
            if(Platform.isAndroid){
                if(await permissionstatus(Permission.storage)){
                  directory = await getExternalStorageDirectory();
                  print("${directory!.path}");

                  String newPath = "";
                  List<String>  folders = directory.path.split('/');

                  for(int i = 1;i<folders.length;i++)
                    {
                      String folder = folders[i];
                      // print(folder);
                        if(folder!="Android"){
                            newPath += "/"+folder;
                            print(newPath);
                        }
                        else{
                              break;
                        }
                    }
                  newPath = newPath +'/CustomAPP';
                  directory = Directory(newPath);
                  // print(directory.path);
                }else{
                  return false;
                }
            }
            else{
              if(await permissionstatus(Permission.photos)){
                  directory = await getTemporaryDirectory();
              }
              else{
                return false;
              }
              if(await directory.exists()){
                await directory.create(
                  recursive: true
                );
              }
              if(await directory.exists()){
                  File savefile =  File(directory.path+'/$fileName');
                  await dio.download(url, savefile,onReceiveProgress: (download,totalsize){
                    progress.value = download/totalsize;
                  },
                      deleteOnError: true
                  );
                  return true;
              }
            }
          }
          catch(e){
            print(e);
          }

          return false;
  }



  Future<bool> permissionstatus(Permission permission)async{
     if(await permission.isGranted){
       return true;
     }
     else{
       var result = await permission.request();
       if(result == permission.isGranted){
         return true;
       }
       else{
         return false;
       }
     }

  }
    //get file path
    Future  _getfilepath(String fileName) async{
      final dir = await getApplicationDocumentsDirectory();
      return "${dir.path}/$fileName";
    }

    @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startdownloading();
  }


}