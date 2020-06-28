import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_live_flutter/tencent_live_flutter.dart';

const _testPushUrl = '';

class LivePushPage extends StatefulWidget {
  const LivePushPage({
    Key key,
  }) : super(key: key);

  @override
  _LivePushPageState createState() => _LivePushPageState();
}

class _LivePushPageState extends State<LivePushPage> implements OnBGMNotify{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TXCloudPushViewController _livePushController;

  double videoQuality = 1;
  double zoom = 1;

  bool isFrontCamera = true;
  bool flashLightOn = false;
  bool isMirror = false;

  // 截图数据
  Uint8List snapshotBytes;


  @override
  void dispose() {
    if(Platform.isIOS){
      _livePushController.stopPush();
    }
    super.dispose();
  }

  printPushing() async{
    print("isPushing: ${await _livePushController.isPushing()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Live push'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (String text) async{
                switch(text){
                  case "开启摄像头预览":
                    await _livePushController.startCameraPreview();
                    printPushing();
                    break;
                  case "停止摄像头预览":
                    await _livePushController.stopCameraPreview();
                    printPushing();
                    break;
                  case "暂停":
                    await _livePushController.pausePusher();
                    printPushing();
                    break;
                  case "继续":
                    await _livePushController.resumePusher();
                    printPushing();
                    break;
                  case "横屏":
                    _livePushController.setRenderRotation(TXLiveConstants.RENDER_ROTATION_270);
                    break;
                  case "竖屏":
                    _livePushController.setRenderRotation(TXLiveConstants.RENDER_ROTATION_0);
                    break;
                  case "切换摄像头":
                    this.isFrontCamera = !this.isFrontCamera;
                    _livePushController.switchCamera();
                    break;
                  case "设置镜像":
                    _livePushController.setMirror(this.isMirror = !this.isMirror);
                    break;
                  case "闪光灯":
                    _livePushController.turnOnFlashLight(this.flashLightOn = !this.flashLightOn);
                    break;
                  case "截图":
                    _livePushController.snapshot();
                    break;
                  case "音频设置":
                    showAudioConfigPopup(context);
                    break;
                  case "美颜设置":
                    showBeautyManagerPopup(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem(
                  child: Text("开启摄像头预览"),
                  value: "开启摄像头预览",
                ),
                PopupMenuItem(
                  child: Text("停止摄像头预览"),
                  value: "停止摄像头预览",
                ),
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
                  child: Text("切换摄像头"),
                  value: "切换摄像头",
                ),
                PopupMenuItem(
                  child: Text("设置镜像"),
                  value: "设置镜像",
                ),
                PopupMenuItem(
                  child: Text("闪光灯"),
                  value: "闪光灯",
                ),
                PopupMenuItem(
                  child: Text("截图"),
                  value: "截图",
                ),
                PopupMenuItem(
                  child: Text("音频设置"),
                  value: "音频设置",
                ),
                PopupMenuItem(
                  child: Text("美颜设置"),
                  value: "美颜设置",
                ),
              ]
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: TXCloudPushView(
              onTXCloudPushViewCreated: (controller) async {
                _livePushController = controller;
                await setConfig();
                await _livePushController.startPush(_testPushUrl);
              },
              onPushEventListener: (args){
                print("onPushEventListener args");
                print(args);
              },
              onBGMNotify: this,
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
                    Text("视频编码质量：", style: TextStyle(color: Colors.blue),),
                    Slider(
                      value: this.videoQuality,
                      max: 7.0,
                      min: 1.0,
                      onChanged: (double val){
                        setState(() {
                          this.videoQuality = val;
                        });
                      },
                      onChangeEnd: (double val) {
                        _livePushController.setVideoQuality(val.toInt(), true, true);
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("焦距：", style: TextStyle(color: Colors.blue),),
                    Slider(
                      value: this.zoom,
                      max: 20.0,
                      min: 1.0,
                      onChanged: (double val){
                        setState(() {
                          this.zoom = val;
                        });
                      },
                      onChangeEnd: (double val) {
                        _livePushController.setZoom(val.toInt());
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

  Future setConfig() async{
    TXLivePushConfig config = TXLivePushConfig();
    PlatformAssetBundle bundle = PlatformAssetBundle();
    config.homeOrientation = TXLiveConstants.VIDEO_ANGLE_HOME_DOWN;
    config.touchFocus = true;
    config.enableZoom = true;
    config.watermark = await bundle.load("assets/images/watermark.png");
    config.watermarkNormalization = Rect.fromLTRB(0.1, 0.1, 0.1, 0);
    config.pauseImg = await bundle.load("assets/images/pause_img.png");
    await _livePushController.setPushConfig(config);
  }

  void showAudioConfigPopup(BuildContext buildContext) {
    _scaffoldKey.currentState.showBottomSheet((context){
      return AudioConfigPopup(livePushController:_livePushController);
    });
  }

  void showBeautyManagerPopup(BuildContext buildContext) {
    _scaffoldKey.currentState.showBottomSheet((context){
      return BeautyManagerPopup(txBeautyManager:_livePushController.txBeautyManager);
    });
  }

  ///////////////// OnBGMNotify //////////////
  @override
  void onBGMComplete(int err) {
    print("onBGMComplete: $err");
  }

  @override
  void onBGMProgress(int progress, int duration) {
//    print("onBGMProgress: $progress  duration: $duration");
  }

  @override
  void onBGMStart() {
    print("onBGMStart");
  }

}

/// //////////////////////////////////////////
/// 音频设置
class AudioConfigPopup extends StatefulWidget{

  final TXCloudPushViewController livePushController;

  const AudioConfigPopup({Key key, this.livePushController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AudioConfigPopupState();
  }


}

/// 音频设置
class AudioConfigPopupState extends State<AudioConfigPopup>{

  TXCloudPushViewController _livePushController;

  String bgmFilePath;
  bool isMute = false;
  double reverbType = 0;
  double voiceChangerType = 0;
  double BGMVolume = 0.5;
  double MicVolume = 0.5;
  double BGMPitch = 0;

  @override
  void initState() {
    _livePushController = widget.livePushController;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("选择背景音乐"),
                onPressed: (){
                  FilePicker.getFilePath(
                    type: FileType.any,
                  ).then((value){
                    setState(() {
                      this.bgmFilePath = value;
                    });
                  });
                },
              ),
              Expanded(
                child: Text(bgmFilePath??""),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text("播放"),
                onPressed: () async{
                  _livePushController.playBGM(this.bgmFilePath);
                  int duration = await _livePushController.getMusicDuration(this.bgmFilePath);
                  print("BGM duration: $duration");
                },
              ),
              RaisedButton(
                child: Text("停止"),
                onPressed: (){
                  _livePushController.stopBGM();
                },
              ),
              RaisedButton(
                child: Text("静音"),
                onPressed: (){
                  _livePushController.setMute(this.isMute = !this.isMute);
                },
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text("暂停"),
                onPressed: (){
                  _livePushController.pauseBGM();
                },
              ),
              RaisedButton(
                child: Text("继续"),
                onPressed: (){
                  _livePushController.resumeBGM();
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("背景音量大小："),
              Slider(
                value: this.BGMVolume,
                max: 1.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.BGMVolume = val;
                  });
                },
                onChangeEnd: (double val) {
                  _livePushController.setBGMVolume(val);
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("麦克音量大小："),
              Slider(
                value: this.MicVolume,
                max: 1.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.MicVolume = val;
                  });
                },
                onChangeEnd: (double val) {
                  _livePushController.setMicVolume(val);
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("背景音调高低："),
              Slider(
                value: this.BGMPitch,
                max: 1.0,
                min: -1.0,
                onChanged: (double val){
                  setState(() {
                    this.BGMPitch = val;
                  });
                },
                onChangeEnd: (double val) {
                  _livePushController.setBGMPitch(val);
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("混响："),
              Slider(
                value: this.reverbType,
                max: 7.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.reverbType = val;
                  });
                },
                onChangeEnd: (double val) {
                  _livePushController.setReverb(val.toInt());
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("变声："),
              Slider(
                value: this.voiceChangerType,
                max: 11.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.voiceChangerType = val;
                  });
                },
                onChangeEnd: (double val) {
                  _livePushController.setVoiceChangerType(val.toInt());
                },
              ),
            ],
          )
        ],
      ),
    );
  }

}


