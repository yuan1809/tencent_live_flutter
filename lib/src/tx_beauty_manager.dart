import 'package:flutter/services.dart';

/// 美颜、美容、动效挂件类基础函数
class TXBeautyManager{

  // 该管理类调用原生方法都增加该前缀，用以区分
  static const METHOD_PRE = "TXBeauty#";

  final MethodChannel _channel;

  TXBeautyManager(this._channel);

  /// 设置美颜类型。
  /// [beautyStyle] 美颜风格，0表示光滑，1表示自然，2表示朦胧
  Future setBeautyStyle(int beautyStyle) async{
    return await _channel.invokeMethod<int>("${METHOD_PRE}setBeautyStyle", {"beautyStyle":beautyStyle});
  }

  /// 设置指定素材滤镜特效。
  /// [imageData] 滤镜图片一定要用 png 格式
  Future setFilter(ByteData imageData) async{
    return await _channel.invokeMethod<int>("${METHOD_PRE}setFilter", {"imageData":imageData.buffer.asUint8List()});
  }

  /// 设置滤镜浓度。
  /// [strength] 取值范围0 - 1的浮点型数字，取值越大滤镜效果越明显，默认取值0.5
  Future setFilterStrength(double strength) async{
    return await _channel.invokeMethod<int>("${METHOD_PRE}setFilterStrength", {"strength":strength});
  }

  /// 设置美颜级别。
  /// [beautyLevel] 美颜级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
  Future setBeautyLevel(int beautyLevel) async{
    return await _channel.invokeMethod<int>("${METHOD_PRE}setBeautyLevel", {"beautyLevel":beautyLevel});
  }

  /// 设置美白级别。
  /// [whitenessLevel] 美白级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
  Future setWhitenessLevel(int whitenessLevel) async{
    return await _channel.invokeMethod<int>("${METHOD_PRE}setWhitenessLevel", {"whitenessLevel":whitenessLevel});
  }

  /// 设置红润级别。
  /// [ruddyLevel] 红润级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
  Future setRuddyLevel(int ruddyLevel) async{
    return await _channel.invokeMethod<int>("${METHOD_PRE}setRuddyLevel", {"ruddyLevel":ruddyLevel});
  }


}