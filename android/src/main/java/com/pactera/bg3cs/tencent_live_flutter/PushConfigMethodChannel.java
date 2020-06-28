package com.pactera.bg3cs.tencent_live_flutter;

import java.util.Map;
import java.util.List;

import android.graphics.BitmapFactory;
import android.graphics.Bitmap;
import com.tencent.rtmp.TXLiveConstants;
import com.tencent.rtmp.TXLivePushConfig;

import io.flutter.plugin.common.MethodChannel;

// PushConfig 设置项太多，独立在这个类里面
class PushConfigMethodChannel{

    TXLivePushConfig mLivePushConfig;

    public PushConfigMethodChannel(TXLivePushConfig mLivePushConfig){
        this.mLivePushConfig = mLivePushConfig;
    }

    private Bitmap createBitmap(byte[] data){
        return BitmapFactory.decodeByteArray(data , 0, data.length);
    }

    // 设置配置需要放在开始推流之前，否则有部分配置无法生效
    public void setPushConfig(Map<String, Object> request, MethodChannel.Result result){

        ////////////////  常用设置项
        if(request.containsKey("homeOrientation")){
            mLivePushConfig.setHomeOrientation((int)request.get("homeOrientation"));
        }
        if(request.containsKey("touchFocus")){
            mLivePushConfig.setTouchFocus((boolean)request.get("touchFocus"));
        }
        if(request.containsKey("enableZoom")){
            mLivePushConfig.setEnableZoom((boolean)request.get("enableZoom"));
        }

        Bitmap watermark;
        if(request.containsKey("watermark")){
            watermark = createBitmap((byte[]) request.get("watermark"));
            if(request.containsKey("watermarkNormalization")){
                List watermarkNormalization = (List) request.get("watermarkNormalization");
                mLivePushConfig.setWatermark(watermark, ((Double)watermarkNormalization.get(0)).floatValue(), ((Double)watermarkNormalization.get(1)).floatValue(), ((Double)watermarkNormalization.get(2)).floatValue());
            }else{
                mLivePushConfig.setWatermark(watermark, 0f, 0f, 1f);
            }
        }
        if(request.containsKey("localVideoMirrorType")){
            mLivePushConfig.setLocalVideoMirrorType((int)request.get("localVideoMirrorType"));
        }
////////////////   垫片推流（App 切后台）
        if(request.containsKey("pauseTime") && request.containsKey("pauseFps")){
            mLivePushConfig.setPauseImg((int)request.get("pauseTime"), (int)request.get("pauseFps"));
        }
        if(request.containsKey("pauseImg")){
            mLivePushConfig.setPauseImg(createBitmap((byte[])request.get("pauseImg")));
        }
////////////////    音视频编码参数
        if(request.containsKey("videoResolution")){
            mLivePushConfig.setVideoResolution((int)request.get("videoResolution"));
        }
        if(request.containsKey("videoFPS")){
            mLivePushConfig.setVideoFPS((int)request.get("videoFPS"));
        }
        if(request.containsKey("videoEncodeGop")){
            mLivePushConfig.setVideoEncodeGop((int)request.get("videoEncodeGop"));
        }
        if(request.containsKey("enableAutoBitrate")){
            mLivePushConfig.setAutoAdjustBitrate((boolean)request.get("enableAutoBitrate"));
        }
        if(request.containsKey("autoAdjustStrategy")){
            mLivePushConfig.setAutoAdjustStrategy((int)request.get("autoAdjustStrategy"));
        }
        if(request.containsKey("videoBitrateMax")){
            mLivePushConfig.setMaxVideoBitrate((int)request.get("videoBitrateMax"));
        }
        if(request.containsKey("videoBitrateMin")){
            mLivePushConfig.setMinVideoBitrate((int)request.get("videoBitrateMin"));
        }
        if(request.containsKey("audioSampleRate")){
            mLivePushConfig.setAudioSampleRate((int)request.get("audioSampleRate"));
        }
        if(request.containsKey("audioChannels")){
            mLivePushConfig.setAudioChannels((int)request.get("audioChannels"));
        }
        if(request.containsKey("enableAudioPreview")){
            mLivePushConfig.enableAudioEarMonitoring((boolean)request.get("enableAudioPreview"));
        }
        if(request.containsKey("enablePureAudioPush")){
            mLivePushConfig.enablePureAudioPush((boolean)request.get("enablePureAudioPush"));
        }
////////////////    网络相关参数
        if(request.containsKey("connectRetryCount")){
            mLivePushConfig.setConnectRetryCount((int)request.get("connectRetryCount"));
        }
        if(request.containsKey("connectRetryInterval")){
            mLivePushConfig.setConnectRetryInterval((int)request.get("connectRetryInterval"));
        }
////////////////    自定义采集和处理
        if(request.containsKey("customModeType")){
            mLivePushConfig.setCustomModeType((int)request.get("customModeType"));
        }
///////////////    专业设置项（慎用）
        if(request.containsKey("enableANS")){
            mLivePushConfig.enableANS((boolean)request.get("enableANS"));
        }
        if(request.containsKey("enableAEC")){
            mLivePushConfig.enableAEC((boolean)request.get("enableAEC"));
        }
        if(request.containsKey("enableHWAcceleration")){
            boolean enableHWAcceleration = (boolean)request.get("enableHWAcceleration");
            if(enableHWAcceleration){
                mLivePushConfig.setHardwareAcceleration(TXLiveConstants.ENCODE_VIDEO_HARDWARE);
            }else{
                mLivePushConfig.setHardwareAcceleration(TXLiveConstants.ENCODE_VIDEO_SOFTWARE);
            }
        }
        if(request.containsKey("enableAGC")){
            mLivePushConfig.enableAGC((boolean)request.get("enableAGC"));
        }
        if(request.containsKey("volumeType")){
            mLivePushConfig.setVolumeType((int)request.get("volumeType"));
        }

        result.success(0);
    }

}