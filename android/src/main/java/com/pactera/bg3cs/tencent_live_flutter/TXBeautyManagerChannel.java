package com.pactera.bg3cs.tencent_live_flutter;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.tencent.liteav.beauty.TXBeautyManager;

// 美颜、美容、动效挂件类基础函数
class TXBeautyManagerChannel {

    private final MethodChannel methodChannel;

    private final TXBeautyManager txBeautyManager;

    // 该管理类调用原生方法都增加该前缀，用以区分
    static final String TX_BEAUTY_METHOD_PRE = "TXBeauty#";

    public TXBeautyManagerChannel(MethodChannel methodChannel, TXBeautyManager txBeautyManager){
        this.methodChannel = methodChannel;
        this.txBeautyManager = txBeautyManager;
    }

    public void onTXBeautyMethodCall(MethodCall methodCall, MethodChannel.Result result){
        Map<String, Object> request = (Map<String, Object>) methodCall.arguments;
        String methodName = methodCall.method.replace(TX_BEAUTY_METHOD_PRE, "");
        switch (methodName) {
            case "setBeautyStyle":
                setBeautyStyle(request, result);
                break;
            case "setFilter":
                setFilter(request, result);
                break;
            case "setFilterStrength":
                setFilterStrength(request, result);
                break;
            case "setBeautyLevel":
                setBeautyLevel(request, result);
                break;
            case "setWhitenessLevel":
                setWhitenessLevel(request, result);
                break;
            case "setRuddyLevel":
                setRuddyLevel(request, result);
                break;
            default:
                result.notImplemented();
        }
    }

    /// 设置美颜类型。
    /// [beautyStyle] 美颜风格，0表示光滑，1表示自然，2表示朦胧
    private void setBeautyStyle(Map<String, Object> request, MethodChannel.Result result) {
        txBeautyManager.setBeautyStyle((int)request.get("beautyStyle"));
        result.success(0);
    }

    /// 设置指定素材滤镜特效。
    /// [imageData] 滤镜图片一定要用 png 格式
    private void setFilter(Map<String, Object> request, MethodChannel.Result result){
        byte[] imageData = (byte[]) request.get("imageData");
        Bitmap bitmap = BitmapFactory.decodeByteArray(imageData , 0, imageData.length);
        txBeautyManager.setFilter(bitmap);
        result.success(0);
    }

    /// 设置滤镜浓度。
    /// [strength] 取值范围0 - 1的浮点型数字，取值越大滤镜效果越明显，默认取值0.5
    private void setFilterStrength(Map<String, Object> request, MethodChannel.Result result) {
        txBeautyManager.setFilterStrength(((Double)request.get("strength")).floatValue());
        result.success(0);
    }

    /// 设置美颜级别。
    /// [beautyLevel] 美颜级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
    private void setBeautyLevel(Map<String, Object> request, MethodChannel.Result result) {
        txBeautyManager.setBeautyLevel((int)request.get("beautyLevel"));
        result.success(0);
    }

    /// 设置美白级别。
    /// [whitenessLevel] 美白级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
    private void setWhitenessLevel(Map<String, Object> request, MethodChannel.Result result) {
        txBeautyManager.setWhitenessLevel((int)request.get("whitenessLevel"));
        result.success(0);
    }

    /// 设置红润级别。
    /// [ruddyLevel] 红润级别，取值范围0 - 9；0表示关闭，1 - 9值越大，效果越明显。
    private void setRuddyLevel(Map<String, Object> request, MethodChannel.Result result) {
        txBeautyManager.setRuddyLevel((int)request.get("ruddyLevel"));
        result.success(0);
    }

}