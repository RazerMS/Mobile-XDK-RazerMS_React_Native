package com.molpayxdk;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.molpay.molpayxdk.MOLPayActivity;
import android.content.Intent;

import android.app.Activity;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;

import javax.annotation.Nullable;

public class MOLPayReact extends ReactContextBaseJavaModule {
    public static HashMap<String, Object> paymentDetails;
    public static Callback successCallback;
    public static Callback errorCallback;

      private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
    @Override
    public void onActivityResult(final Activity activity,int requestCode, int resultCode, Intent data) {
        if (requestCode == MOLPayActivity.MOLPayXDK && resultCode == Activity.RESULT_OK){
            if(successCallback != null){
                successCallback.invoke(data.getStringExtra(MOLPayActivity.MOLPayTransactionResult));
            }
        }
    }
  };

    @Override
    public String getName() {
        return "MOLPay";
    }


    public MOLPayReact(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(mActivityEventListener);
    }

    @ReactMethod
    public void setPaymentDetails(String str,@Nullable Callback successCallback, @Nullable Callback errorCallback){
        paymentDetails = new HashMap<>();
        if(successCallback != null){
            this.successCallback = successCallback;
        }
        if(errorCallback != null){
            this.errorCallback = errorCallback;
        }
        try{
            JSONObject obj = new JSONObject(str);
            Iterator<String> iter = obj.keys();
            while (iter.hasNext()) {
                String key = iter.next();
                if(obj.getString(key).equals("true") || obj.getString(key).equals("false")){
                    paymentDetails.put(key, obj.getBoolean(key));
                }else{
                    paymentDetails.put(key, obj.getString(key));
                }
            }
            paymentDetails.put("is_submodule", true);
            paymentDetails.put("module_id", "molpay-mobile-xdk-reactnative-beta-android");
            paymentDetails.put("wrapper_version", "0");
        }catch(Exception e){
            if(this.errorCallback != null){
                this.errorCallback.invoke(e);
            }
        }
         Intent intent = new Intent(getCurrentActivity(), MOLPayActivity.class);
        intent.putExtra(MOLPayActivity.MOLPayPaymentDetails, this.paymentDetails);
        getCurrentActivity().startActivityForResult(intent, MOLPayActivity.MOLPayXDK);
    }


}
