#import "TXLiveMethodChannelHandler.h"
#import <TXLiteAVSDK_Smart/TXLiveBase.h>

@implementation TXLiveMethodChannelHandler{
    FlutterMethodChannel *_channel;
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
          [self onMethodCall:call result:result];
        }];
    }
    return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"setLicence" isEqualToString:call.method]) {
        [self setLicence:[call arguments] result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)setLicence:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    [TXLiveBase setLicenceURL:arguments[@"url"] key:arguments[@"key"]];
    result(@"success");
}


@end