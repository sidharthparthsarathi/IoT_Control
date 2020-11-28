import 'package:IOT/Iot.dart';
import 'package:flutter/material.dart';
import 'package:boltiot/boltiot.dart';
import 'dart:convert';
import 'storage.dart';
import 'dart:io';
class Cred extends StatefulWidget {
  @override
  _CredState createState() => _CredState();
}

class _CredState extends State<Cred> {
  Directory directory;
  final apiInput=TextEditingController();
  final deviceInput=TextEditingController();
  List<String> parts;
  String api;
  String device;
  Widget buildAlert(String type)
  {
    return AlertDialog(
      title: Text('Error!'),
      content: Text(type),
      actions: [
        FlatButton(onPressed: 
        () {
          Navigator.of(context).pop();
        }, child: Text('OK'),)
      ],
    );
  }
  void _sendData(BuildContext context) async {
    api=apiInput.text;
    device=deviceInput.text;
    print(api);
    print(device);
    if(api.isEmpty || device.isEmpty)
    {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => buildAlert('Empty'),
      ),
      );
      return;
    }
    final Bolt myBolt=new Bolt(api, device);
    final respond=await myBolt.isOnline();
    final jsonUser = jsonDecode(respond.body);
    final output=jsonUser['value'];
    final bool isNotIot=(output!='online' && output!='offline')==true;
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => isNotIot ? AlertDialog(
    title: Text("My title"),
    content: Text(output),
    actions: [
      FlatButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: Text('OK'))
    ],
  )
 : IoT(apiId: api, deviceId: device),
        ),
        );
  }
  void loadFromStorage(BuildContext context) async
  {
    final foldername='IoT';
     this.directory = Directory("storage/emulated/0/$foldername");
    if (!await directory.exists()){
        print("No Path");
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => buildAlert('File Not Exists\nPlease Save The Credentials'),),);
      }
      //return;
    readContent().then((String value) {
      setState(() {
       parts=value.split(" ");
       api=parts[0];
       device=parts[1];
       apiInput.value=new TextEditingValue(text: api);
       deviceInput.value=new TextEditingValue(text: device);
       print(api);
       print(device);
      });
    });
  }
  snackBar(BuildContext context,String display,int valueSec) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.fixed,
    duration: Duration(milliseconds: valueSec),
    content: Text(display),
    );
  Scaffold.of(context).showSnackBar(snackBar);
}
  @override
  Widget build(BuildContext context) {
    final appBar=AppBar(
        title: Text('Credentials'),
        centerTitle: true,
      );
    final mediaQuery=MediaQuery.of(context);
    final height=mediaQuery.size.height-mediaQuery.padding.top-appBar.preferredSize.height;
    final orientation=MediaQuery.of(context).orientation==Orientation.landscape;
    return Scaffold(
      appBar: appBar,
      body: Builder(
              builder: (context) => SingleChildScrollView(
                child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: height*0.5,
                      width: mediaQuery.size.width*0.8,
                      child: Column(
                        children: [
                TextField(decoration: const InputDecoration(labelText: 'API-Key',
                hintText: 'Enter API-Key'),//using const to avoid performance drop
                controller: apiInput,
                ),
                TextField(decoration: const InputDecoration(labelText: 'Device-Id',
                hintText: 'Enter Device-ID'),//using const to avoid performance drop
                  controller: deviceInput,
                ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    color: Colors.green.shade900,
                    onPressed: (){
                      _sendData(context);
                    }, child: Text('Enter')
                    ),
                    FlatButton(
                    color: Colors.green.shade900,
                    onPressed: () {
                          api = apiInput.text;
                          device=deviceInput.text;
                          final String save=api+' '+device;
                      if(api.isEmpty || device.isEmpty)
                                    {
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => buildAlert('Empty'),
                                     ),
                                     );
                                return;
                                      }
                      writeContent(save);
                      snackBar(context,'Saved To $directory',2000);
                    }, child: Text('Save Credentials')
                    ),
          RaisedButton(
            color: Colors.green.shade900,
          child: Text('Load From Storage'),
          onPressed: () {
          snackBar(context,'Loaded',200);
          loadFromStorage(context);
          },
        ), 
        ]
            ),
        ),
      ),
    );
  }
}