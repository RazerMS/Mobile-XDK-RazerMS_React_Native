package com.molpayreactexampleproject;

import com.facebook.react.ReactActivity;

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
