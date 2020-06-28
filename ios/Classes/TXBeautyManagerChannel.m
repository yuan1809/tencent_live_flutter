#import "TXBeautyManagerChannel.h"

@implementation TXBeautyManagerChannel{
    FlutterMethodChannel* _channel;
    TXBeautyManager* _txBeautyManager;
}

- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)channel withBeautyManager:(TXBeautyManager *)txBeautyManager{
     if (self = [super init]) {
        _channel = channel;
        _txBeautyManager = txBeautyManager;
     }
     return self;
}


- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString *methodName = [[call method] stringByReplacingOccurrencesOfString:TX_BEAUTY_METHOD_PRE withString:@""];
    NSDictionary<NSString*, id> *arguments = [call arguments];
    if([methodName isEqualToString:@"setBeautyStyle"]){
       [self setBeautyStyle:arguments result:result];
    }else if([methodName isEqualToString:@"setFilter"]){
        [self setFilter:arguments result:result];
    }else if([methodName isEqualToString:@"setFilterStrength"]){
        [self setFilterStrength:arguments result:result];
    }else if([methodName isEqualToString:@"setBeautyLevel"]){
        [self setBeautyLevel:arguments result:result];
    }else if([methodName isEqualToString:@"setWhitenessLevel"]){
        [self setWhitenessLevel:arguments result:result];
    }else if([methodName isEqualToString:@"setRuddyLevel"]){
        [self setRuddyLevel:arguments result:result];
    }else{
        result(FlutterMethodNotImplemented);
    }
}

/// 设置美颜类型。
/// [beautyStyle] 美颜风格，0表示光滑，1表示自然，2表示朦胧
- (void)setBeautyStyle:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result  {
    int beautyStyle = [arguments[@"beautyStyle"] intValue];
    TXBeautyStyle beautyStyleEnum = TXBeautyStyleSmooth;
    if(0 == beautyStyle){
        beautyStyleEnum = TXBeautyStyleSmooth;
    }else if(1 == beautyStyle){
        beautyStyleEnum = TXBeautyStyleNature;
    }else if(2 == beautyStyle){
        beautyStyleEnum = TXBeautyStylePitu;
    }
    [_txBeautyManager setBeautyStyle:beautyStyleEnum];
    result(@(0));
}

/// 设置指定素材滤镜特效。
/// [imageData] 滤镜图片一定要用 png 格式
- (void)setFilter:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result {
    FlutterStandardTypedData *imageData = arguments[@"imageData"];
    [_txBeautyManager setFilter:[UIImage imageWithData: imageData.data]];
    result(@(0));
}

/// 设置滤镜浓度。
/// [strength] 取值范围0 - 1的浮点型数字，取值越大滤镜效果越明显，默认取值0.5
- (void)setFilterStrength:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result  {
    [_txBeautyManager setFilterStrength:[arguments[@"strength"] floatValue]];
    result(@(0));
}

/// 设置美颜级别。
/// [beautyLevel] 美颜级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
- (void)setBeautyLevel:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result  {
    [_txBeautyManager setBeautyLevel:[arguments[@"beautyLevel"] intValue]];
    result(@(0));
}

/// 设置美白级别。
/// [whitenessLevel] 美白级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
- (void)setWhitenessLevel:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result  {
    [_txBeautyManager setWhitenessLevel:[arguments[@"whitenessLevel"] intValue]];
    result(@(0));
}

/// 设置红润级别。
/// [ruddyLevel] 红润级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
- (void)setRuddyLevel:(NSDictionary<NSString*, id>*)arguments result:(FlutterResult)result  {
    [_txBeautyManager setRuddyLevel:[arguments[@"ruddyLevel"] intValue]];
    result(@(0));
}

@end