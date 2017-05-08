<!--
 # license: Copyright © 2011-2016 MOLPay Sdn Bhd. All Rights Reserved. 
 -->

# molpay-mobile-xdk-reactnative-beta

This is the beta but functional MOLPay React Native payment module that is ready to be implemented into any React Native project npm install module. An example application project 
(MOLPayReactExampleProject) is provided for MOLPayXDK framework integration reference.

## Recommended configurations

- Node.js Version: 5.3.0 ++

- Minimum Android SDK Version: 23 ++

- Minimum Android API level: 16 ++

- Minimum Android target version: Android 4.1

- Minimum React Navtive version : 0.40.0 ++

- Xcode version: 7 ++

- Minimum target version: iOS 7

## MOLPay Android Caveats

Credit card payment channel is not available in Android 4.1, 4.2, and 4.3. due to lack of latest security (TLS 1.2) support on these Android platforms natively.

## Installation

### Android

1) npm install molpay-mobile-xdk-reactnative-beta

2) add the following import to `MainApplication.java` (`MainActivity.java` if RN < 0.33) of your application

```java
//add these three
import com.molpayxdk.MOLPayReact;
import com.molpayxdk.MOLPayReactActivity;
import android.content.Intent;

public class MainActivity extends ReactActivity {
    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "MOLPayReactExampleProject";
    }

    //add activity result in here
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        if (requestCode == MOLPayReactActivity.MOLPayReactXDK && resultCode == RESULT_OK){
            if(MOLPayReact.successCallback != null){
                MOLPayReact.successCallback.invoke(data.getStringExtra(MOLPayReactActivity.MOLPayTransactionResult));
            }
        }
    }
    
}
```

3) add the following code to add the package to `MainApplication.java`` (`MainActivity.java` if RN < 0.33)

```java
import com.molpayxdk.MOLPayReactPackage;

protected List<ReactPackage> getPackages() {
        return Arrays.<ReactPackage>asList(
            new MainReactPackage(),
            new MOLPayReactPackage() //<- this
        );
    }
```

4) add the following codes to your `android/setting.gradle`

> you might have multiple 3rd party libraries, make sure that you don't create multiple include.

```
include ':app', ':molpay-mobile-xdk-reactnative-beta'
project(':molpay-mobile-xdk-reactnative-beta').projectDir = new File(rootProject.projectDir, '../node_modules/molpay-mobile-xdk-reactnative-beta/android')
```

5) edit `android/app/build.gradle` and add the following line inside `dependencies`

```
compile project(':molpay-mobile-xdk-reactnative-beta')
```

6) run `react-native run-android` to see if everything is compilable.

if have any issue when run-android please make sure your `android/local.properties` already set sdk path

```
ndk.dir=path/Android/sdk/ndk-bundle
sdk.dir=path/Android/sdk
```

7) (Optional) header include Close button in payment UI
change the following codes in your `android/app/src/main/res/values/styles.xml`
```
<resources>

    <!-- Base application theme. -->
    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
        <!-- Customize your theme here. -->
        <!-- use any perfer color-->
        <item name="colorPrimary">#3F51B5</item>
    </style>

</resources>
```

### IOS

1) npm install molpay-mobile-xdk-reactnative-beta

2) navigate to `node_modules/molpay-mobile-xdk-reactnative-beta/ios` and copy MOLPayXDK.bundle into the application project folder `{ReactProject}/ios/` and open Xcode to perform all imports.

<p align="center">
    <img src ="https://raw.githubusercontent.com/MOLPay/molpay-mobile-xdk-reactnative-beta/master/assets/03.png" />
</p>
3) In Xcode right click on  `Libraries` select `Add Files to ...` option and  navigate to `node_modules/molpay-mobile-xdk-reactnative-beta/ios` and add `MOLPayXDKlib.xcodeproj`


4) In Xcode click on project and find `Build Phases` then expand `Link Binary With Libraries` and click `+` sign to add a new library. select `libMOLPayXDKlib.a` and click `Add` button.

5) final result will be like below (please make sure the MOLPayXDK.bundle also included)

<p align="center">
    <img src ="https://raw.githubusercontent.com/MOLPay/molpay-mobile-xdk-reactnative-beta/master/assets/04.png" />
</p>

6) Add 'App Transport Security Settings > Allow Arbitrary Loads > YES' to the application project info.plist

7) Add 'NSPhotoLibraryUsageDescription' > 'Payment images' to the application project info.plist

## Sample Result

```
=========================================
Sample transaction result in JSON string:
=========================================

