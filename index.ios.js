// /**
//  * Sample React Native App
//  * https://github.com/facebook/react-native
//  * @flow
//  */

// import React, { Component } from 'react';
// import {
//   AppRegistry,
//   StyleSheet,
//   Text,
//   View,
//   NativeModules
// } from 'react-native';

// setTimeout(function(){
// NativeModules.MOLPayReactManager.paymentDetail("sd",function(value){
// alert(JSON.stringify(value));
// });
// },2000)

// class MOLPayXDK extends Component {
//   render() {
//     return (
//       <View style={styles.container}>
//         <Text style={styles.welcome}>
//           Welcome to React Native!
//         </Text>
//         <Text style={styles.instructions}>
//           To get started, edit index.ios.js
//         </Text>
//         <Text style={styles.instructions}>
//           Press Cmd+R to reload,{'\n'}
//           Cmd+D or shake for dev menu
//         </Text>
//       </View>
//     );
//   }
// }

// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     justifyContent: 'center',
//     alignItems: 'center'
//   },
//   welcome: {
//     fontSize: 20,
//     textAlign: 'center',
//     margin: 10,
//   },
//   instructions: {
//     textAlign: 'center',
//     color: '#333333',
//     marginBottom: 5,
//   },
// });

// AppRegistry.registerComponent('MOLPayXDK', () => MOLPayXDK);

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
        mp_express_mode: ""
    }

    for(var key in payment){
      if(paymentDetails[key]){
        payment[key] = paymentDetails[key]
      }else{
        payment[key] = "";
      }
    }
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

        NativeModules.MOLPayReactManager.setPaymentDetails(completePayment, function(paymentResult) {
            if (successCallback) {
                successCallback(paymentResult);
            }
        })
    }
}

module.exports = molpay;
