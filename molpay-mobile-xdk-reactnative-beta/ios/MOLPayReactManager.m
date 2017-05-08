//
//  MOLPayReactManager.m
//  MOLPayXDK
//
//  Created by Leow on 10/12/28 H.
//  Copyright © 28 Heisei Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOLPayReactManager.h"
#import <React/RCTBridgeModule.h>


#import "MOLPayLib.h"

#import <React/RCTView.h>
#import <React/RCTRootView.h>
#include "MOLPayReactViewController.h"

@interface MOLPayReactManager ()

@end

// MOLPayReactManager.m
@implementation MOLPayReactManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(setPaymentDetails:(NSDictionary *)paymentDetails callback:(RCTResponseSenderBlock)callback)
{
    MOLPayReactViewController *mpvc = [[MOLPayReactViewController alloc] init];
    NSMutableDictionary *paymentDetailsMutable = [paymentDetails mutableCopy];
  
    [mpvc.view setBackgroundColor:[UIColor whiteColor]];
    [paymentDetailsMutable setObject:@"YES" forKey:@"is_submodule"];
    [paymentDetailsMutable setObject:@"molpay-mobile-xdk-reactnative-beta-ios" forKey:@"module_id"];
    [paymentDetailsMutable setObject:@"0" forKey:@"wrapper_version"];
    mpvc.PaymentDetails = paymentDetailsMutable;
  	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mpvc];
  	mpvc.didDismiss = ^(NSDictionary *data) {
    callback(@[data]);
  };
  
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:nil];
}


@end
