package com.pactera.bg3cs.tencent_live_flutter;

import android.app.Activity;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformViewRegistry;

/** TencentLiveFlutterPlugin */
public class TencentLiveFlutterPlugin implements FlutterPlugin, ActivityAware {

  private BinaryMessenger messenger;
  private PlatformViewRegistry platformViewRegistry;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.messenger = flutterPluginBinding.getBinaryMessenger();
    this.platformViewRegistry = flutterPluginBinding.getPlatformViewRegistry();
    new MethodChannel(this.messenger, "com.pactera.bg3cs.tencent_live_flutter")
            .setMethodCallHandler(new TXLiveMethodChannelHandler(flutterPluginBinding.getApplicationContext()));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    Activity activity = activityPluginBinding.getActivity();
    platformViewRegistry.registerViewFactory("com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView",
            new TXCloudPullViewFactory(messenger, activity));
    platformViewRegistry.registerViewFactory("com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView",
            new TXCloudPushViewFactory(messenger, activity));
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
