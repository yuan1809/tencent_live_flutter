# tencent_live_flutter

腾讯直播flutter插件  
本插件基于[腾讯直播基础版](https://cloud.tencent.com/document/product/454)  实现，无连麦功能。


## Getting Started
```
dependencies:
  tencent_live_flutter: ^0.0.1
```


## 设置License  
```
Future<void> main() async {
  runApp(MyApp());
  await TencentLive.instance.init(
    licenseUrl: 'licenseUrl',
    licenseKey: 'licenseKey',
  );
}
```  
## 创建拉流视图  
```
TXCloudPullView(
    onTXCloudPullViewCreated: (controller) async {
        _livePullController = controller;
        // 拉流播放配置
        await _livePullController.setPlayConfig(TXLivePlayConfig());
        // 开始播放
        await _livePullController.startPlay(_testPullUrl);
    },
)  
```  
## 创建推流视图  
```
TXCloudPushView(
    onTXCloudPushViewCreated: (controller) async {
        _livePushController = controller;
        // 开始推流
        await _livePushController.startPush(_testPushUrl);
    },
)
```

## iOS
需要在info.plist增加io.flutter.embedded_views_preview=true，至关重要，不然无法显示。

