
import 'package:flutter/services.dart';
import 'package:tencent_live_flutter/src/tx_live_constants.dart';
import 'package:tencent_live_flutter/src/tx_live_play_config.dart';

import 'tx_snapshot_channel.dart';

/// android ITXLivePlayListener 中的 event，iOS TXLivePlayListener 中的 EvtID， 存储在args中 key 为 "event" 的value中
/// TODO event 判断请比对[TXLiveConstants]的定义，这里比对了Android和IOS的几个定义保持了一致，如发现不一致的再处理
typedef void PlayEventListener(Map args);

/// 播放器音量大小回调。音量大小, 取值范围 [0，100]。
//typedef void OnAudioVolumeEvaluationNotify(int volume);

class TXCloudPullViewController{

  final PlayEventListener onPlayEventListener;
//  final OnAudioVolumeEvaluationNotify onAudioVolumeEvaluationNotify;

  final SnapshotResult snapshotResult;

  TXCloudPullViewController(int id, {this.onPlayEventListener, this.snapshotResult}) :
        _channel = MethodChannel('com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView_$id') {
    _channel.setMethodCallHandler(_onMethodCall);

    // 截图处理
    _snapshotChannel = TXSnapShotChannel('com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView_Snapshot_$id', snapshotResult);

  }

  final MethodChannel _channel;
  TXSnapShotChannel _snapshotChannel;

  Future<bool> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onPlayEvent":
        if(onPlayEventListener != null){
          onPlayEventListener(call.arguments as Map);
        }
        break;
//      case "onAudioVolumeEvaluationNotify":
//        if(onAudioVolumeEvaluationNotify != null){
//          onAudioVolumeEvaluationNotify(call.arguments as int);
//        }
        break;
    }
    throw MissingPluginException(
        '${call.method} was invoked but has no handler');
  }

  // 设置配置需要放在开始播放之前，否则有部分配置无法生效
  Future setPlayConfig(TXLivePlayConfig playConfig) async {
    return await _channel.invokeMethod<int>('setPlayConfig', playConfig.toMap());
  }


  Future<int> startPlay(String playUrl)async {
    assert(playUrl != null);

    return await _channel.invokeMethod<int>('startPlay', <String, dynamic>{
      'playUrl': playUrl,
    });
  }

  Future stopPlay() async {
    return await _channel.invokeMethod<int>('stopPlay', {});
  }

  Future pause() async {
    return await _channel.invokeMethod<int>('pause', {});
  }

  Future resume() async {
    return await _channel.invokeMethod<int>('resume', {});
  }

  Future<bool> isPlaying() async {
    return await _channel.invokeMethod<bool>('isPlaying', {});
  }


  /// 设置平铺模式
  /// params renderMode 必须是 [TXLiveConstants.RENDER_MODE_ADJUST_RESOLUTION] 或者 [TXLiveConstants.RENDER_MODE_FULL_FILL_SCREEN]
  Future setRenderMode(int renderMode) async{
    return await _channel.invokeMethod<int>('setRenderMode', {"renderMode":renderMode});
  }

  /// 设置 横屏|竖屏
  /// params renderMode 必须是
  /// [TXLiveConstants.RENDER_ROTATION_0]
  /// [TXLiveConstants.RENDER_ROTATION_90]
  /// [TXLiveConstants.RENDER_ROTATION_180]
  /// [TXLiveConstants.RENDER_ROTATION_270]
  Future setRenderRotation(int renderRotation) async{
    return await _channel.invokeMethod<int>('setRenderRotation', {"renderRotation":renderRotation});
  }

  /// 开启硬件加速。需要重启播放流程.
  /// 返回 true：关闭或开启硬件加速成功；false：关闭或开启硬件加速失败。
  Future<bool> enableHardwareDecode(bool enable) async{
    return await _channel.invokeMethod<bool>('enableHardwareDecode', {"enable":enable});
  }

  /// 设置是否静音播放。true：静音播放；false：不静音播放。
  Future setMute(bool mute) async{
    return await _channel.invokeMethod<int>('setMute', {"mute":mute});
  }

  /// 设置音量。音量大小，取值范围 0 - 100。
  Future setVolume(int volume) async{
    return await _channel.invokeMethod<int>('setVolume', {"volume":volume});
  }

  /// 设置声音播放模式。切换扬声器，听筒，可设置值：[TXLiveConstants.AUDIO_ROUTE_SPEAKER]、[TXLiveConstants.AUDIO_ROUTE_RECEIVER]。
  Future setAudioRoute(int audioRoute) async{
    return await _channel.invokeMethod<int>('setAudioRoute', {"audioRoute":audioRoute});
  }

  /// FLV 多清晰度切换。
  /// 使用说明：
  /// 必须是腾讯云的直播地址。
  ///必须是当前播放直播流的不同清晰度，切换到无关流地址可能会失败。
  Future<int> switchStream(String playUrl) async{
    return await _channel.invokeMethod<int>('switchStream', {"playUrl":playUrl});
  }

  /// 本地截图
  Future snapshot() async {
    await _snapshotChannel.snapshot();
  }

}