//
//  MOLPayReactManager.m
//  MOLPayXDK
//
//  Created by Leow on 10/12/28 H.
//  Copyright © 28 Heisei Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOLPayReactManager.h"
#import "RCTBridgeModule.h"

#import <MOLPayXDK/MOLPayLib.h>

#import "RCTView.h"
#import "RCTRootView.h"

@interface MOLPayReactManager () <MOLPayLibDelegate>

@end

// CalendarManager.m
@implementation MOLPayReactManager

RCT_EXPORT_MODULE();

- (UIView *)view
{
  NSDictionary * paymentRequestDict = @{
                                        // Mandatory String. A value more than '1.00'
                                        @"mp_amount": @"1.10",
                                        
                                        // Mandatory String. Values obtained from MOLPay
                                        @"mp_username": @"molpayapi",
                                        @"mp_password": @"*M0Lp4y4p1!*",
                                        @"mp_merchant_ID": @"molpaymerchant",
                                        @"mp_app_name": @"wilwe_makan2",
                                        @"mp_verification_key": @"501c4f508cf1c3f486f4f5c820591f41",
                                        
                                        // Mandatory String. Payment values
                                        @"mp_order_ID": @"orderid123",
                                        @"mp_currency": @"MYR",
                                        @"mp_country": @"MY",
                                        
                                        // Optional String.
                                        @"mp_channel": @"", // Use 'multi' for all available channels option. For individual channel seletion, please refer to "Channel Parameter" in "Channel Lists" in the MOLPay API Spec for Merchant pdf.
                                        @"mp_bill_description": @"billdesc",
                                        @"mp_bill_name": @"billname",
                                        @"mp_bill_email": @"email@domain.com",
                                        @"mp_bill_mobile": @"+1234567",
                                        @"mp_channel_editing": [NSNumber numberWithBool:NO], // Option to allow channel selection.
                                        @"mp_editing_enabled": [NSNumber numberWithBool:NO], // Option to allow billing information editing.
                                        
                                        // Optional for Escrow
                                        @"mp_is_escrow": @"0", // Put "1" to enable escrow
                                        
                                        // Optional for credit card BIN restrictions
                                        @"mp_bin_lock": @"",
                                        @"mp_bin_lock_err_msg": @"Only UOB allowed",
                                        
                                        // For transaction request use only, do not use this on payment process
                                        @"mp_transaction_id": @"", // Optional, provide a valid cash channel transaction id here will display a payment instruction screen.
                                        @"mp_request_type": @"",
                                        
                                        // Optional, use this to customize the UI theme for the payment info screen, the original XDK custom.css file is provided at Example project source for reference and implementation.
                                        @"mp_custom_css_url": @"",
                                        
                                        // Optional, set the token id to nominate a preferred token as the default selection, set "new" to allow new card only
                                        @"mp_preferred_token": @"",
                                        
                                        // Optional, credit card transaction type, set "AUTH" to authorize the transaction
                                        @"mp_tcctype": @"",
                                        
                                        // Optional, set true to process this transaction through the recurring api, please refer the MOLPay Recurring API pdf
                                        @"mp_is_recurring": [NSNumber numberWithBool:NO],
                                        
                                        // Optional for channels restriction
                                        @"mp_allowed_channels": @"",
                                        
                                        // Optional for sandboxed development environment, set boolean value to enable.
                                        @"mp_sandbox_mode": @"",
                                        
                                        // Optional, required a valid mp_channel value, this will skip the payment info page and go direct to the payment screen.
                                        @"mp_express_mode": @""
                                        };
  MOLPayLib * mp = [[MOLPayLib alloc] initWithDelegate:self andPaymentDetails:paymentRequestDict];
  
//  [self presentViewController:mp animated:NO completion:nil];
//  return [[MKMapView alloc] init];
  mp.delegate = self;
  
  return mp;
  
}

