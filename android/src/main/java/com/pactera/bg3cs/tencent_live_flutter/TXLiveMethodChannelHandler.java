package com.pactera.bg3cs.tencent_live_flutter;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.tencent.rtmp.TXLiveBase;

/**
 * 腾讯直播公共函数处理
 */
public class TXLiveMethodChannelHandler implements MethodChannel.MethodCallHandler {

    Context context;

    TXLiveMethodChannelHandler(Context context){
        this.context = context;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> request = (Map<String, Object>) methodCall.arguments;
        switch (methodCall.method) {
            case "setLicence":
                setLicence(request, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void setLicence(Map<String, Object> request, MethodChannel.Result result){
        String licenceUrl = request.get("url").toString();
        String licenseKey = request.get("key").toString();
        TXLiveBase.getInstance().setLicence(context, licenceUrl, licenseKey);
        result.success("success");
    }

}
