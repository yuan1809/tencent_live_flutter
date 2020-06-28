#import "FlutterTXCloudPushView.h"
#import "TXBeautyManagerChannel.h"

@implementation FlutterTXCloudPushViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  FlutterTXCloudPushView* pushView = [[FlutterTXCloudPushView alloc] initWithFrame:frame
                                                                         viewIdentifier:viewId
                                                                              arguments:args
                                                                        binaryMessenger:_messenger];
  return pushView;
}

@end

@implementation FlutterTXCloudPushView {
  UIView *_localView;    // 本地预览
  TXLivePush *_pusher;
  TXLivePushConfig *_config;

  int64_t _viewId;
  FlutterMethodChannel* _channel;
  FlutterBasicMessageChannel* _snapshotChannel;
  TXBeautyManagerChannel* _txBeautyManagerChannel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
    _viewId = viewId;

    NSString* channelName = [NSString stringWithFormat:@"com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    __weak __typeof__(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      [weakSelf onMethodCall:call result:result];
    }];

    [self initSnapshotChannel:messenger widthId:viewId];

    // config初始化
    _config = [[TXLivePushConfig alloc] init];
    // 创建播放器
    _pusher = [[TXLivePush alloc] initWithConfig:_config];

    _txBeautyManagerChannel = [[TXBeautyManagerChannel alloc] initWithMethodChannel:_channel withBeautyManager:[_pusher getBeautyManager]];
    // 本地视频预览view
    _localView = [[UIView alloc] initWithFrame:frame];
  }
  return self;
}

- (void)initSnapshotChannel: (NSObject<FlutterBinaryMessenger>*)messenger widthId: (int64_t)viewId{
    NSString* channelName = [NSString stringWithFormat:@"com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView_Snapshot_%lld", viewId];
    _snapshotChannel = [FlutterBasicMessageChannel messageChannelWithName:channelName binaryMessenger:messenger codec:[FlutterBinaryCodec sharedInstance]];
  // 接收到flutter端snapshot调用后，将截图数据传回调给flutter层
    [_snapshotChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        callback(nil);
        [_pusher snapshot:^(TXImage *image){
            [_snapshotChannel sendMessage:UIImagePNGRepresentation(image)];
        }];
    }];
}

- (UIView*)view {
  return _localView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([[call method] isEqualToString:@"setPushConfig"]){
        [self setPushConfig:[call arguments] result:result];
    }else if ([[call method] isEqualToString:@"startPush"]) {
        [self startPush:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"stopPush"]){
        [self stopPush:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"startCameraPreview"]){
        [self startPreview:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"stopCameraPreview"]){
        [self stopPreview:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"pausePusher"]){
        [self pausePush:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"resumePusher"]){
        [self resumePush:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"isPushing"]){
        [self isPublishing:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setVideoQuality"]){
        [self setVideoQuality:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"switchCamera"]){
        [self switchCamera:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setMirror"]){
        [self setMirror:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setRenderRotation"]){
        [self setRenderRotation:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"turnOnFlashLight"]){
        [self turnOnFlashLight:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setZoom"]){
        [self setZoom:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setMute"]){
        [self setMute:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"playBGM"]){
        [self playBGM:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"stopBGM"]){
        [self stopBGM:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"pauseBGM"]){
        [self pauseBGM:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"resumeBGM"]){
        [self resumeBGM:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"getMusicDuration"]){
        [self getMusicDuration:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setBGMVolume"]){
        [self setBGMVolume:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setMicVolume"]){
        [self setMicVolume:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setBGMPitch"]){
        [self setBGMPitch:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setReverb"]){
        [self setReverb:[call arguments] result:result];
    }else if([[call method] isEqualToString:@"setVoiceChangerType"]){
        [self setVoiceChangerType:[call arguments] result:result];
    }else if([[call method] hasPrefix:TX_BEAUTY_METHOD_PRE]){
        [_txBeautyManagerChannel onMethodCall:call result:result];
    }else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - 推流基础接口

- (void)startPush:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    NSString* rtmpUrl = arguments[@"pushUrl"];
    if (!([rtmpUrl hasPrefix:@"rtmp://"])) {
        FlutterError *error = [FlutterError errorWithCode:@"invalid url" message:@"推流地址不合法，目前只支持rtmp推流!" details:nil];
        result(error);
        return;
    }
    // 检查摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied) {
        FlutterError *error = [FlutterError errorWithCode:@"permission denied" message:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限" details:nil];
        result(error);
        return;
    }

    // 检查麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied) {
        FlutterError *error = [FlutterError errorWithCode:@"permission denied" message:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限" details:nil];
        result(error);
        return;
    }
    // 设置delegate
     [_pusher setDelegate:self];
     // 开启预览
     [_pusher startPreview:_localView];
    // 开始推流
    int ret = [_pusher startPush:rtmpUrl];
    result(@(ret));
}

- (void)stopPush:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [self _stopPush];
    result(@(0));
}

- (void)_stopPush{
    if (_pusher) {
        [_pusher setDelegate:nil];
        [_pusher stopPreview];
        [_pusher stopPush];
        [_pusher stopBGM];
    }
}

// 启动摄像头预览。
- (void)startPreview:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    int ret = [_pusher startPreview:_localView];
    result(@(ret));
}

// 停止摄像头预览
- (void)stopPreview:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_pusher stopPreview];
    result(@(0));
}

// 暂停摄像头采集并进入垫片推流状态。
- (void)pausePush:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_pusher pausePush];
    result(@(0));
}

// 恢复摄像头采集并结束垫片推流状态。
- (void)resumePush:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_pusher resumePush];
    result(@(0));
}

// 查询是否正在推流。
- (void)isPublishing:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    result(@([_pusher isPublishing]));
}

