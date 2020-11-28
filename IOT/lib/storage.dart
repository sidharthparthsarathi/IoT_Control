import 'dart:io';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
  Future<String> get localPath async {//Local Path For Storing Data
  final foldername='IoT';
    final directory = Directory("storage/emulated/0/$foldername");//Changed This From Final To Var
    var status = await Permission.storage.status;
    if (!status.isGranted) {
    await Permission.storage.request();
    }
     if (!await directory.exists()){
        //print("Creating Path");
        directory.create();
      }
    return directory.path;
  }
  Future<File> get localFile async {//Local File
    final path= await localPath;
    return File('$path/Credentials.txt');
  }


  Future<String> readContent() async {//ReadContent
    try {
      var file = await localFile;
      // Read the file

      String contents = await file.readAsString();
      // Returning the contents of the file
      return contents;
    } catch (e) {
      // If encountering an error, return
      return 'Error!';
    }
  }

  Future<File> writeContent(String data) async {//Write Content
    var file = await localFile;
    // Write the file
    return file.writeAsString(data);
  }

  Future<File> deleteContent(String data) async {//Write Content
    var file = await localFile;
    // Write the file
    return file.writeAsString(data);
  }