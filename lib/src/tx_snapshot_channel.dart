
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// 调用截图后，图片数据通过此回调函数返回. 返回的是 png 格式的图片数据
/// 如果返回null 说明截图失败
typedef void SnapshotResult(ByteData data);

// 截图处理
class TXSnapShotChannel{

  BasicMessageChannel _snapshotChannel;

  TXSnapShotChannel(String channelName, SnapshotResult snapshotResult) {
    // 截图处理
    _snapshotChannel = BasicMessageChannel(channelName, BinaryCodec(),);
    _snapshotChannel.setMessageHandler((message) async{
      if(snapshotResult != null){
        snapshotResult(message as ByteData);
      }
    });
  }

  Future snapshot() async{
    await _snapshotChannel.send(null);
  }

}