#pragma mark - 视频相关接口

- (void)setVideoQuality:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    int quality = [arguments[@"quality"] intValue];
    TX_Enum_Type_VideoQuality qualityEnum = VIDEO_QUALITY_HIGH_DEFINITION;
    if (1 == quality){
        qualityEnum = VIDEO_QUALITY_STANDARD_DEFINITION;
    } else if (2 == quality){
       qualityEnum = VIDEO_QUALITY_HIGH_DEFINITION;
    } else if (3 == quality){
       qualityEnum = VIDEO_QUALITY_SUPER_DEFINITION;
    } else if (4 == quality){
       qualityEnum = VIDEO_QUALITY_LINKMIC_MAIN_PUBLISHER;
    } else if (5 == quality){
       qualityEnum = VIDEO_QUALITY_LINKMIC_SUB_PUBLISHER;
    } else if (7 == quality){
       qualityEnum = VIDEO_QUALITY_ULTRA_DEFINITION;
    }
    [_pusher setVideoQuality:qualityEnum adjustBitrate:[arguments[@"adjustBitrate"] boolValue] adjustResolution:[arguments[@"adjustResolution"] boolValue]];
    result(@(0));
}

// 切换前后摄像头
- (void)switchCamera:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    result(@([_pusher switchCamera]));
}

// 设置视频镜像效果
- (void)setMirror:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_pusher setMirror:[arguments[@"isMirror"] boolValue]];
    result(@(YES));
}

// 设置本地摄像头预览画面的旋转方向
- (void)setRenderRotation:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    if(_pusher){
        int renderRotation = [arguments[@"renderRotation"] intValue];
        [_pusher setRenderRotation:renderRotation];
    }
    result(@(0));
}

// 打开后置摄像头旁边的闪关灯
- (void)turnOnFlashLight:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    result(@([_pusher toggleTorch:[arguments[@"enable"] boolValue]]));
}

// 调整摄像头的焦距
- (void)setZoom:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_pusher setZoom:[arguments[@"value"] intValue]];
    result(@(0));
}

#pragma mark - 音频相关接口
/// 开启静音。
- (void)setMute:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_pusher setMute:[arguments[@"mute"] boolValue]];
    result(@(0));
}

/// 播放背景音乐
- (void)playBGM:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    BOOL ret = [_pusher playBGM:arguments[@"path"]
        withBeginNotify:^(NSInteger errCode){
            [_channel invokeMethod:@"onBGMStart" arguments:nil];
        }
        withProgressNotify:^(NSInteger progressMS, NSInteger durationMS){
            NSDictionary *dict = @{@"progress":@(progressMS), @"duration":@(durationMS)};
            [_channel invokeMethod:@"onBGMProgress" arguments:dict];
        }
        andCompleteNotify:^(NSInteger errCode){
            NSDictionary *dict = @{@"err":@(errCode)};
            [_channel invokeMethod:@"onBGMComplete" arguments:dict];
        }
    ];
    result(@(ret));
}

/// 停止播放背景音乐
- (void)stopBGM:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    BOOL ret = [_pusher stopBGM];
    result(@(ret));
}

/// 暂停播放背景音乐
- (void)pauseBGM:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    BOOL ret = [_pusher pauseBGM];
    result(@(ret));
}

/// 继续播放背音乐
- (void)resumeBGM:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    BOOL ret = [_pusher resumeBGM];
    result(@(ret));
}

/// 获取背景音乐文件的总时长，单位是毫秒
- (void)getMusicDuration:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    int ret = [_pusher getMusicDuration:arguments[@"path"]];
    result(@(ret));
}

