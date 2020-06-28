#import <Flutter/Flutter.h>
#import <TXLiteAVSDK_Smart/TXLivePlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterTXCloudPullView : NSObject <FlutterPlatformView, TXLivePlayListener>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (UIView*)view;

@end

@interface FlutterTXCloudPullViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
