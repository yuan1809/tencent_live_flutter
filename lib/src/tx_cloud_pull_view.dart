
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tx_snapshot_channel.dart';
import 'tx_cloud_pull_view_controller.dart';

typedef void TXCloudPullViewCreatedCallback(TXCloudPullViewController controller);

class TXCloudPullView extends StatefulWidget{

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

  final TXCloudPullViewCreatedCallback onTXCloudPullViewCreated;

  final PlayEventListener onPlayEventListener;

  final SnapshotResult snapshotResult;

  const TXCloudPullView({Key key, this.gestureRecognizers, this.onTXCloudPullViewCreated, this.onPlayEventListener, this.snapshotResult}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TXCloudPullViewState();
  }

}

class _TXCloudPullViewState extends State<TXCloudPullView>{

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
    };
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView',
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView',
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
    final TXCloudPullViewController controller = TXCloudPullViewController(
        id,
        onPlayEventListener: widget.onPlayEventListener,
        snapshotResult: widget.snapshotResult
    );
    if (widget.onTXCloudPullViewCreated != null) {
      widget.onTXCloudPullViewCreated(controller);
    }
  }

}