/// 设置混音时背景音乐的音量大小，仅在播放背景音乐混音时使用
- (void)setBGMVolume:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    BOOL ret = [_pusher setBGMVolume:[arguments[@"volume"] floatValue]];
    result(@(ret));
}

/// 设置混音时麦克风音量大小，仅在播放背景音乐混音时使用
- (void)setMicVolume:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    BOOL ret = [_pusher setMicVolume:[arguments[@"volume"] floatValue]];
    result(@(ret));
}

/// 调整背景音乐的音调高低
- (void)setBGMPitch:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_pusher setBGMPitch:[arguments[@"pitch"] floatValue]];
    result(@(0));
}

/// 设置混响效果
- (void)setReverb:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    int type = (int)arguments[@"reverbType"];
    TXReverbType typeEnum;
    switch (type) {
        case 0:
            typeEnum = REVERB_TYPE_0;
            break;
        case 1:
            typeEnum = REVERB_TYPE_1;
            break;
        case 2 :
            typeEnum = REVERB_TYPE_2;
            break;
        case 3:
            typeEnum = REVERB_TYPE_3;
            break;
        case 4:
            typeEnum = REVERB_TYPE_4;
            break;
        case 5:
            typeEnum = REVERB_TYPE_5;
            break;
        case 6:
            typeEnum = REVERB_TYPE_6;
            break;
        case 7:
            typeEnum = REVERB_TYPE_7;
            break;
        default:
            typeEnum = REVERB_TYPE_0;
            break;
    }
    [_pusher setReverbType:typeEnum];
    result(@(0));
}

/// 设置变声类型
- (void)setVoiceChangerType:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    int type = (int)arguments[@"voiceChangerType"];
    TXVoiceChangerType typeEnum;
    switch (type) {
        case 0:
            typeEnum = VOICECHANGER_TYPE_0;
            break;
        case 1:
            typeEnum = VOICECHANGER_TYPE_1;
            break;
        case 2 :
            typeEnum = VOICECHANGER_TYPE_2;
            break;
        case 3:
            typeEnum = VOICECHANGER_TYPE_3;
            break;
        case 4:
            typeEnum = VOICECHANGER_TYPE_4;
            break;
        case 5:
            typeEnum = VOICECHANGER_TYPE_5;
            break;
        case 6:
            typeEnum = VOICECHANGER_TYPE_6;
            break;
        case 7:
            typeEnum = VOICECHANGER_TYPE_7;
            break;
        case 8:
            typeEnum = VOICECHANGER_TYPE_8;
            break;
        case 9:
            typeEnum = VOICECHANGER_TYPE_9;
            break;
        case 10:
            typeEnum = VOICECHANGER_TYPE_10;
            break;
        case 11:
            typeEnum = VOICECHANGER_TYPE_11;
            break;
        default:
            typeEnum = VOICECHANGER_TYPE_0;
            break;
    }
    [_pusher setVoiceChangerType:typeEnum];
    result(@(0));
}

#pragma mark - TXLivePushListener

- (void)onPushEvent:(int)evtID withParam:(NSDictionary *)param {
    NSMutableDictionary *dict=[NSMutableDictionary  dictionaryWithDictionary:param];
    [dict setObject:@(evtID) forKey:@"event"];

    [_channel invokeMethod:@"onPushEvent" arguments:dict];
}

- (void)onNetStatus:(NSDictionary *)param {
    // 这里可以上报相关推流信息到业务服务器
    // 比如：码率，分辨率，帧率，cpu使用，缓存等信息
    // 字段请在TXLiveSDKTypeDef.h中定义
}

- (void)dealloc {
    [self _stopPush];
}