{"status_code":"11","amount":"1.01","chksum":"34a9ec11a5b79f31a15176ffbcac76cd","pInstruction":0,"msgType":"C6","paydate":1459240430,"order_id":"3q3rux7dj","err_desc":"","channel":"Credit","app_code":"439187","txn_ID":"6936766"}

Parameter and meaning:

"status_code" - "00" for Success, "11" for Failed, "22" for *Pending. 
(*Pending status only applicable to cash channels only)
"amount" - The transaction amount
"paydate" - The transaction date
"order_id" - The transaction order id
"channel" - The transaction channel description
"txn_ID" - The transaction id generated by MOLPay

* Notes: You may ignore other parameters and values not stated above

=====================================
* Sample error result in JSON string:
=====================================

{"Error":"Communication Error"}

Parameter and meaning:

"Communication Error" - Error starting a payment process due to several possible reasons, please contact MOLPay support should the error persists.
1) Internet not available
2) API credentials (username, password, merchant id, verify key)
3) MOLPay server offline.
```

## Prepare the Payment detail object

```
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
    'mp_express_mode': false,

    // Optional, enable this for extended email format validation based on W3C standards.
    'mp_advanced_email_validation_enabled': true,
    
    // Optional, enable this for extended phone format validation based on Google i18n standards.
    'mp_advanced_phone_validation_enabled' : true,

    // Optional, explicitly force disable billing name edit.
    'mp_bill_name_edit_disabled': false,

    // Optional, explicitly force disable billing email edit.
    'mp_bill_email_edit_disabled': false,

    // Optional, explicitly force disable billing mobile edit.
    'mp_bill_mobile_edit_disabled': false,

    // Optional, explicitly force disable billing description edit.
    'mp_bill_description_edit_disabled': false,

    // Optional, EN, MS, VI, TH, FIL, MY, KM, ID, ZH.
    'mp_mp_language': "EN",

    // Optional, enable for online sandbox testing.
    'mp_dev_mode': false
};
```

## Start the payment module

```
//import molpay package
var molpay = require("molpay-mobile-xdk-reactnative-beta");

//start molpay payment
molpay.startMolpay(paymentDetails, function(data){
    //callback after payment success
    console.log(data);
});
```

## Cash channel payment process (How does it work?)

    This is how the cash channels work on XDK:
    
    1) The user initiate a cash payment, upon completed, the XDK will pause at the “Payment instruction” screen, the results would return a pending status.
    
    2) The user can then click on “Close” to exit the MOLPay XDK aka the payment screen.
    
    3) When later in time, the user would arrive at say 7-Eleven to make the payment, the host app then can call the XDK again to display the “Payment Instruction” again, then it has to pass in all the payment details like it will for the standard payment process, only this time, the host app will have to also pass in an extra value in the payment details, it’s the “mp_transaction_id”, the value has to be the same transaction returned in the results from the XDK earlier during the completion of the transaction. If the transaction id provided is accurate, the XDK will instead show the “Payment Instruction" in place of the standard payment screen.
    
    4) After the user done the paying at the 7-Eleven counter, they can close and exit MOLPay XDK by clicking the “Close” button again.

## XDK built-in checksum validator caveats 

    All XDK come with a built-in checksum validator to validate all incoming checksums and return the validation result through the "mp_secured_verified" parameter. However, this mechanism will fail and always return false if merchants are implementing the private secret key (which the latter is highly recommended and prefereable.) If you would choose to implement the private secret key, you may ignore the "mp_secured_verified" and send the checksum back to your server for validation. 

## Private Secret Key checksum validation formula

    chksum = MD5(mp_merchant_ID + results.msgType + results.txn_ID + results.amount + results.status_code + merchant_private_secret_key)

## Support

Submit issue to this repository or email to our support@molpay.com

Merchant Technical Support / Customer Care : support@molpay.com<br>
Sales/Reseller Enquiry : sales@molpay.com<br>
Marketing Campaign : marketing@molpay.com<br>
Channel/Partner Enquiry : channel@molpay.com<br>
Media Contact : media@molpay.com<br>
R&D and Tech-related Suggestion : technical@molpay.com<br>
Abuse Reporting : abuse@molpay.com
