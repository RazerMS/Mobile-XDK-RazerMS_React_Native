import {
    NativeModules
} from 'react-native';

var jsonparse = function(paymentDetails) {
    var payment = {
        mp_amount: "",
        mp_username: "",
        mp_password: "",
        mp_merchant_ID: "",
        mp_app_name: "",
        mp_verification_key: "",
        mp_order_ID: "",
        mp_currency: "",
        mp_country: "",
        mp_channel: "",
        mp_bill_description: "",
        mp_bill_name: "",
        mp_bill_email: "",
        mp_bill_mobile: "",
        mp_channel_editing: "",
        mp_editing_enabled: "",
        mp_transaction_id: "",
        mp_request_type: "",
        mp_bin_lock: "",
        mp_bin_lock_err_msg: "",
        mp_is_escrow: "",
        mp_filter: "",
        mp_custom_css_url: "",
        mp_preferred_token: "",
        mp_tcctype: "",
        mp_is_recurring: "",
        mp_allowed_channels: "",
        mp_sandbox_mode: "",
        mp_express_mode: "",
        mp_advanced_email_validation_enabled: "",
        mp_advanced_phone_validation_enabled: "",
        mp_bill_name_edit_disabled: "",
        mp_bill_email_edit_disabled: "",
        mp_bill_mobile_edit_disabled: "",
        mp_bill_description_edit_disabled: "",
        mp_language: "",
        mp_dev_mode: ""
    }

    for(var key in payment){
      if(paymentDetails[key]){
        payment[key] = paymentDetails[key]
      }else{
        payment[key] = "";
      }
    }
    payment = JSON.stringify(payment);
    return payment;
}

var molpay = {
    startMolpay: function(paymentDetails, successCallback, errorCallback) {
        var completePayment;
        if (typeof paymentDetails === "string") {
            try {
                paymentDetails = JSON.parse(paymentDetails);
                completePayment = jsonparse(paymentDetails);
            } catch (e) {
                if (errorCallback) {
                    errorCallback("Payment Details content wrong value or format");
                    return;
                }
            }
        } else if (typeof paymentDetails === "object") {
            completePayment = jsonparse(paymentDetails);
        }

        NativeModules.MOLPay.setPaymentDetails(completePayment, function(paymentResult) {
            if (successCallback) {
                successCallback(paymentResult);
            }
        }, function(error) {
            if (errorCallback) {
                errorCallback(error);
            }
        })
    }
}

module.exports = molpay;