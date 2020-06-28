import 'package:flutter/services.dart';
import 'package:tencent_live_flutter/src/tx_beauty_manager.dart';

import 'tx_live_constants.dart';
import 'tx_live_push_config.dart';
import 'tx_snapshot_channel.dart';

/// android ITXLivePushListener 中的 event，iOS TXLivePushListener 中的 EvtID， 存储在args中 key 为 "event" 的value中
/// TODO event 判断请比对[TXLiveConstants]的定义，这里比对了Android和IOS的几个定义保持了一致，如发现不一致的再处理
typedef void PushEventListener(Map args);


class TXCloudPushViewController{

  final PushEventListener onPushEventListener;

  final OnBGMNotify onBGMNotify;

  final SnapshotResult snapshotResult;


  TXCloudPushViewController(int id, {this.onPushEventListener, this.onBGMNotify, this.snapshotResult}) :
        _channel = MethodChannel('com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView_$id') {
    _channel.setMethodCallHandler(_onMethodCall);

    // 截图处理
    _snapshotChannel = TXSnapShotChannel('com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView_Snapshot_$id', snapshotResult);

    txBeautyManager = TXBeautyManager(_channel);

  }

  final MethodChannel _channel;
  TXSnapShotChannel _snapshotChannel;
  TXBeautyManager txBeautyManager;

