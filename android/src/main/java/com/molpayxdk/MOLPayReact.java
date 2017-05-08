package com.molpayxdk;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.molpay.molpayxdk.MOLPayActivity;

import org.json.JSONObject;

import java.util.HashMap;

import javax.annotation.Nullable;

/**
 * Created by leow on 10/11/2016 AD.
 */
public class MOLPayReact extends ReactContextBaseJavaModule{
    public static HashMap<String, Object> paymentDetails = new HashMap<>();
    public static Callback successCallback;
    public static Callback errorCallback;

    @Override
    public String getName() {
        return "MOLPay";
    }


    public MOLPayReact(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void setPaymentDetails(String str,@Nullable Callback successCallback, @Nullable Callback errorCallback){
        if(successCallback != null){
            this.successCallback = successCallback;
        }
        if(errorCallback != null){
            this.errorCallback = errorCallback;
        }
        try{
            JSONObject obj = new JSONObject(str);
            paymentDetails.put(MOLPayActivity.mp_amount, obj.getString("mp_amount"));
            paymentDetails.put(MOLPayActivity.mp_username, obj.getString("mp_username"));
            paymentDetails.put(MOLPayActivity.mp_password, obj.getString("mp_password"));
            paymentDetails.put(MOLPayActivity.mp_merchant_ID, obj.getString("mp_merchant_ID"));
            paymentDetails.put(MOLPayActivity.mp_app_name, obj.getString("mp_app_name"));
            paymentDetails.put(MOLPayActivity.mp_verification_key, obj.getString("mp_verification_key"));

            paymentDetails.put(MOLPayActivity.mp_order_ID, obj.getString("mp_order_ID"));
            paymentDetails.put(MOLPayActivity.mp_currency, obj.getString("mp_currency"));
            paymentDetails.put(MOLPayActivity.mp_country, obj.getString("mp_country"));
            paymentDetails.put(MOLPayActivity.mp_channel, obj.getString("mp_channel"));
            paymentDetails.put(MOLPayActivity.mp_bill_description, obj.getString("mp_bill_description"));
            paymentDetails.put(MOLPayActivity.mp_bill_name, obj.getString("mp_bill_name"));
            paymentDetails.put(MOLPayActivity.mp_bill_email, obj.getString("mp_bill_email"));
            paymentDetails.put(MOLPayActivity.mp_bill_mobile, obj.getString("mp_bill_mobile"));
            paymentDetails.put(MOLPayActivity.mp_channel_editing, obj.getString("mp_channel_editing"));
            paymentDetails.put(MOLPayActivity.mp_editing_enabled, obj.getString("mp_editing_enabled"));
            paymentDetails.put(MOLPayActivity.mp_transaction_id, obj.getString("mp_transaction_id"));//8064815
            paymentDetails.put(MOLPayActivity.mp_request_type, obj.getString("mp_request_type"));
            paymentDetails.put(MOLPayActivity.mp_bin_lock, obj.getString("mp_bin_lock"));
            paymentDetails.put(MOLPayActivity.mp_bin_lock_err_msg, obj.getString("mp_bin_lock_err_msg"));
            paymentDetails.put(MOLPayActivity.mp_is_escrow, obj.getString("mp_is_escrow"));
            paymentDetails.put(MOLPayActivity.mp_filter, obj.getString("mp_filter"));
            paymentDetails.put(MOLPayActivity.mp_custom_css_url, obj.getString("mp_custom_css_url"));
            paymentDetails.put(MOLPayActivity.mp_preferred_token, obj.getString("mp_preferred_token"));
            paymentDetails.put(MOLPayActivity.mp_tcctype, obj.getString("mp_tcctype"));
            paymentDetails.put(MOLPayActivity.mp_is_recurring, obj.getString("mp_is_recurring"));
            paymentDetails.put(MOLPayActivity.mp_allowed_channels, obj.getString("mp_allowed_channels"));
            paymentDetails.put(MOLPayActivity.mp_sandbox_mode, obj.getString("mp_sandbox_mode"));
            paymentDetails.put(MOLPayActivity.mp_express_mode, obj.getString("mp_express_mode"));
            paymentDetails.put(MOLPayActivity.mp_advanced_email_validation_enabled, obj.getString("mp_advanced_email_validation_enabled"));
            paymentDetails.put(MOLPayActivity.mp_advanced_phone_validation_enabled, obj.getString("mp_advanced_phone_validation_enabled"));
            paymentDetails.put(MOLPayActivity.mp_bill_name_edit_disabled, obj.getString("mp_bill_name_edit_disabled"));
            paymentDetails.put(MOLPayActivity.mp_bill_email_edit_disabled, obj.getString("mp_bill_email_edit_disabled"));
            paymentDetails.put(MOLPayActivity.mp_bill_mobile_edit_disabled, obj.getString("mp_bill_mobile_edit_disabled"));
            paymentDetails.put(MOLPayActivity.mp_bill_description_edit_disabled, obj.getString("mp_bill_description_edit_disabled"));
            paymentDetails.put(MOLPayActivity.mp_language, obj.getString("mp_language"));
            paymentDetails.put(MOLPayActivity.mp_dev_mode, obj.getString("mp_dev_mode"));
            paymentDetails.put("is_submodule", true);
            paymentDetails.put("module_id", "molpay-mobile-xdk-reactnative-beta-android");
            paymentDetails.put("wrapper_version", "0");

            
        }catch(Exception e){
            if(this.errorCallback != null){
                this.errorCallback.invoke(e);
            }
        }
        MOLPayReactActivity m = new MOLPayReactActivity();
        m.PaymentUpdated(getCurrentActivity());
    }


}
