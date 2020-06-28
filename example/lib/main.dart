import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_live_flutter/tencent_live_flutter.dart';

import 'live_pull_page.dart';
import 'live_push_page.dart';
//import 'live_push_page.dart';

Future<void> main() async {
  runApp(MyApp());
  await TencentLive.instance.init(
    licenseUrl:
        'http://license.vod2.myqcloud.com/license/v1/abd67887172ec836092ebdc8bae7e659/TXLiveSDK.licence',
    licenseKey: '1ed3f8a788ab29d81ec79d63b09fcec1',
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _HomeScreen());
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  __HomeScreenState createState() => __HomeScreenState();
}

class __HomeScreenState extends State<_HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: RaisedButton(
              child: Text("Live push"),
              onPressed: (){
                pushPage(context, LivePushPage());
              },
            ),
          ),
          Center(
            child: RaisedButton(
              child: Text("Live pull"),
              onPressed: (){
                pushPage(context, LivePullPage());
              },
            ),
          )
        ],
      ),
    );
  }

  void pushPage(final BuildContext context, final Widget page){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return page;
        }));
  }
}
