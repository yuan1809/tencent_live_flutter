
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'tx_live_constants.dart';

class TXLivePushConfig{
  /////////////////////////////////////////////////////////////////////////////////
//
//                      常用设置项
//
/////////////////////////////////////////////////////////////////////////////////

  ///【字段含义】HOME 键所在方向，用来切换横竖屏推流，默认值：[TXLiveConstants.VIDEO_ANGLE_HOME_DOWN]
  /// 改变该字段的设置以后，本地摄像头的预览画面方向也会发生改变，请调用 TXLivePush 的 setRenderRotation 进行矫正。
  /// 必须用一下几个值设置
  /// [TXLiveConstants.VIDEO_ANGLE_HOME_RIGHT]
  /// [TXLiveConstants.VIDEO_ANGLE_HOME_DOWN]
  /// [TXLiveConstants.VIDEO_ANGLE_HOME_LEFT]
  /// [TXLiveConstants.VIDEO_ANGLE_HOME_UP]
   int homeOrientation;

  ///【字段含义】是否允许点击曝光聚焦，默认值：false。
   bool touchFocus;

  ///【字段含义】是否允许双指手势放大预览画面，默认值：false。
   bool enableZoom;

  ///【字段含义】水印图片，设为 null 等同于关闭水印。
   ByteData watermark;

  ///【字段含义】水印图片相对于推流分辨率的归一化坐标
  ///【推荐取值】假设推流分辨率为：540x960，该字段设置为：(0.1，0.1，0.1，0.0)，那么水印的实际像素坐标为：
  ///           (540 × 0.1, 960 × 0.1, 水印宽度 × 0.1，水印高度会被自动计算）
  ///【特别说明】watermarkNormalization 的优先级高于 watermarkPos。
   Rect watermarkNormalization;

  ///【字段含义】本地预览画面的镜像类型，默认值：[TXLiveConstants.LOCAL_VIDEO_MIRROR_TYPE_AUTO] 即前置摄像头镜像，后置摄像头不镜像
   int localVideoMirrorType;

/////////////////////////////////////////////////////////////////////////////////
//
//                      垫片推流（App 切后台）
//
/////////////////////////////////////////////////////////////////////////////////

  /// [pauseTime] 和 [pauseFps] 必须同时设置才有效，TXLive Android SDK是一个方法设置的
  ///【字段含义】垫片推流的最大持续时间，单位秒，默认值：300s。
  ///【特别说明】调用 TXLivePusher 的 pausePush() 接口，会暂停摄像头采集并进入垫片推流状态，如果该状态一直保持，
  ///          可能会消耗主播过多的手机流量，本字段用于指定垫片推流的最大持续时间，超过后即断开与云服务器的连接。
  int pauseTime;

  ///【字段含义】垫片推流时的视频帧率，取值范围3 - 8，默认值：5 FPS。
  int pauseFps;

  ///【字段含义】垫片推流时使用的图片素材，最大尺寸不能超过1920 x 1920。
  ByteData pauseImg;


/////////////////////////////////////////////////////////////////////////////////
//
//                      音视频编码参数
//
/////////////////////////////////////////////////////////////////////////////////

  ///【字段含义】视频分辨率，默认值：[TXLiveConstants.VIDEO_RESOLUTION_TYPE_360_640]。
  ///【特别说明】推荐直接使用 TXLivePusher 的 setVideoQuality 接口调整画面质量。
   int videoResolution;

  ///【字段含义】视频帧率，默认值：15FPS。
  ///【特别说明】推荐直接使用 TXLivePusher 的 setVideoQuality 接口调整画面质量。
   int videoFPS;

  ///【字段含义】视频编码 GOP，也就是常说的关键帧间隔，单位：秒；默认值：3s。
  ///【特别说明】推荐直接使用 TXLivePusher 的 setVideoQuality 接口调整画面质量。
   int videoEncodeGop;

  ///【字段含义】码率自适应开关，开启后，SDK 会根据网络情况自动调节视频码率，调节范围在 (videoBitrateMin - videoBitrateMax)。
  ///【推荐取值】false
   bool enableAutoBitrate;

  ///【字段含义】码率自适应算法
  ///【推荐取值】[TXLiveConstants.AUTO_ADJUST_BITRATE_STRATEGY_1]
   int autoAdjustStrategy;

