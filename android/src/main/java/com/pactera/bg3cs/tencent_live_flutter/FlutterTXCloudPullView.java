package com.pactera.bg3cs.tencent_live_flutter;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import com.tencent.rtmp.ITXLivePlayListener;
import com.tencent.rtmp.TXLiveConstants;
import com.tencent.rtmp.TXLivePlayConfig;
import com.tencent.rtmp.TXLivePlayer;
import com.tencent.rtmp.ui.TXCloudVideoView;
import com.tencent.rtmp.TXLivePlayer.ITXSnapshotListener;

import java.util.HashMap;
import java.util.Map;

public class FlutterTXCloudPullView implements PlatformView, MethodChannel.MethodCallHandler, ITXLivePlayListener{

    private static final String TAG = "FlutterTXCloudPullView";

    private final Activity activity;
    private final MethodChannel methodChannel;
    private SnapshotChannel snapShotChannel;

    private TXCloudVideoView mPlayerView;

    // 拉流播放
    private TXLivePlayer mLivePlayer = null;
    private TXLivePlayConfig mPlayConfig;


    public FlutterTXCloudPullView(BinaryMessenger messenger, Activity activity, int id) {
        this.activity = activity;
        methodChannel = new MethodChannel(messenger, "com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView_" + id);
        methodChannel.setMethodCallHandler(this);

        initSnapshotChannel(messenger, id);

        mPlayerView = new TXCloudVideoView(activity.getApplicationContext());
        initPlay();
    }

    private void initSnapshotChannel(BinaryMessenger messenger, int id){

        String channelName = "com.pactera.bg3cs.tencent_live_flutter/TXCloudPullView_Snapshot_" + id;

        snapShotChannel = new SnapshotChannel(messenger, channelName, new SnapshotChannel.Request() {
            @Override
            public void snapshotRequest() {
                mLivePlayer.snapshot(new ITXSnapshotListener(){
                    @Override
                    public void onSnapshot(Bitmap bmp){
                        snapShotChannel.sendSnapShot(bmp);
                    }
                });
            }
        });
    }

    // 必须在播放之前调用
    private void initPlay() {
        if (mLivePlayer == null) {
            mLivePlayer = new TXLivePlayer(activity.getApplicationContext());
        }
        if(mPlayConfig == null){
            mPlayConfig = new TXLivePlayConfig();
        }
    }

    // 设置配置需要放在开始播放之前，否则有部分配置无法生效
    private void setPlayConfig(Map<String, Object> request, MethodChannel.Result result){
        Log.e(TAG, request.toString());
        mPlayConfig.setCacheTime(((Double)request.get("cacheTime")).floatValue());
        mPlayConfig.setAutoAdjustCacheTime((boolean)request.get("bAutoAdjustCacheTime"));
        mPlayConfig.setMaxAutoAdjustCacheTime(((Double)request.get("maxAutoAdjustCacheTime")).floatValue());
        mPlayConfig.setMinAutoAdjustCacheTime(((Double)request.get("minAutoAdjustCacheTime")).floatValue());
        mPlayConfig.setVideoBlockThreshold((int)request.get("videoBlockThreshold"));
        mPlayConfig.setConnectRetryCount((int)request.get("connectRetryCount"));
        mPlayConfig.setConnectRetryInterval((int)request.get("connectRetryInterval"));
        mPlayConfig.enableAEC((boolean)request.get("enableAEC"));
        mPlayConfig.setEnableMessage((boolean)request.get("enableMessage"));
        mPlayConfig.setEnableMetaData((boolean)request.get("enableMetaData"));
        mPlayConfig.setFlvSessionKey((String)request.get("flvSessionKey"));
//        mLivePlayer.setConfig(mPlayConfig);
        result.success(0);
    }

    @Override
    public View getView() {
        return mPlayerView;
    }

    @Override
    public void dispose() {
        methodChannel.setMethodCallHandler(null);
        snapShotChannel.dispose();
        _stopPlay();
        if (mPlayerView != null){
            mPlayerView.onDestroy();
            mPlayerView = null;
        }
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> request = (Map<String, Object>) methodCall.arguments;
        switch (methodCall.method) {
            case "setPlayConfig":
                setPlayConfig(request, result);
                break;
            case "startPlay":
                startPlay(request, result);
                break;
            case "stopPlay":
                stopPlay(request, result);
                break;
            case "pause":
                pause(request, result);
                break;
            case "resume":
                resume(request,result);
                break;
            case "isPlaying":
                isPlaying(request, result);
                break;
            case "setRenderMode":
                setRenderMode(request, result);
                break;
            case "setRenderRotation":
                setRenderRotation(request, result);
                break;
            case "enableHardwareDecode":
                enableHardwareDecode(request, result);
                break;
            case "setMute":
                setMute(request, result);
                break;
            case "setVolume":
                setVolume(request, result);
                break;
            case "setAudioRoute":
                setAudioRoute(request, result);
                break;
            case "switchStream":
                switchStream(request, result);
                break;
            default:
                result.notImplemented();
        }
    }

