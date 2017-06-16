import {
    NativeModules
} from 'react-native';

var molpay = {
    startMolpay: function(paymentDetails, successCallback, errorCallback) {
        if (typeof paymentDetails === "string") {
            try {
                paymentDetails = JSON.parse(JSON.stringify(paymentDetails));
            } catch (e) {
                if (errorCallback) {
                    errorCallback("Payment Details content wrong value or format");
                    return;
                }
            }
        } else if (typeof paymentDetails === "object") {
            paymentDetails = JSON.stringify(paymentDetails);
        }

        NativeModules.MOLPay.setPaymentDetails(paymentDetails, function(paymentResult) {
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