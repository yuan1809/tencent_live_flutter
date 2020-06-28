#import "FlutterTXCloudPullView.h"

@implementation FlutterTXCloudPullViewFactory {
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
  FlutterTXCloudPullView* pullView = [[FlutterTXCloudPullView alloc] initWithFrame:frame
                                                                         viewIdentifier:viewId
                                                                              arguments:args
                                                                        binaryMessenger:_messenger];
  return pullView;
}

@end

@implementation FlutterTXCloudPullView {
  UIView* _videoView;
  TXLivePlayer* _player;

  int64_t _viewId;
  FlutterMethodChannel* _channel;
  FlutterBasicMessageChannel* _snapshotChannel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
    _viewId = viewId;

    NSString* channelName = [NSString stringWithFormat:@"com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    __weak __typeof__(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      [weakSelf onMethodCall:call result:result];
    }];

    [self initSnapshotChannel:messenger widthId:viewId];

    // 创建播放器
    _player = [[TXLivePlayer alloc] init];

    // 视频画面显示
    _videoView = [[UIView alloc] initWithFrame:frame];
  }
  return self;
}

- (UIView*)view {
  return _videoView;
}

- (void)initSnapshotChannel: (NSObject<FlutterBinaryMessenger>*)messenger widthId: (int64_t)viewId{
    NSString* channelName = [NSString stringWithFormat:@"com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView_Snapshot_%lld", viewId];
    _snapshotChannel = [FlutterBasicMessageChannel messageChannelWithName:channelName binaryMessenger:messenger codec:[FlutterBinaryCodec sharedInstance]];
  // 接收到flutter端snapshot调用后，将截图数据传回调给flutter层
    [_snapshotChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        callback(nil);
        [_player snapshot:^(TXImage *image){
            [_snapshotChannel sendMessage:UIImagePNGRepresentation(image)];
        }];
    }];
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([[call method] isEqualToString:@"setPlayConfig"]){
    [self setPlayConfig:[call arguments] result:result];
  } else if ([[call method] isEqualToString:@"startPlay"]) {
    [self startPlay:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"stopPlay"]){
    [self stopPlay:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"pause"]){
    [self pause:[call arguments] result:result];
  }  else if([[call method] isEqualToString:@"resume"]){
    [self resume:[call arguments] result:result];
  }  else if([[call method] isEqualToString:@"isPlaying"]){
    [self isPlaying:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"setRenderMode"]){
    [self setRenderMode:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"setRenderRotation"]){
    [self setRenderRotation:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"enableHardwareDecode"]){
    [self enableHardwareDecode:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"setMute"]){
    [self setMute:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"setVolume"]){
    [self setVolume:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"setAudioRoute"]){
    [self setAudioRoute:[call arguments] result:result];
  } else if([[call method] isEqualToString:@"switchStream"]){
    [self switchStream:[call arguments] result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - 播放基础接口

- (void) setPlayConfig:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
   // NSLog(@"IOS setPlayConfig: %@", arguments);
    TXLivePlayConfig* config = _player.config;
    config.cacheTime = [arguments[@"cacheTime"] floatValue];
    config.bAutoAdjustCacheTime = [arguments[@"bAutoAdjustCacheTime"] boolValue];
    config.maxAutoAdjustCacheTime = [arguments[@"maxAutoAdjustCacheTime"] floatValue];
    config.minAutoAdjustCacheTime = [arguments[@"minAutoAdjustCacheTime"] floatValue];
    config.videoBlockThreshold = [arguments[@"videoBlockThreshold"] intValue];
    config.connectRetryCount = [arguments[@"connectRetryCount"] intValue];
    config.connectRetryInterval = [arguments[@"connectRetryInterval"] intValue];
    config.enableAEC = [arguments[@"enableAEC"] boolValue];
    config.enableMessage = [arguments[@"enableMessage"] boolValue];
    config.enableMetaData = [arguments[@"enableMetaData"] boolValue];
    config.flvSessionKey = arguments[@"flvSessionKey"];
 //   [_player setConfig:config];
    result(@(0));
}

- (void)startPlay:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_player setDelegate:self];
    [_player setupVideoWidget:CGRectZero containView:_videoView insertIndex:0];

    NSString* playUrl = arguments[@"playUrl"];
    TX_Enum_PlayType  _playType;               // 播放类型
    if ([playUrl hasPrefix:@"rtmp:"]) {
        _playType = PLAY_TYPE_LIVE_RTMP;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && ([playUrl rangeOfString:@".flv"].length > 0)) {
        _playType = PLAY_TYPE_LIVE_FLV;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".m3u8"].length > 0) {
        _playType = PLAY_TYPE_VOD_HLS;
    } else{
        FlutterError *error = [FlutterError errorWithCode:@"invalid url" message:@"播放地址不合法，直播目前仅支持rtmp,flv播放方式!" details:nil];
        result(error);
        return;
    }
    int ret = [_player startPlay:playUrl type:_playType];
    result(@(ret));
}