    // ITXLivePlayListener
    @Override
    public void onPlayEvent(int event, Bundle param) {

        String playEventLog = "receive event: " + event + ", " + param.getString(TXLiveConstants.EVT_DESCRIPTION);
        Log.d(TAG, playEventLog);

        HashMap<String, Object> args = new HashMap<>();
        args.put("event", event);

        String desc = param.getString(TXLiveConstants.EVT_DESCRIPTION);
        if(desc != null){
            args.put(TXLiveConstants.EVT_DESCRIPTION, desc);
        }
        int defaultValue = -1111;
        int param1 = param.getInt(TXLiveConstants.EVT_PARAM1, defaultValue);
        if(param1 != defaultValue){
            args.put(TXLiveConstants.EVT_PARAM1, param1);
        }
        int param2 = param.getInt(TXLiveConstants.EVT_PARAM2, defaultValue);
        if(param2 != defaultValue){
            args.put(TXLiveConstants.EVT_PARAM2, param2);
        }

        methodChannel.invokeMethod("onPlayEvent", args);
    }

    @Override
    public void onNetStatus(Bundle status) {
//        String str = getNetStatusString(status);
//        Log.d(TAG, "Current status, CPU:" + status.getString(TXLiveConstants.NET_STATUS_CPU_USAGE) +
//                ", RES:" + status.getInt(TXLiveConstants.NET_STATUS_VIDEO_WIDTH) + "*" + status.getInt(TXLiveConstants.NET_STATUS_VIDEO_HEIGHT) +
//                ", SPD:" + status.getInt(TXLiveConstants.NET_STATUS_NET_SPEED) + "Kbps" +
//                ", FPS:" + status.getInt(TXLiveConstants.NET_STATUS_VIDEO_FPS) +
//                ", ARA:" + status.getInt(TXLiveConstants.NET_STATUS_AUDIO_BITRATE) + "Kbps" +
//                ", VRA:" + status.getInt(TXLiveConstants.NET_STATUS_VIDEO_BITRATE) + "Kbps");
//
//        mPlayVisibleLogView.setLogText(status, null, 0);
    }

    //////////////////////////////////  播放基础接口 ////////////////////////////////////

    private void startPlay(Map<String, Object> request, MethodChannel.Result result){
        String playUrl = (String) request.get("playUrl");
        int playType;
        if (playUrl != null && playUrl.startsWith("rtmp://")) {
            playType = TXLivePlayer.PLAY_TYPE_LIVE_RTMP;
        } else if (playUrl != null && (playUrl.startsWith("http://") || playUrl.startsWith("https://"))&& playUrl.contains(".flv")) {
            playType = TXLivePlayer.PLAY_TYPE_LIVE_FLV;
        } else {
            result.error("invalid url", "播放地址不合法，直播目前仅支持rtmp,flv播放方式!", null);
            return;
        }
        mLivePlayer.setPlayListener(this);
        mLivePlayer.setPlayerView(mPlayerView);
        int ret = mLivePlayer.startPlay(playUrl, playType); // result返回值：0 success;  -1 empty url; -2 invalid url; -3 invalid playType;
        result.success(ret);
    }

    private void  stopPlay(Map<String, Object> request, MethodChannel.Result result){
        _stopPlay();
        result.success(0);
    }

    private void _stopPlay(){
        if (mLivePlayer != null) {
            mLivePlayer.stopRecord();
            mLivePlayer.setPlayListener(null);
            mLivePlayer.stopPlay(true);
        }
    }

    private void pause(Map<String, Object> request, MethodChannel.Result result){
        mLivePlayer.pause();
        result.success(0);
    }

    private void resume(Map<String, Object> request, MethodChannel.Result result){
        mLivePlayer.resume();
        result.success(0);
    }

    private void isPlaying(Map<String, Object> request, MethodChannel.Result result){
        result.success(mLivePlayer.isPlaying());
    }


    //////////////////////////////////  播放配置接口 ////////////////////////////////////

    //平铺模式
    private void setRenderMode(Map<String, Object> request, MethodChannel.Result result){
        if(mLivePlayer != null){
            mLivePlayer.setRenderMode((int)request.get("renderMode"));
        }
        result.success(0);
    }

    //横屏|竖屏
    private void setRenderRotation(Map<String, Object> request, MethodChannel.Result result){
        if(mLivePlayer != null){
            mLivePlayer.setRenderRotation((int)request.get("renderRotation"));
        }
        result.success(0);
    }

    // 开启硬件加速
    private void enableHardwareDecode(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePlayer.enableHardwareDecode((boolean)request.get("enable"));
        result.success(ret);
    }

    // 设置是否静音播放
    private void setMute(Map<String, Object> request, MethodChannel.Result result){
        mLivePlayer.setMute((boolean)request.get("mute"));
        result.success(0);
    }

    // 设置音量
    private void setVolume(Map<String, Object> request, MethodChannel.Result result){
        mLivePlayer.setVolume((int)request.get("volume"));
        result.success(0);
    }

    // 设置声音播放模式
    private void setAudioRoute(Map<String, Object> request, MethodChannel.Result result){
        mLivePlayer.setAudioRoute((int)request.get("audioRoute"));
        result.success(0);
    }

    // 设置声音播放模式
    private void switchStream(Map<String, Object> request, MethodChannel.Result result){
        mLivePlayer.switchStream((String)request.get("playUrl"));
        result.success(0);
    }


}
