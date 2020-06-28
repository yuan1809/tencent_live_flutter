package com.pactera.bg3cs.tencent_live_flutter;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;

import com.tencent.rtmp.ITXLivePushListener;
import com.tencent.rtmp.TXLiveConstants;
import com.tencent.rtmp.TXLivePushConfig;
import com.tencent.rtmp.TXLivePusher;
import com.tencent.rtmp.ui.TXCloudVideoView;
import com.tencent.rtmp.TXLivePusher.OnBGMNotify;
import com.tencent.rtmp.TXLivePusher.ITXSnapshotListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class FlutterTXCloudPushView implements PlatformView, MethodChannel.MethodCallHandler, ITXLivePushListener, OnBGMNotify{

    private static final String TAG = "FlutterTXCloudPushView";

    private final Activity activity;
    private final MethodChannel methodChannel;
    private SnapshotChannel snapShotChannel;
    private TXBeautyManagerChannel txBeautyManagerChannel;

    private TXCloudVideoView mPusherView;

    // 推流
    private TXLivePushConfig mLivePushConfig;                // SDK 推流 config
    private TXLivePusher mLivePusher;                    // SDK 推流类

    // true 使用摄像头录制推流， false 录屏推流
    private boolean mIsUseCamera = true;
    // 是否开启隐私模式
    private boolean mPrivateModel = false;


    public FlutterTXCloudPushView(BinaryMessenger messenger, Activity activity, int id) {
        this.activity = activity;
        methodChannel = new MethodChannel(messenger, "com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView_" + id);
        methodChannel.setMethodCallHandler(this);

        initSnapshotChannel(messenger, id);

        mPusherView = new TXCloudVideoView(activity.getApplicationContext());
        initPush();
    }

    // 必须在推流之前调用
    private void initPush(){
        if(mLivePusher == null){
            mLivePusher = new TXLivePusher(activity.getApplicationContext());
        }
        if(mLivePushConfig == null){
            mLivePushConfig = mLivePusher.getConfig();
        }
    }

    // 设置配置需要放在开始推流之前，否则有部分配置无法生效
    private void setPushConfig(Map<String, Object> request, MethodChannel.Result result){
        Log.e(TAG, request.toString());
        PushConfigMethodChannel pushConfigMethodChannel = new PushConfigMethodChannel(this.mLivePushConfig);
        pushConfigMethodChannel.setPushConfig(request, result);
    }

    @Override
    public View getView() {
        return mPusherView;
    }

    @Override
    public void dispose() {
        methodChannel.setMethodCallHandler(null);
        snapShotChannel.dispose();
        _stopPush();
        if (mPusherView != null){
            mPusherView.onDestroy();
            mPusherView = null;
        }
    }

    private void initSnapshotChannel(BinaryMessenger messenger, int id){

        String channelName = "com.pactera.bg3cs.tencent_live_flutter/TXCloudPushView_Snapshot_" + id;

        snapShotChannel = new SnapshotChannel(messenger, channelName, new SnapshotChannel.Request() {
            @Override
            public void snapshotRequest() {
                mLivePusher.snapshot(new ITXSnapshotListener(){
                    @Override
                    public void onSnapshot(Bitmap bmp){
                        snapShotChannel.sendSnapShot(bmp);
                    }
                });
            }
        });
    }

    private void initTXBeautyManagerChannel(){
        if(txBeautyManagerChannel == null){
            txBeautyManagerChannel = new TXBeautyManagerChannel(methodChannel, mLivePusher.getBeautyManager());
        }
    }



    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> request = (Map<String, Object>) methodCall.arguments;
        switch (methodCall.method) {
            case "setPushConfig":
                setPushConfig(request, result);
                break;
            case "startPush":
                startPush(request, result);
                break;
            case "stopPush":
                stopPush(request, result);
                break;
            case "startCameraPreview":
                startCameraPreview(request, result);
                break;
            case "stopCameraPreview":
                stopCameraPreview(request, result);
                break;
            case "startScreenCapture":
                startScreenCapture(request, result);
                break;
            case "stopScreenCapture":
                stopScreenCapture(request, result);
                break;
            case "pausePusher":
                pausePusher(request, result);
                break;
            case "resumePusher":
                resumePusher(request, result);
                break;
            case "isPushing":
                isPushing(request, result);
                break;
            case "setRenderRotation":
                setRenderRotation(request, result);
                break;
            case "setVideoQuality":
                setVideoQuality(request, result);
                break;
            case "switchCamera":
                switchCamera(request, result);
                break;
            case "setMirror":
                setMirror(request, result);
                break;
            case "turnOnFlashLight":
                turnOnFlashLight(request, result);
                break;
            case "setZoom":
                setZoom(request, result);
                break;
            case "setMute":
                setMute(request, result);
                break;
            case "playBGM":
                playBGM(request, result);
                break;
            case "stopBGM":
                stopBGM(request, result);
                break;
            case "pauseBGM":
                pauseBGM(request, result);
                break;
            case "resumeBGM":
                resumeBGM(request, result);
                break;
            case "getMusicDuration":
                getMusicDuration(request, result);
                break;
            case "setBGMVolume":
                setBGMVolume(request, result);
                break;
            case "setMicVolume":
                setMicVolume(request, result);
                break;
            case "setBGMPitch":
                setBGMPitch(request, result);
                break;
            case "setReverb":
                setReverb(request, result);
                break;
            case "setVoiceChangerType":
                setVoiceChangerType(request, result);
                break;
            default:
                if(methodCall.method.startsWith(TXBeautyManagerChannel.TX_BEAUTY_METHOD_PRE)){
                    initTXBeautyManagerChannel();
                    txBeautyManagerChannel.onTXBeautyMethodCall(methodCall, result);
                }else{
                    result.notImplemented();
                }
        }
    }

    /////////////  ITXLivePushListener ////////////////////////
    /**
     * 推流器状态回调
     *
     * @param event 事件id.id类型请参考 {@linkplain TXLiveConstants#PLAY_EVT_CONNECT_SUCC 推流事件列表}.
     * @param param
     */
    @Override
    public void onPushEvent(int event, Bundle param) {
//        String msg = param.getString(TXLiveConstants.EVT_DESCRIPTION);
//        String pushEventLog = "receive event: " + event + ", " + msg;
//        Log.d(TAG, pushEventLog);

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

        methodChannel.invokeMethod("onPushEvent", args);
    }


    @Override
    public void onNetStatus(Bundle status) {
//        String str = getStatus(status);
//        Log.d(TAG, "Current status, CPU:" + status.getString(TXLiveConstants.NET_STATUS_CPU_USAGE) +
//                ", RES:" + status.getInt(TXLiveConstants.NET_STATUS_VIDEO_WIDTH) + "*" + status.getInt(TXLiveConstants.NET_STATUS_VIDEO_HEIGHT) +
//                ", SPD:" + status.getInt(TXLiveConstants.NET_STATUS_NET_SPEED) + "Kbps" +
//                ", FPS:" + status.getInt(TXLiveConstants.NET_STATUS_VIDEO_FPS) +
//                ", ARA:" + status.getInt(TXLiveConstants.NET_STATUS_AUDIO_BITRATE) + "Kbps" +
//                ", VRA:" + status.getInt(TXLiveConstants.NET_STATUS_VIDEO_BITRATE) + "Kbps");
    }

    ////////////////////////////////// 推流基础接口 ////////////////////////////////////

    /**
     * 开始推流
     * @param request
     * @param result
     */
    private void  startPush(Map<String, Object> request, MethodChannel.Result result){
        String pushUrl = (String) request.get("pushUrl");
        if (TextUtils.isEmpty(pushUrl) || (!pushUrl.trim().toLowerCase().startsWith("rtmp://"))) {
            result.error("invalid url", "推流地址不合法，目前支持rtmp推流!", null);
            return;
        }

        if(request.containsKey("useCamera")){
            this.mIsUseCamera = (boolean)request.get("useCamera");
        }
        // 添加播放回调
        mLivePusher.setPushListener(this);
        mLivePusher.setBGMNofify(this);

        if (mIsUseCamera) {
            // 显示本地预览的View
            mPusherView.setVisibility(View.VISIBLE);
            // 设置本地预览View
            mLivePusher.startCameraPreview(mPusherView);
//            if (!mFrontCamera) mLivePusher.switchCamera();
        } else {
            // 显示本地预览的View
            mPusherView.setVisibility(View.GONE);
            mLivePusher.startScreenCapture();
        }

        int ret = mLivePusher.startPusher(pushUrl.trim());

        result.success(ret);
    }

    /**
     * 停止 RTMP 推流
     */
    private void stopPush(Map<String, Object> request, MethodChannel.Result result) {
        _stopPush();
        result.success(0);
    }

    private void _stopPush(){
        if(mLivePusher != null){
            // 停止BGM
            mLivePusher.stopBGM();
            // 移除BGM监听
            mLivePusher.setBGMNofify(null);
            if (mIsUseCamera) {
                // 停止本地预览
                mLivePusher.stopCameraPreview(true);
            } else {
                mLivePusher.stopScreenCapture();
            }
            // 移除监听
            mLivePusher.setPushListener(null);
            // 停止推流
            mLivePusher.stopPusher();
            // 隐藏本地预览的View
            mPusherView.setVisibility(View.GONE);
            // 移除垫片图像
            mLivePushConfig.setPauseImg(null);
        }
    }

    /**
     * 开启摄像头预览
     * @param request
     * @param result
     */
    private void startCameraPreview(Map<String, Object> request, MethodChannel.Result result){
        this.mIsUseCamera = true;
        // 显示本地预览的View
        mPusherView.setVisibility(View.VISIBLE);
        // 设置本地预览View
        mLivePusher.startCameraPreview(mPusherView);
        result.success(0);
    }

    /**
     * 停止摄像头预览。
     * @param request
     * @param result
     */
    private void stopCameraPreview(Map<String, Object> request, MethodChannel.Result result){
        // isNeedClearLastImg 是否需要清除最后一帧画面；true：清除最后一帧画面，false：保留最后一帧画面。
        mLivePusher.stopCameraPreview(true);
        result.success(0);
    }

    /**
     * 启动录屏推流
     * @param request
     * @param result
     */
    private void startScreenCapture(Map<String, Object> request, MethodChannel.Result result){
        this.mIsUseCamera = false;
        // 显示本地预览的View
        mPusherView.setVisibility(View.GONE);
        mLivePusher.startScreenCapture();
        result.success(0);
    }

    /**
     * 结束录屏推流。
     * @param request
     * @param result
     */
    private void stopScreenCapture(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.stopScreenCapture();
        result.success(0);
    }

    /**
     * 暂停摄像头或屏幕采集并进入垫片推流状态。
     * @param request
     * @param result
     */
    private void pausePusher(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.pausePusher();
        result.success(0);
    }

    /**
     * 恢复摄像头采集并结束垫片推流状态。
     * @param request
     * @param result
     */
    private void resumePusher(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.resumePusher();
        result.success(0);
    }

    /**
     * 查询是否正在推流。
     * @param request
     * @param result
     */
    private void isPushing(Map<String, Object> request, MethodChannel.Result result){
        result.success(mLivePusher.isPushing());
    }


