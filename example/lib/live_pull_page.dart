import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_live_flutter/tencent_live_flutter.dart';

const _testPullUrl = 'http://5815.liveplay.myqcloud.com/live/5815_89aad37e06ff11e892905cb9018cf0d4_900.flv';

class LivePullPage extends StatefulWidget {
  const LivePullPage({
    Key key,
  }) : super(key: key);

  @override
  _LivePullPageState createState() => _LivePullPageState();
}

class _LivePullPageState extends State<LivePullPage> {

  TXCloudPullViewController _livePullController;

  bool enableHardwareDecode = false;
  bool isMute = false;

  double volume = 0;

  // 截图数据
  Uint8List snapshotBytes;

  @override
  void dispose() {
    super.dispose();
    if(Platform.isIOS){
      _livePullController.stopPlay();
    }
  }

  printPlaying() async{
      print("isPlaying: ${await _livePullController.isPlaying()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live pull'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (String text) async{
              switch(text){
                case "暂停":
                  _livePullController.pause();
                  printPlaying();
                  break;
                case "继续":
                  _livePullController.resume();
                  printPlaying();
                  break;
                case "横屏":
                  _livePullController.setRenderRotation(TXLiveConstants.RENDER_ROTATION_270);
                  break;
                case "竖屏":
                  _livePullController.setRenderRotation(TXLiveConstants.RENDER_ROTATION_0);
                  break;
                case "图像铺满":
                  _livePullController.setRenderMode(TXLiveConstants.RENDER_MODE_FULL_FILL_SCREEN);
                  break;
                case "图像适应":
                  _livePullController.setRenderMode(TXLiveConstants.RENDER_MODE_ADJUST_RESOLUTION);
                  break;
                case "硬件加速":
                  await _livePullController.enableHardwareDecode(enableHardwareDecode = !enableHardwareDecode);
                  await _livePullController.stopPlay();
                  await _livePullController.startPlay(_testPullUrl);
                  break;
                case "静音":
                  _livePullController.setMute(isMute = !isMute);
                  break;
                case "扬声器":
                  _livePullController.setAudioRoute(TXLiveConstants.AUDIO_ROUTE_SPEAKER);
                  break;
                case "截图":
                  _livePullController.snapshot();
                  break;
                case "听筒":
                  await _livePullController.setAudioRoute(TXLiveConstants.AUDIO_ROUTE_RECEIVER);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                child: Text("暂停"),
                value: "暂停",
              ),
              PopupMenuItem(
                child: Text("继续"),
                value: "继续",
              ),
              PopupMenuItem(
                child: Text("横屏"),
                value: "横屏",
              ),
              PopupMenuItem(
                child: Text("竖屏"),
                value: "竖屏",
              ),
              PopupMenuItem(
                child: Text("图像铺满"),
                value: "图像铺满",
              ),
              PopupMenuItem(
                child: Text("图像适应"),
                value: "图像适应",
              ),
              PopupMenuItem(
                child: Text("硬件加速"),
                value: "硬件加速",
              ),
              PopupMenuItem(
                child: Text("静音"),
                value: "静音",
              ),
              PopupMenuItem(
                child: Text("扬声器"),
                value: "扬声器",
              ),
              PopupMenuItem(
                child: Text("听筒"),
                value: "听筒",
              ),
              PopupMenuItem(
                child: Text("截图"),
                value: "截图",
              ),
            ]
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: TXCloudPullView(
              onTXCloudPullViewCreated: (controller) async {
                _livePullController = controller;
                await _livePullController.setPlayConfig(TXLivePlayConfig());
                await _livePullController.startPlay(_testPullUrl);
              },
              onPlayEventListener: (args){
//                print("onPlayEventListener args");
//                print(args);
              },
              snapshotResult: (ByteData data){
                // 截图数据
                setState(() {
                  this.snapshotBytes = data.buffer.asUint8List(0, data.lengthInBytes);
                });
              },
            ),
          ),
          /// 右下角显示截图图片
          Positioned(
            right: 0,
            bottom: 0,
            child: (this.snapshotBytes == null)? SizedBox():Image.memory(this.snapshotBytes, width: 100, height: 100,),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 0,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("音量：", style: TextStyle(color: Colors.blue),),
                    Slider(
                      value: this.volume,
                      max: 100.0,
                      min: 0.0,
                      onChanged: (double val){
                        setState(() {
                          this.volume = val;
                        });
                      },
                      onChangeEnd: (double val) {
                        _livePullController.setVolume(val.toInt());
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



