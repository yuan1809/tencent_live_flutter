
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tx_cloud_push_view_controller.dart';
import 'tx_snapshot_channel.dart';

typedef void TXCloudPushViewCreatedCallback(TXCloudPushViewController controller);

class TXCloudPushView extends StatefulWidget{

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  final TXCloudPushViewCreatedCallback onTXCloudPushViewCreated;

  final PushEventListener onPushEventListener;

  final OnBGMNotify onBGMNotify;

  final SnapshotResult snapshotResult;

  const TXCloudPushView({Key key, this.gestureRecognizers, this.onTXCloudPushViewCreated, this.onPushEventListener, this.onBGMNotify, this.snapshotResult}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TXCloudPushViewState();
  }

}

class _TXCloudPushViewState extends State<TXCloudPushView>{

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
    };
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView',
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView',
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the live plugin');
  }

  Future<void> onPlatformViewCreated(int id) async {
    final TXCloudPushViewController controller = TXCloudPushViewController(
        id,
        onPushEventListener: widget.onPushEventListener,
        onBGMNotify: widget.onBGMNotify,
        snapshotResult: widget.snapshotResult
    );
    if (widget.onTXCloudPushViewCreated != null) {
      widget.onTXCloudPushViewCreated(controller);
    }
  }

}