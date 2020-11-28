import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:boltiot/boltiot.dart';
import 'dart:convert';
enum Selection
{
  On,
  Off,
  Disco,
  Default
}
class IoT extends StatefulWidget {
  final String apiId;
  final String deviceId;
  IoT({Key key, @required this.apiId,@required this.deviceId}) : super(key: key);
  @override
  _IoTState createState() => _IoTState();
}
class _IoTState extends State<IoT> {
  Selection select;
  Color bgColor;
  String output='';
  String output1='';
  int i,j;
  dynamic jsonUser='';
  Bolt myBolt;
  void onn() async {
    final api=widget.apiId;
    final device=widget.deviceId;
    this.myBolt = new Bolt(api,device);//declaring Bolt object named myBolt
  var respond=await myBolt.isOnline();
  setState(() {
      jsonUser = jsonDecode(respond.body);
      output=jsonUser['value'];
      output1=jsonUser['value'];
  });
  print(output1);
  print(widget.apiId);
  print(output);
  }
  @override
  void initState() {
     const availableColors=[Colors.blueGrey,Colors.brown,Colors.green,Colors.blue,Colors.red,Colors.deepOrange,Colors.pink];
    bgColor=availableColors[Random().nextInt(8)];
    select=Selection.Default;
    onn();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final appBar=AppBar(title: Text('Device Control'),
      centerTitle: true,
      );
      final MediaQueryData mediaQuery=MediaQuery.of(context);
      final orientation=mediaQuery.orientation==Orientation.landscape;
      final height=mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top;
      final width=mediaQuery.size.width;
    return Scaffold(
      appBar: appBar,
      body:Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        child: SingleChildScrollView(
                  child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(height: height*0.04,),
              Container(
                height: orientation ? height*0.12 : height*0.07,
                //width: orientation ? width*0.6 : width*0.8,
                child: RaisedButton(
                  color: select==Selection.On ? Colors.red.shade900 : Colors.teal.shade400,
                  highlightColor: Colors.indigo,
                  child: Text('ON'),
                    onPressed: (output=='offline')==true ? () {
                      print('Device is $output1');
                    } : () async {
                      setState(() {
                        select=Selection.On;
                        output1='Device-Status-ON';
                        j=255;
                      });
                      dynamic response;
                      response=await myBolt.digitalWrite('0', 'HIGH');
                      var respond=jsonDecode(response.body)['value'];
                      print(respond);
                    }
                ),
              ),
              SizedBox(height: height*0.04,),
                Container(
                  height: orientation ? height*0.12 : height*0.07,
                  //width: orientation ? width*0.6 : width*0.8,
                  child: RaisedButton(
                  color: select==Selection.Disco ? Colors.red.shade900 : Colors.teal.shade400,
                  highlightColor: Colors.indigo,
                  child: Text('DISCO'),
                    onPressed: (output=='offline')==true ? () {
                      print('Device is $output1');
                    } :
                      () async {
                      setState(() {
                        select=Selection.Disco;
                        i=1;
                        j=1;
                        output1='Device-Status-Disco';
                      });
                      print(j);
                      dynamic response="";
                      while(i<256)
                      {
                      if(j==255 || j==0 || select==Selection.Default)
                      {
                        if(j==0)
                        {
                          await myBolt.analogWrite('0', j);
                          break;
                        }
                        if(j==255)
                        {
                          //await myBolt.digitalWrite('0', 'HIGH');
                          break;
                        }
                        if(select==Selection.Default)
                        {
                          await myBolt.digitalWrite('0', 'LOW');
                          break;
                        }
                      }
                      response=await myBolt.analogWrite('0',i);
                      i=i+255;
                      if(i>=256)
                      {
                        i=255;
                        while(i<=255)
                        {
                          response=await myBolt.analogWrite('0',i);
                          i=i-255;
                          if(i<=1)
                          {
                            i=1;
                            break;
                          }
                        }
                      }
                      }
                      print(response.body);
                    }
              ),
                ),
                SizedBox(height: height*0.04,),
              Container(
                height: orientation ? height*0.12 : height*0.07,
                //width: orientation ? width*0.6 : width*0.8,
                child: RaisedButton(
                 color: select==Selection.Off ? Colors.red.shade900 : Colors.teal.shade400,
                  highlightColor: Colors.indigo,
                  child: Text('OFF'),
                    onPressed: (output=='offline')==true ? () {
                      print('Device is $output1');
                    } : ()async{
                      var response=await myBolt.digitalWrite('0','LOW');
                      print(response.body);
                      setState(() {
                        select=Selection.Off;
                        output1='Device-Status-OFF';
                        j=0;
                      });
                    }
                ),
              ),
              SizedBox(height: height*0.05,),
              Container(
                height: orientation ? height*0.27 : height*0.3,
                width: orientation ? width*0.55 : width*0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade500,
                      Colors.red.shade200,
                      Colors.blue.shade400,
                      Colors.green.shade400,
                      Colors.yellow.shade300,
                      Colors.lightBlueAccent,
                      Colors.blueAccent,
                      Colors.purple,
                      Colors.orange.shade500,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(output1.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height*0.05,),
                Container(
                height: orientation ? height*0.11 : height*0.07,
                //width: orientation ? width*0.6 : width*0.8,
                    child: FlatButton(
                      child: Text('Reload'),
                      color: Colors.blue,
                      onPressed: () async {
                          await myBolt.digitalWrite('0', 'LOW');
                      setState(() {
     const availableColors=[Colors.blueGrey,Colors.brown,Colors.green,Colors.blue,Colors.red,Colors.orange,Colors.black,Colors.pink];
    bgColor=availableColors[Random().nextInt(8)];
    onn();
    select=Selection.Default;
  });
                    }),
                  ),
                  SizedBox(height: height*0.04),
            ],
          ),
        ),
        ),
    );
  }
}