RCTResponseSenderBlock callbackouter;

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location callback:(RCTResponseSenderBlock)callback)
{
  callbackouter = callback;
  NSDictionary * paymentRequestDict = @{
                                        // Mandatory String. A value more than '1.00'
                                        @"mp_amount": @"1.10",
                                        
                                        // Mandatory String. Values obtained from MOLPay
                                        @"mp_username": @"molpayapi",
                                        @"mp_password": @"*M0Lp4y4p1!*",
                                        @"mp_merchant_ID": @"molpaymerchant",
                                        @"mp_app_name": @"wilwe_makan2",
                                        @"mp_verification_key": @"501c4f508cf1c3f486f4f5c820591f41",
                                        
                                        // Mandatory String. Payment values
                                        @"mp_order_ID": @"orderid123",
                                        @"mp_currency": @"MYR",
                                        @"mp_country": @"MY",
                                        
                                        // Optional String.
                                        @"mp_channel": @"", // Use 'multi' for all available channels option. For individual channel seletion, please refer to "Channel Parameter" in "Channel Lists" in the MOLPay API Spec for Merchant pdf.
                                        @"mp_bill_description": @"billdesc",
                                        @"mp_bill_name": @"billname",
                                        @"mp_bill_email": @"email@domain.com",
                                        @"mp_bill_mobile": @"+1234567",
                                        @"mp_channel_editing": [NSNumber numberWithBool:NO], // Option to allow channel selection.
                                        @"mp_editing_enabled": [NSNumber numberWithBool:NO], // Option to allow billing information editing.
                                        
                                        // Optional for Escrow
                                        @"mp_is_escrow": @"0", // Put "1" to enable escrow
                                        
                                        // Optional for credit card BIN restrictions
                                        @"mp_bin_lock": @"",
                                        @"mp_bin_lock_err_msg": @"Only UOB allowed",
                                        
                                        // For transaction request use only, do not use this on payment process
                                        @"mp_transaction_id": @"", // Optional, provide a valid cash channel transaction id here will display a payment instruction screen.
                                        @"mp_request_type": @"",
                                        
                                        // Optional, use this to customize the UI theme for the payment info screen, the original XDK custom.css file is provided at Example project source for reference and implementation.
                                        @"mp_custom_css_url": @"",
                                        
                                        // Optional, set the token id to nominate a preferred token as the default selection, set "new" to allow new card only
                                        @"mp_preferred_token": @"",
                                        
                                        // Optional, credit card transaction type, set "AUTH" to authorize the transaction
                                        @"mp_tcctype": @"",
                                        
                                        // Optional, set true to process this transaction through the recurring api, please refer the MOLPay Recurring API pdf
                                        @"mp_is_recurring": [NSNumber numberWithBool:NO],
                                        
                                        // Optional for channels restriction
                                        @"mp_allowed_channels": @"",
                                        
                                        // Optional for sandboxed development environment, set boolean value to enable.
                                        @"mp_sandbox_mode": @"",
                                        
                                        // Optional, required a valid mp_channel value, this will skip the payment info page and go direct to the payment screen.
                                        @"mp_express_mode": @""
                                        };
  
//  UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
//  self.view = view;
//  self
//  self.view.backgroundColor = [UIColor greyColor];
//  CGRect  viewRect = CGRectMake(0, 0, 100, 100);
//  ((UINavigationController*)AppDelegate.window.rootViewController).visibleViewController;
//self.
  RCTRootView *rootView;
//  rootView.window.rootViewController =
  
  MOLPayLib * mp = [[MOLPayLib alloc] initWithDelegate:rootView.window.rootViewController andPaymentDetails:paymentRequestDict];
  //[view:paymentRequestDict];
  callback(@[paymentRequestDict]);
  [rootView.window.rootViewController presentViewController:mp animated:NO completion:nil];
  NSLog(@"Pretending to create an event %@ at %@", name, location);
//  callback(@[@"send callback %@"]);
}

-(void)transactionResult:(NSDictionary *)result{
  NSLog(@"transactionResult result = %@", result);
  callbackouter(@[result]);
}

@end