#pragma mark - setPushConfig
- (void)setPushConfig:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    TXLivePushConfig *config = _pusher.config;
// NSLog(@"IOS setPushConfig: %@", arguments);
    ////////////////  常用设置项
    if([[arguments allKeys] containsObject:@"homeOrientation"]){
        config.homeOrientation = [arguments[@"homeOrientation"] intValue];
    }
    if([[arguments allKeys] containsObject:@"touchFocus"]){
        config.touchFocus = [arguments[@"touchFocus"] boolValue];
    }
    if([[arguments allKeys] containsObject:@"enableZoom"]){
        config.enableZoom = [arguments[@"enableZoom"] boolValue];
    }

    if([[arguments allKeys] containsObject:@"watermark"]){
        FlutterStandardTypedData *watermark = arguments[@"watermark"];
        config.watermark = [UIImage imageWithData: watermark.data];
    }
    if([[arguments allKeys] containsObject:@"watermarkNormalization"]){
        NSArray *watermarkNormalization = arguments[@"watermarkNormalization"];
        config.watermarkNormalization = CGRectMake([[watermarkNormalization objectAtIndex:0] floatValue], [[watermarkNormalization objectAtIndex:1] floatValue], [[watermarkNormalization objectAtIndex:2] floatValue], 0);
    }
    if([[arguments allKeys] containsObject:@"localVideoMirrorType"]){
        config.localVideoMirrorType = [arguments[@"localVideoMirrorType"] intValue];
    }
    ////////////////   垫片推流（App 切后台）
    if([[arguments allKeys] containsObject:@"pauseTime"]){
        config.pauseTime = [arguments[@"pauseTime"] intValue];
    }
    if([[arguments allKeys] containsObject:@"pauseFps"]){
        config.pauseFps = [arguments[@"pauseFps"] intValue];
    }
    if([[arguments allKeys] containsObject:@"pauseImg"]){
        FlutterStandardTypedData *pauseImg = arguments[@"pauseImg"];
        config.pauseImg = [UIImage imageWithData: pauseImg.data];
    }
    ////////////////    音视频编码参数
    if([[arguments allKeys] containsObject:@"videoResolution"]){
        config.videoResolution = [arguments[@"videoResolution"] intValue];
    }
    if([[arguments allKeys] containsObject:@"videoFPS"]){
        config.videoFPS = [arguments[@"videoFPS"] intValue];
    }
    if([[arguments allKeys] containsObject:@"videoEncodeGop"]){
        config.videoEncodeGop = [arguments[@"videoEncodeGop"] intValue];
    }
    if([[arguments allKeys] containsObject:@"enableAutoBitrate"]){
        config.enableAutoBitrate = [arguments[@"enableAutoBitrate"] boolValue];
    }
    if([[arguments allKeys] containsObject:@"autoAdjustStrategy"]){
        config.autoAdjustStrategy = [arguments[@"autoAdjustStrategy"] intValue];
    }
    if([[arguments allKeys] containsObject:@"videoBitrateMax"]){
        config.videoBitrateMax = [arguments[@"videoBitrateMax"] intValue];
    }
    if([[arguments allKeys] containsObject:@"videoBitrateMin"]){
        config.videoBitrateMin = [arguments[@"videoBitrateMin"] intValue];
    }
    if([[arguments allKeys] containsObject:@"audioSampleRate"]){
        config.audioSampleRate = [arguments[@"audioSampleRate"] intValue];
    }
    if([[arguments allKeys] containsObject:@"audioChannels"]){
        config.audioChannels = [arguments[@"audioChannels"] intValue];
    }
    if([[arguments allKeys] containsObject:@"enableAudioPreview"]){
        config.enableAudioPreview = [arguments[@"enableAudioPreview"] boolValue];
    }
    if([[arguments allKeys] containsObject:@"enablePureAudioPush"]){
        config.enablePureAudioPush = [arguments[@"enablePureAudioPush"] boolValue];
    }
    ////////////////    网络相关参数
    if([[arguments allKeys] containsObject:@"connectRetryCount"]){
        config.connectRetryCount = [arguments[@"connectRetryCount"] intValue];
    }
    if([[arguments allKeys] containsObject:@"connectRetryInterval"]){
        config.connectRetryInterval = [arguments[@"connectRetryInterval"] intValue];
    }
    ////////////////    自定义采集和处理
    if([[arguments allKeys] containsObject:@"customModeType"]){
        config.customModeType = [arguments[@"customModeType"] intValue];
    }
    ///////////////    专业设置项（慎用）
    if([[arguments allKeys] containsObject:@"enableANS"]){
        config.enableNAS = [arguments[@"enableANS"] boolValue];
    }
    if([[arguments allKeys] containsObject:@"enableAEC"]){
        config.enableAEC = [arguments[@"enableAEC"] boolValue];
    }
    if([[arguments allKeys] containsObject:@"enableHWAcceleration"]){
        config.enableHWAcceleration = [arguments[@"enableHWAcceleration"] boolValue];
    }
    if([[arguments allKeys] containsObject:@"enableAGC"]){
        config.enableAGC = [arguments[@"enableAGC"] boolValue];
    }
    if([[arguments allKeys] containsObject:@"volumeType"]){
        int volumeType = [arguments[@"volumeType"] intValue];
        if(0 == volumeType){
            config.volumeType = SYSTEM_AUDIO_VOLUME_TYPE_AUTO;
        }else if(1 == volumeType){
            config.volumeType = SYSTEM_AUDIO_VOLUME_TYPE_MEDIA;
        }else if(2 == volumeType){
            config.volumeType = SYSTEM_AUDIO_VOLUME_TYPE_VOIP;
        }
    }

  //  [_pusher setConfig:config];
    result(@(0));
}


@end


