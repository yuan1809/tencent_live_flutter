#import <Flutter/Flutter.h>
#import <TXLiteAVSDK_Smart/TXLivePush.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterTXCloudPushView : NSObject <FlutterPlatformView,TXLivePushListener>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (UIView*)view;

@end

@interface FlutterTXCloudPushViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
