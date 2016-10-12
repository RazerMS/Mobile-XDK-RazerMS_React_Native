package com.molpayxdk;

import android.app.Activity;
import android.content.Intent;

import com.molpay.molpayxdk.MOLPayActivity;


public class MOLPayReactActivity{

    public final static int MOLPayReactXDK = MOLPayActivity.MOLPayXDK;
    public final static String MOLPayTransactionResult = MOLPayActivity.MOLPayTransactionResult;

    public void PaymentUpdated(Activity a) {
        Intent intent = new Intent(a, MOLPayActivity.class);
        intent.putExtra(MOLPayActivity.MOLPayPaymentDetails, MOLPayReact.paymentDetails);
        a.startActivityForResult(intent, MOLPayActivity.MOLPayXDK);
    }
}
