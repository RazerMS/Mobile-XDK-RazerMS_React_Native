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
    TouchableElement,
    TouchableHighlight,
    TouchableNativeFeedback,
    Platform
} from 'react-native';



// var paymentDetails = {"mp_bill_name":"lastname firstname","mp_merchant_ID":"bluesand","mp_amount":"8","mp_allowed_channels":"","mp_order_ID":"307","mp_verification_key":"09c73edeed3208878a95958627fb9f94","mp_bill_description":"\n                                Ordered: 1 A La Cart 11 (Sotong Small)\n                                Ship to: address 47560 state MY.\n                                Note: null","mp_bill_email_edit_disabled":"","mp_custom_css_url":"","mp_country":"MY","mp_bill_name_edit_disabled":"","mp_bill_description_edit_disabled":"","mp_sandbox_mode":"","mp_request_type":"","mp_password":"api_Blu3*1307","module_id":"molpay-mobile-xdk-reactnative-beta-android","mp_bill_mobile_edit_disabled":"","mp_channel_editing":"","mp_filter":"","mp_advanced_email_validation_enabled":"","mp_bill_mobile":"0122059520","mp_editing_enabled":"","mp_bin_lock":"","mp_is_recurring":"","mp_advanced_phone_validation_enabled":"","mp_bin_lock_err_msg":"","is_submodule":true,"mp_app_name":"LFCMALAYSIA","mp_express_mode":"","mp_channel":"","mp_is_escrow":"","mp_bill_email":"jee.icT@hotmail.com","mp_preferred_token":"","wrapper_version":"0.0","mp_tcctype":"","mp_transaction_id":"","mp_username":"api_bluesand","mp_currency":"MYR"};
export default class MOLPayReactExampleProject extends Component {
  state = {
    string : ""
  };

  buttonClicked(){
      var c = this;
var molpay = require("molpay-mobile-xdk-reactnative-beta");
      var paymentDetails = {
    // Mandatory String. A value more than '1.00'
    'mp_amount': 1.1,

    // Mandatory String. Values obtained from MOLPay
    'mp_username': '',
    'mp_password': '',
    'mp_merchant_ID': '',
    'mp_app_name': '',
    'mp_verification_key': '',

    // Mandatory String. Payment values
    'mp_order_ID': 'React0002',
    'mp_currency': 'MYR',
    'mp_country': 'MY',

    // Optional String.
    'mp_channel': '', // Use 'multi' for all available channels option. For individual channel seletion, please refer to "Channel Parameter" in "Channel Lists" in the MOLPay API Spec for Merchant pdf. 
    'mp_bill_description': 'test payment',
    'mp_bill_name': 'anyname',
    'mp_bill_email': 'example@email.com',
    'mp_bill_mobile': '0161111111',
    // 'mp_channel_editing': true, // Option to allow channel selection.
    'mp_editing_enabled': true, // Option to allow billing information editing.

    // // Optional for Escrow
    // 'mp_is_escrow': '', // Optional for Escrow, put "1" to enable escrow

    // // Optional for credit card BIN restrictions
    'mp_bin_lock': ['414170', '414171'], // Optional for credit card BIN restrictions
    'mp_bin_lock_err_msg': 'Only UOB allowed', // Optional for credit card BIN restrictions

    // // For transaction request use only, do not use this on payment process
    // 'mp_transaction_id': '', // Optional, provide a valid cash channel transaction id here will display a payment instruction screen.
    // 'mp_request_type': '', // Optional, set 'Status' when doing a transactionRequest

    // // Optional, use this to customize the UI theme for the payment info screen, the original XDK custom.css file is provided at Example project source for reference and implementation.
    // 'mp_custom_css_url': '',

    // // Optional, set the token id to nominate a preferred token as the default selection, set "new" to allow new card only
    // 'mp_preferred_token': '',

    // // Optional, credit card transaction type, set "AUTH" to authorize the transaction
    // 'mp_tcctype': '',

    // // Optional, set true to process this transaction through the recurring api, please refer the MOLPay Recurring API pdf  
    // // 'mp_is_recurring': false,

    // // Optional for channels restriction 
    'mp_allowed_channels': ['credit','credit3'],

    // // Optional for sandboxed development environment, set boolean value to enable.
    // 'mp_sandbox_mode': false,

    // // Optional, required a valid mp_channel value, this will skip the payment info page and go direct to the payment screen.
    // 'mp_express_mode': false,
    // "mp_bill_description_edit_disabled": false,
    // 'mp_timeout' : 300,

};
      // start molpay payment
      molpay.startMolpay(paymentDetails,function(data){
        console.log(data);
          //callback after payment success
          c.setState({
            string : data
          })
          

      // molpay.startMolpay(paymentDetails,function(data){
      //   console.log(data);
      //     //callback after payment success
      //     c.setState({
      //       string : data
      //     })
      // });
      },function(ee){
        alert(ee);
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
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu{'\n'}
       {this.state.string}
        </Text>
        <View style={{flexDirection: 'row', height: 100, padding: 20}}>
        <TouchableElement
        style={{backgroundColor: 'grey', flex: 0.5}}
        onPress={this.buttonClicked.bind(this)}>
        <View style={{backgroundColor: 'grey', flex: 0.5,justifyContent: 'center'}}>
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
