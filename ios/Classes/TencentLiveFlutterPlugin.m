#import "TencentLiveFlutterPlugin.h"
#import "TXLiveMethodChannelHandler.h"
#import "FlutterTXCloudPullView.h"
#import "FlutterTXCloudPushView.h"

@implementation TencentLiveFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  FlutterMethodChannel *channel = [FlutterMethodChannel
                                       methodChannelWithName:@"com.pactera.bg3cs.tencent_live_flutter"
                                       binaryMessenger:[registrar messenger]];
  [[TXLiveMethodChannelHandler alloc] initWithChannel:channel];


  FlutterTXCloudPullViewFactory* pullViewFactory =
          [[FlutterTXCloudPullViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:pullViewFactory withId:@"com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView"];
  FlutterTXCloudPushViewFactory* pushViewFactory =
            [[FlutterTXCloudPushViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:pushViewFactory withId:@"com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView"];
}


@end
