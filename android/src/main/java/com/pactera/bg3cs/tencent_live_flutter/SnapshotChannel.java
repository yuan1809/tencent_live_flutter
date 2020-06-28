package com.pactera.bg3cs.tencent_live_flutter;

import android.annotation.TargetApi;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Build;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryCodec;
import io.flutter.plugin.common.BinaryMessenger;

public class SnapshotChannel {

    private BasicMessageChannel snapShotChannel;

    public SnapshotChannel(BinaryMessenger messenger, String channelName, final Request request){

        snapShotChannel = new BasicMessageChannel<ByteBuffer>(messenger, channelName, BinaryCodec.INSTANCE);
        snapShotChannel.setMessageHandler(new BasicMessageChannel.MessageHandler<ByteBuffer>() {
            @Override
            public void onMessage(ByteBuffer byteBuffer, BasicMessageChannel.Reply<ByteBuffer> reply) {
                if(request != null){
                    request.snapshotRequest();
                }
                reply.reply(null);
            }
        });

    }

    public void dispose(){
        snapShotChannel.setMessageHandler(null);
    }

    // 发送截图数据到flutter端
    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    public void sendSnapShot(final Bitmap bmp){
        new AsyncTask(){
            @Override
            protected Object doInBackground(Object[] objects) {
                ByteBuffer buffer = null;
                try {
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    bmp.compress(Bitmap.CompressFormat.PNG, 100, baos);
                    byte[] bytes = baos.toByteArray();
                    buffer = ByteBuffer.allocateDirect(bytes.length).put(bytes);
                    baos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return buffer;
            }

            @Override
            protected void onPostExecute(Object buffer) {
                snapShotChannel.send(buffer);
            }

        }.execute();
    }

    // 截图请求
    interface Request{

        void snapshotRequest();

    }

}
