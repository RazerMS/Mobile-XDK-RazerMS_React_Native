/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Platform,
  TouchableHighlight,
  TouchableNativeFeedback 

} from 'react-native';

var paymentDetails = {
    // Mandatory String. A value more than '1.00'
    'mp_amount': '1.1',

    // Mandatory String. Values obtained from MOLPay
    'mp_username': '',
    'mp_password': '',
    'mp_merchant_ID': '',
    'mp_app_name': '',
    'mp_verification_key': '',

    // Mandatory String. Payment values
    'mp_order_ID': '',
    'mp_currency': 'MYR',
    'mp_country': 'MY',

    // Optional String.
    'mp_channel': '', // Use 'multi' for all available channels option. For individual channel seletion, please refer to "Channel Parameter" in "Channel Lists" in the MOLPay API Spec for Merchant pdf. 
    'mp_bill_description': 'test payment',
    'mp_bill_name': 'anyname',
    'mp_bill_email': 'example@email.com',
    'mp_bill_mobile': '0161111111',
    'mp_channel_editing': false, // Option to allow channel selection.
    'mp_editing_enabled': false, // Option to allow billing information editing.

    // Optional for Escrow
    'mp_is_escrow': '', // Optional for Escrow, put "1" to enable escrow

    // Optional for credit card BIN restrictions
    'mp_bin_lock': ['414170', '414171'], // Optional for credit card BIN restrictions
    'mp_bin_lock_err_msg': 'Only UOB allowed', // Optional for credit card BIN restrictions

    // For transaction request use only, do not use this on payment process
    'mp_transaction_id': '', // Optional, provide a valid cash channel transaction id here will display a payment instruction screen.
    'mp_request_type': '', // Optional, set 'Status' when doing a transactionRequest

    // Optional, use this to customize the UI theme for the payment info screen, the original XDK custom.css file is provided at Example project source for reference and implementation. Required cordova-plugin-file to be installed
    'mp_custom_css_url': '',

    // Optional, set the token id to nominate a preferred token as the default selection, set "new" to allow new card only
    'mp_preferred_token': '',

    // Optional, credit card transaction type, set "AUTH" to authorize the transaction
    'mp_tcctype': '',

    // Optional, set true to process this transaction through the recurring api, please refer the MOLPay Recurring API pdf  
    'mp_is_recurring': false,

    // Optional for channels restriction 
    'mp_allowed_channels': ['credit', 'credit3'],

    // Optional for sandboxed development environment, set boolean value to enable.
    'mp_sandbox_mode': false,

    // Optional, required a valid mp_channel value, this will skip the payment info page and go direct to the payment screen.
    'mp_express_mode': false
};

var molpay = require("MOLPayXDK");



export default class MOLPayReactExampleProject extends Component {

buttonClicked(){
  var c = this;
  // start molpay payment
  molpay.startMolpay(paymentDetails,function(data){
      //callback after payment success
      alert(data);
      console.log(data);
  });
}
  render() {
    var TouchableElement = TouchableHighlight;
    if (Platform.OS === 'android') {
     TouchableElement = TouchableNativeFeedback;
    }
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.android.js
        </Text>
        <Text style={styles.instructions}>
          Double tap R on your keyboard to reload,{'\n'}
          Shake or press menu button for dev menu
        </Text>
        <View style={{flexDirection: 'row', height: 100, padding: 20}}>
        <TouchableElement
        style={{backgroundColor: 'grey', flex: 0.5}}
        onPress={this.buttonClicked.bind(this)}>
        <View style={{backgroundColor: 'grey', flex: 0.5}}>
          <Text style={{fontSize:30,color:'white',textAlign:'center'}}>Start Molpay!</Text>
        </View>
      </TouchableElement> 
        </View>
      </View>
      
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('MOLPayReactExampleProject', () => MOLPayReactExampleProject);