//    /**
//     * 根据当前 Activity 的旋转方向，配置推流器
//     */
//    @TargetApi(Build.VERSION_CODES.FROYO)
//    private void setRotationForActivity() {
//        // 自动旋转打开，Activity随手机方向旋转之后，需要改变推流方向
//        int mobileRotation = activity.getWindowManager().getDefaultDisplay().getRotation();
//        int pushRotation = TXLiveConstants.VIDEO_ANGLE_HOME_DOWN;
//        switch (mobileRotation) {
//            case Surface.ROTATION_0:
//                pushRotation = TXLiveConstants.VIDEO_ANGLE_HOME_DOWN;
//                break;
//            case Surface.ROTATION_180:
//                pushRotation = TXLiveConstants.VIDEO_ANGLE_HOME_UP;
//                break;
//            case Surface.ROTATION_90:
//                pushRotation = TXLiveConstants.VIDEO_ANGLE_HOME_RIGHT;
//                break;
//            case Surface.ROTATION_270:
//                pushRotation = TXLiveConstants.VIDEO_ANGLE_HOME_LEFT;
//                break;
//            default:
//                break;
//        }
//        mLivePusher.setRenderRotation(0);                                   // 因为activity也旋转了，本地渲染相对正方向的角度为0。
//        mLivePushConfig.setHomeOrientation(pushRotation);                   // 根据Activity方向，设置采集角度
//        // 当前正在推流，
//        if (mLivePusher.isPushing()) {
//            mLivePusher.setConfig(mLivePushConfig);
//            // 不是隐私模式，则开启摄像头推流。
//            if (!mPrivateModel && mIsUseCamera) {
//                mLivePusher.stopCameraPreview(true);
//                mLivePusher.startCameraPreview(mPusherView);
//            }
//        }
//    }

    // 设置视频编码质量
    private void setVideoQuality(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.setVideoQuality((int)request.get("quality"), (boolean)request.get("adjustBitrate"), (boolean)request.get("adjustResolution"));
        result.success(0);
    }

    // 切换前后摄像头
    private void switchCamera(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.switchCamera();
        result.success(0);
    }

    // 设置视频镜像效果
    private void setMirror(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePusher.setMirror((boolean)request.get("isMirror"));
        result.success(ret);
    }

    //横屏|竖屏
    private void setRenderRotation(Map<String, Object> request, MethodChannel.Result result){
        if(mLivePusher != null){
            mLivePusher.setRenderRotation((int)request.get("renderRotation"));
        }
        result.success(0);
    }

    // 打开后置摄像头旁边的闪光灯
    private void turnOnFlashLight(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePusher.turnOnFlashLight((boolean)request.get("enable"));
        result.success(ret);
    }

    // 调整摄像头的焦距
    private void setZoom(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.setZoom((int)request.get("value"));
        result.success(0);
    }

    ///////////////////////////音频相关接口 /////////////////////////////////
    /// 开启静音。
    private void setMute(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.setMute((boolean)request.get("mute"));
        result.success(0);
    }

    /// 播放背景音乐
    private void playBGM(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePusher.playBGM((String)request.get("path"));
        result.success(ret);
    }

    /// 停止播放背景音乐
    private void stopBGM(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePusher.stopBGM();
        result.success(ret);
    }

    /// 暂停播放背景音乐
    private void pauseBGM(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePusher.pauseBGM();
        result.success(ret);
    }

    /// 继续播放背音乐
    private void resumeBGM(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePusher.resumeBGM();
        result.success(ret);
    }

    /// 获取背景音乐文件的总时长，单位是毫秒
    private void getMusicDuration(Map<String, Object> request, MethodChannel.Result result){
        int ret = mLivePusher.getMusicDuration((String)request.get("path"));
        result.success(ret);
    }

    /// 设置混音时背景音乐的音量大小，仅在播放背景音乐混音时使用
    private void setBGMVolume(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePusher.setBGMVolume(((Double)request.get("volume")).floatValue());
        result.success(ret);
    }

    /// 设置混音时麦克风音量大小，仅在播放背景音乐混音时使用
    private void setMicVolume(Map<String, Object> request, MethodChannel.Result result){
        boolean ret = mLivePusher.setMicVolume(((Double)request.get("volume")).floatValue());
        result.success(ret);
    }

    /// 调整背景音乐的音调高低
    private void setBGMPitch(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.setBGMPitch(((Double)request.get("pitch")).floatValue());
        result.success(0);
    }

    /// 设置混响效果
    private void setReverb(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.setReverb((int)request.get("reverbType"));
        result.success(0);
    }

    /// 设置变声类型
    private void setVoiceChangerType(Map<String, Object> request, MethodChannel.Result result){
        mLivePusher.setVoiceChangerType((int)request.get("voiceChangerType"));
        result.success(0);
    }

    /////////////////// 背景音乐回调
    // 音乐播放开始的回调通知
    @Override
    public void onBGMStart(){
        HashMap<String, Object> args = new HashMap<>();
        methodChannel.invokeMethod("onBGMStart", args);
    }

    // 音乐播放进度的回调通知
    @Override
    public void onBGMProgress(long progress, long duration){
        final HashMap<String, Object> args = new HashMap<>();
        args.put("progress", progress);
        args.put("duration", duration);
        activity.runOnUiThread(new Runnable()
        {
            public void run()
            {
                methodChannel.invokeMethod("onBGMProgress", args);
            }

        });

    }

    // 音乐播放结束的回调通知
    @Override
    public void onBGMComplete(int err){
        HashMap<String, Object> args = new HashMap<>();
        args.put("err", err);
        methodChannel.invokeMethod("onBGMComplete", args);
    }


}
