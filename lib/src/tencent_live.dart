import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class TencentLive{

  static TencentLive _instance;

  static TencentLive get instance {
    if (_instance == null) {
      _instance = TencentLive();

    }
    return _instance;
  }

  TencentLive(){
    _channel.setMethodCallHandler(_handleMethod);
  }

  final MethodChannel _channel =
      const MethodChannel('com.pactera.bg3cs.tencent_live_flutter');

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {

    }
  }

  /// 初始化SDK
  ///
  /// license申请请参考 https://console.cloud.tencent.com/live/license
  Future<void> init({
    @required String licenseUrl,
    @required String licenseKey,
  }) async {
    // iOS端有一个坑, 生成出来的licenseUrl是以http开头的, 在ios上会报鉴权失败(-5), 实际上
    // 你需要把 http 改成 https , 才能正常推流!
    final httpsUrl = Uri.parse(licenseUrl).scheme == 'http'
        ? licenseUrl.replaceFirst('http', 'https')
        : Uri.parse(licenseUrl).scheme;
    return await _channel.invokeMethod("setLicence", {"url": httpsUrl, "key": licenseKey});
  }

}