  ///【字段含义】码率自适应 - 最高码率，默认值：1000kpbs
   int videoBitrateMax;

  ///【字段含义】码率自适应 - 最低码率，默认值：500kpbs
  ///【推荐取值】不要设置太低的数值，过低的码率会导致运动画面出现大面积马赛克。
   int videoBitrateMin;

  ///【字段含义】音频采样率，采样率越高音质越好，对于有音乐的场景请使用48000的采样率。
  ///【推荐取值】默认值：48000。 - 其他值：8000、16000、32000、44100、48000
   int audioSampleRate;

  ///【字段含义】音频声道数，默认值：1（单声道）。- 其他值：1、2、4。
   int audioChannels;

  ///【字段含义】是否开启耳返特效
  ///【推荐取值】false
  ///【特别说明】开启耳返会消耗更多的 CPU，只有在主播带耳机唱歌的时候才有必要开启此功能。
   bool enableAudioPreview;

  ///【字段含义】是否为纯音频推流
  ///【推荐取值】false
  ///【特别说明】如果希望实现纯音频推流的功能，需要在推流前就设置该参数，否则播放端会有兼容性问题。
   bool enablePureAudioPush;

/////////////////////////////////////////////////////////////////////////////////
//
//                      网络相关参数
//
/////////////////////////////////////////////////////////////////////////////////

  ///【字段含义】推流遭遇网络连接断开时 SDK 默认重试的次数，取值范围1 - 10，默认值：3。
   int connectRetryCount;

  ///【字段含义】网络重连的时间间隔，单位秒，取值范围3 - 30，默认值：3。
   int connectRetryInterval;

/////////////////////////////////////////////////////////////////////////////////
//
//                      自定义采集和处理
//
/////////////////////////////////////////////////////////////////////////////////

  ///【字段含义】自定义采集和自定义处理开关
  ///【特别说明】该字段需要使用与运算符进行级联操作（自定义采集和自定义处理不能同时开启）:
  ///            开启自定义视频采集：_config.customModeType |= CUSTOM_MODE_VIDEO_CAPTURE；
  ///            开启自定义音频采集：_config.customModeType |= CUSTOM_MODE_AUDIO_CAPTURE；
   int customModeType;

  ///【字段含义】仅开启自定义采集时有效，用于设置编码分辨率。
  ///【特别说明】此值设置需与调用 sendVideoSampleBuffer 时传入的 SampleBuffer 的宽高比一致，否则会引起画面变形。
  ///            如果指定 autoSampleBufferSize 为 true，则不需要设置该字段。
//   Size sampleBufferSize;  Android SDK未找到相关设置项

  ///【字段含义】仅开启自定义采集时有效，true 代表编码分辨率等于输入的 SampleBuffer 的分辨率，默认值：false。
//   bool autoSampleBufferSize; Android SDK未找到相关设置项


/////////////////////////////////////////////////////////////////////////////////
//
//                      专业设置项（慎用）
//
/////////////////////////////////////////////////////////////////////////////////

  ///【字段含义】是否开启噪声抑制（注意：早期版本引入了拼写错误，考虑到接口兼容一直没有修正，正确拼写应该是 ANS）
  ///【推荐取值】NO：ANS 对于直播环境中由其它设备外放的音乐是不友好的，通过 playBGM 设置的背景音不受影响。
  ///【特别说明】如果直播场景只有主播在说话，ANS 有助于让主播的声音更清楚，但如果主播在吹拉弹唱，ANS 会损伤乐器的声音。
   bool enableANS;

  ///【字段含义】是否开启回声抑制
  ///【推荐取值】NO：回声抑制会启用通话模式音量，导致音质变差，非连麦场景下请不要开启。
  ///【特别说明】只有在连麦模式下才需要开启 AEC，如果是普通的直播，将主播的手机和观众的手机放在一起所产生的啸叫是正常现象。
   bool enableAEC;

  ///【字段含义】开启视频硬件加速
   bool enableHWAcceleration;

  ///【字段含义】开启音频硬件加速， 默认值：YES。
//   bool enableAudioAcceleration;  Android SDK未找到相关设置项

  ///【字段含义】是否开启音频自动增益，默认值：NO。
   bool enableAGC;

