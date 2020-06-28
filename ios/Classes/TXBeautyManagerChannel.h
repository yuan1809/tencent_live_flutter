#import <Flutter/Flutter.h>
#import <TXLiteAVSDK_Smart/TXBeautyManager.h>

static NSString * const TX_BEAUTY_METHOD_PRE = @"TXBeauty#";

@interface TXBeautyManagerChannel : NSObject

- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)channel withBeautyManager:(TXBeautyManager *)txBeautyManager;


- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

@end
