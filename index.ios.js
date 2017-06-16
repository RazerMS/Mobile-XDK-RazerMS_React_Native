import {
    NativeModules
} from 'react-native';

var molpay = {
    startMolpay: function(paymentDetails, successCallback, errorCallback) {
        if (typeof paymentDetails === "string") {
            try {
                paymentDetails = JSON.parse(paymentDetails);
            } catch (e) {
                if (errorCallback) {
                    errorCallback("Payment Details content wrong value or format");
                    return;
                }
            }
        }

        NativeModules.MOLPayReactManager.setPaymentDetails(paymentDetails, function(paymentResult) {
            if (successCallback) {
                successCallback(JSON.stringify(paymentResult));
            }
        })
    }
}

module.exports = molpay;