  ///【字段含义】系统音量类型，默认值：AUDIO_VOLUME_TYPE_AUTO。
  /// 自动音量取值为：[TXLiveConstants.AUDIO_VOLUME_TYPE_AUTO]，
  /// 媒体音量取值为：[TXLiveConstants.AUDIO_VOLUME_TYPE_MEDIA]
  /// 通话音量取值为：[TXLiveConstants.AUDIO_VOLUME_TYPE_VOIP]
   int volumeType;

   Map<String, dynamic> toMap(){
     Map<String, dynamic> data = {};
////////////////  常用设置项
     if(this.homeOrientation != null){
       data["homeOrientation"] = this.homeOrientation;
     }
     if(this.touchFocus != null){
       data["touchFocus"] = this.touchFocus;
     }
     if(this.enableZoom != null){
       data["enableZoom"] = this.enableZoom;
     }
     if(this.watermark != null){
       data["watermark"] = this.watermark.buffer.asUint8List();
     }
     if(this.watermarkNormalization != null){
       data["watermarkNormalization"] = [
         this.watermarkNormalization.left,
         this.watermarkNormalization.top,
         this.watermarkNormalization.right,
         this.watermarkNormalization.bottom
       ];
     }
     if(this.localVideoMirrorType != null){
       data["localVideoMirrorType"] = this.localVideoMirrorType;
     }
////////////////   垫片推流（App 切后台）
     if(this.pauseTime != null){
       data["pauseTime"] = this.pauseTime;
     }
     if(this.pauseFps != null){
       data["pauseFps"] = this.pauseFps;
     }
     if(this.pauseImg != null){
       data["pauseImg"] = this.pauseImg.buffer.asUint8List();
     }
////////////////    音视频编码参数
     if(this.videoResolution != null){
       data["videoResolution"] = this.videoResolution;
     }
     if(this.videoFPS != null){
       data["videoFPS"] = this.videoFPS;
     }
     if(this.videoEncodeGop != null){
       data["videoEncodeGop"] = this.videoEncodeGop;
     }
     if(this.enableAutoBitrate != null){
       data["enableAutoBitrate"] = this.enableAutoBitrate;
     }
     if(this.autoAdjustStrategy != null){
       data["autoAdjustStrategy"] = this.autoAdjustStrategy;
     }
     if(this.videoBitrateMax != null){
       data["videoBitrateMax"] = this.videoBitrateMax;
     }
     if(this.videoBitrateMin != null){
       data["videoBitrateMin"] = this.videoBitrateMin;
     }
     if(this.audioSampleRate != null){
       data["audioSampleRate"] = this.audioSampleRate;
     }
     if(this.audioChannels != null){
       data["audioChannels"] = this.audioChannels;
     }
     if(this.enableAudioPreview != null){
       data["enableAudioPreview"] = this.enableAudioPreview;
     }
     if(this.enablePureAudioPush != null){
       data["enablePureAudioPush"] = this.enablePureAudioPush;
     }
////////////////    网络相关参数
     if(this.connectRetryCount != null){
       data["connectRetryCount"] = this.connectRetryCount;
     }
     if(this.connectRetryInterval != null){
       data["connectRetryInterval"] = this.connectRetryInterval;
     }
////////////////    自定义采集和处理
     if(this.customModeType != null){
       data["customModeType"] = this.customModeType;
     }
//     if(this.sampleBufferSize != null){
//       data["sampleBufferSize"] = [this.sampleBufferSize.width, this.sampleBufferSize.height];
//     }
//     if(this.autoSampleBufferSize != null){
//       data["autoSampleBufferSize"] = this.autoSampleBufferSize;
//     }
///////////////    专业设置项（慎用）
     if(this.enableANS != null){
       data["enableANS"] = this.enableANS;
     }
     if(this.enableAEC != null){
       data["enableAEC"] = this.enableAEC;
     }
     if(this.enableHWAcceleration != null){
       data["enableHWAcceleration"] = this.enableHWAcceleration;
     }
//     if(this.enableAudioAcceleration != null){
//       data["enableAudioAcceleration"] = this.enableAudioAcceleration;
//     }
     if(this.enableAGC != null){
       data["enableAGC"] = this.enableAGC;
     }
     if(this.volumeType != null){
       data["volumeType"] = this.volumeType;
     }
     print("Flutter Push Config: $data");
     return data;
   }

}