/// //////////////////////////////////////////
/// 美颜设置
class BeautyManagerPopup extends StatefulWidget{

  final TXBeautyManager txBeautyManager;

  const BeautyManagerPopup({Key key, this.txBeautyManager}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BeautyManagerPopupState();
  }


}

/// 音频设置
class BeautyManagerPopupState extends State<BeautyManagerPopup>{

  TXBeautyManager txBeautyManager;

  PlatformAssetBundle bundle = PlatformAssetBundle();

  // 美颜类型
  double beautyStyle = 0;
  // 滤镜浓度
  double strength = 0;
  // 美颜级别
  double beautyLevel = 0;
  // 美白级别
  double whitenessLevel = 0;
  // 红润级别
  double ruddyLevel = 0;

  @override
  void initState() {
    txBeautyManager = widget.txBeautyManager;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("设置指定素材滤镜特效"),
                onPressed: () async{
                  ByteData imageData = await bundle.load("assets/images/pause_img.png");
                  await txBeautyManager.setFilter(imageData);
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("美颜类型："),
              Slider(
                value: this.beautyStyle,
                max: 2.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.beautyStyle = val;
                  });
                },
                onChangeEnd: (double val) {
                  txBeautyManager.setBeautyStyle(val.toInt());
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("滤镜浓度："),
              Slider(
                value: this.strength,
                max: 1.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.strength = val;
                  });
                },
                onChangeEnd: (double val) {
                  txBeautyManager.setFilterStrength(val);
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("美颜级别："),
              Slider(
                value: this.beautyLevel,
                max: 9.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.beautyLevel = val;
                  });
                },
                onChangeEnd: (double val) {
                  txBeautyManager.setBeautyLevel(val.toInt());
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("美白级别："),
              Slider(
                value: this.whitenessLevel,
                max: 9.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.whitenessLevel = val;
                  });
                },
                onChangeEnd: (double val) {
                  txBeautyManager.setWhitenessLevel(val.toInt());
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("红润级别："),
              Slider(
                value: this.ruddyLevel,
                max: 9.0,
                min: 0.0,
                onChanged: (double val){
                  setState(() {
                    this.ruddyLevel = val;
                  });
                },
                onChangeEnd: (double val) {
                  txBeautyManager.setRuddyLevel(val.toInt());
                },
              ),
            ],
          )
        ],
      ),
    );
  }

}