- (void)stopPlay:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [self _stopPlay];
    result(@(0));
}

- (void)_stopPlay{
    if (_player) {
        [_player setDelegate:nil];
        [_player removeVideoWidget];
        [_player stopPlay];
    }
}

- (void)pause:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_player pause];
    result(@(0));
}

- (void)resume:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_player resume];
    result(@(0));
}

- (void)isPlaying:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    result(@([_player isPlaying]));
}

#pragma mark - 播放配置接口

- (void)setRenderMode:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    if(_player){
        int mode = [arguments[@"renderMode"] intValue];
        if (mode == 1) {
            [_player setRenderMode:RENDER_MODE_FILL_EDGE];
        } else {
            [_player setRenderMode:RENDER_MODE_FILL_SCREEN];
        }
    }
    result(@(0));
}

- (void)setRenderRotation:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    if(_player){
        int renderRotation = [arguments[@"renderRotation"] intValue];
        switch(renderRotation){
            case 0:
                [_player setRenderRotation:HOME_ORIENTATION_DOWN];
                break;
            case 90:
                [_player setRenderRotation:HOME_ORIENTATION_LEFT];
                break;
            case 180:
                [_player setRenderRotation:HOME_ORIENTATION_UP];
                break;
            case 270:
                [_player setRenderRotation:HOME_ORIENTATION_RIGHT];
                break;
            default:
                [_player setRenderRotation:HOME_ORIENTATION_DOWN];
        }
    }
    result(@(0));
}

- (void)enableHardwareDecode:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    _player.enableHWAcceleration = [arguments[@"enable"] boolValue];
    result(@(YES));
}

- (void)setMute:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_player setMute:[arguments[@"mute"] boolValue]];
    result(@(0));
}

- (void)setVolume:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [_player setVolume:[arguments[@"volume"] intValue]];
    result(@(0));
}

- (void)setAudioRoute:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    int type = [arguments[@"audioRoute"] intValue];
    if(type == 0){
        [TXLivePlayer setAudioRoute:AUDIO_ROUTE_SPEAKER];
    }else if(type == 1){
        [TXLivePlayer setAudioRoute:AUDIO_ROUTE_RECEIVER];
    }
    result(@(0));
}

- (void)switchStream:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    NSString *playUrl = arguments[@"playUrl"];
    int ret = [_player switchStream:playUrl];
    result(@(ret));
}

- (void)dealloc {
    [self _stopPlay];
}

#pragma mark - TXLivePlayListener

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSMutableDictionary *dict=[NSMutableDictionary  dictionaryWithDictionary:param];
    [dict setObject:@(EvtID) forKey:@"event"];

    [_channel invokeMethod:@"onPlayEvent" arguments:dict];
}

- (void)onNetStatus:(NSDictionary *)param {

}

@end