  Future<bool> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onPushEvent":
        if(onPushEventListener != null){
          onPushEventListener(call.arguments as Map);
        }
        break;
      case "onBGMStart":
        onBGMNotify?.onBGMStart();
        break;
      case "onBGMProgress":
        Map params = call.arguments as Map;
        onBGMNotify?.onBGMProgress(params["progress"] as int, params["duration"] as int);
        break;
      case "onBGMComplete":
        Map params = call.arguments as Map;
        onBGMNotify?.onBGMComplete(params["err"] as int);
        break;
    }
    throw MissingPluginException(
        '${call.method} was invoked but has no handler');
  }

  // 设置配置需要放在开始推流之前，否则有部分配置无法生效
  Future setPushConfig(TXLivePushConfig pushConfig) async {
    return await _channel.invokeMethod<int>('setPushConfig', pushConfig.toMap());
  }

  /// 开始推流
  Future<int> startPush(String playUrl)async {
    assert(playUrl != null);

    return await _channel.invokeMethod<int>('startPush', <String, dynamic>{
      'pushUrl': playUrl,
    });
  }

  /// 结束推流
  Future stopPush()async {
    return await _channel.invokeMethod<int>('stopPush', {});
  }

  /// 开启摄像头预览
  Future startCameraPreview()async {
    return await _channel.invokeMethod<int>('startCameraPreview', {});
  }

  /// 停止摄像头预览。
  Future stopCameraPreview()async {
    return await _channel.invokeMethod<int>('stopCameraPreview', {});
  }

  /// 暂停摄像头采集并进入垫片推流状态。
  Future pausePusher()async {
    return await _channel.invokeMethod<int>('pausePusher', {});
  }

  /// 恢复摄像头采集并结束垫片推流状态。
  Future resumePusher()async {
    return await _channel.invokeMethod<int>('resumePusher', {});
  }

  /// 查询是否正在推流。 pausePusher 后仍然返回的是true, stopPusher 后才会返回false
  Future<bool> isPushing()async {
    return await _channel.invokeMethod<bool>('isPushing', {});
  }

  /// 设置视频编码质量
  /// 推荐设置：秀场直播 quality：[TXLiveConstants.VIDEO_QUALITY_HIGH_DEFINITION]；adjustBitrate：false；adjustResolution：false
  Future setVideoQuality(int quality, bool adjustBitrate, bool adjustResolution)async {
    return await _channel.invokeMethod<int>('setVideoQuality', {
      "quality": quality,
      "adjustBitrate": adjustBitrate,
      "adjustResolution": adjustResolution
    });
  }

  /// 切换前后摄像头
  Future switchCamera()async {
    return await _channel.invokeMethod<int>('switchCamera', {});
  }

  /// 设置视频镜像效果
  /// true：播放端看到的是镜像画面；false：播放端看到的是非镜像画面。
  Future setMirror(bool isMirror) async{
    return await _channel.invokeMethod<bool>('setMirror', {"isMirror":isMirror});
  }

  /// 设置本地摄像头预览画面的旋转方向。
  /// 该接口仅能够改变主播本地预览画面的方向，而不会改变观众端的画面效果。
  /// 如果希望改变观众端看到的视频画面的方向，例如原来是540x960，希望变成960x540，则可以通过设置 TXLivePushConfig 中的 homeOrientation 来实现。
  /// params renderMode 必须是
  /// [TXLiveConstants.RENDER_ROTATION_0]
  /// [TXLiveConstants.RENDER_ROTATION_90]
  /// [TXLiveConstants.RENDER_ROTATION_180]
  /// [TXLiveConstants.RENDER_ROTATION_270]
  Future setRenderRotation(int renderRotation) async{
    return await _channel.invokeMethod<int>('setRenderRotation', {"renderRotation":renderRotation});
  }

  /// 打开后置摄像头旁边的闪光灯
  /// true：打开闪光灯； false：关闭闪光灯
  /// 返回 true：打开成功；false：打开失败。
  Future<bool> turnOnFlashLight(bool enable) async{
    return await _channel.invokeMethod<bool>('turnOnFlashLight', {"enable":enable});
  }

  /// 调整摄像头的焦距
  /// 返回 true：成功； false：失败。
  Future setZoom(int value) async{
    return await _channel.invokeMethod<int>('setZoom', {"value":value});
  }

  ///////////////////////////音频相关接口 /////////////////////////////////
  /// 开启静音。true：静音；false：不静音。
  Future setMute(bool mute) async{
    return await _channel.invokeMethod<int>('setMute', {"mute":mute});
  }

  /// 播放背景音乐
  /// [path] 本地音乐文件路径
  /// 返回 true：播放成功；false：播放失败
  Future<bool> playBGM(String path) async{
    return await _channel.invokeMethod<bool>('playBGM', {"path":path});
  }

  /// 停止播放背景音乐
  Future<bool> stopBGM() async{
    return await _channel.invokeMethod<bool>('stopBGM', {});
  }

  /// 暂停播放背景音乐
  Future<bool> pauseBGM() async{
    return await _channel.invokeMethod<bool>('pauseBGM', {});
  }

  /// 继续播放背音乐
  Future<bool> resumeBGM() async{
    return await _channel.invokeMethod<bool>('resumeBGM', {});
  }

  /// 获取背景音乐文件的总时长，单位是毫秒
  /// [path] 音乐文件路径，如果 path 为空，那么返回当前正在播放的背景音乐的时长。
  Future<int> getMusicDuration(String path) async{
    return await _channel.invokeMethod<int>('getMusicDuration', {"path":path});
  }

  /// 设置混音时背景音乐的音量大小，仅在播放背景音乐混音时使用
  /// [volume] 音量大小，1为正常音量，范围是：[0 ~ 1] 之间的浮点数。
  Future<bool> setBGMVolume(double volume) async{
    return await _channel.invokeMethod<bool>('setBGMVolume', {"volume":volume});
  }

  /// 设置混音时麦克风音量大小，仅在播放背景音乐混音时使用
  /// [volume] 音量大小，1为正常音量，范围是：[0 ~ 1] 之间的浮点数。
  Future<bool> setMicVolume(double volume) async{
    return await _channel.invokeMethod<bool>('setMicVolume', {"volume":volume});
  }

  /// 调整背景音乐的音调高低
  /// [pitch] 	音调，默认值是0.0f，范围是：-1 - 1之间的浮点数
  Future setBGMPitch(double pitch) async{
    return await _channel.invokeMethod<int>('setBGMPitch', {"pitch":pitch});
  }

  /// 设置混响效果
  /// [pitch] 	混响类型，具体值请参见 TXLiveConstants 中的 REVERB_TYPE_X 定义
  Future setReverb(int reverbType) async{
    return await _channel.invokeMethod<int>('setReverb', {"reverbType":reverbType});
  }

  /// 设置变声类型
  /// [voiceChangerType] 	具体值请参见 TXLiveConstants 中的 VOICECHANGER_TYPE_X 定义
  Future setVoiceChangerType(int voiceChangerType) async{
    return await _channel.invokeMethod<int>('setVoiceChangerType', {"voiceChangerType":voiceChangerType});
  }

  /// 推流过程中本地截图
  Future snapshot() async {
    await _snapshotChannel.snapshot();
  }

}

/// 背景音乐回调类
abstract class OnBGMNotify{

  /// 音乐播放开始的回调通知
  void onBGMStart();

  /// 音乐播放进度的回调通知
  /// [progress] 当前 BGM 已播放时间（ms）
  /// [duration] 当前 BGM 总时间（ms）
  void onBGMProgress(int progress, int duration);

  /// 音乐播放结束的回调通知
  /// [err] 0：正常结束；-1：出错结束
  void onBGMComplete(int err);

}