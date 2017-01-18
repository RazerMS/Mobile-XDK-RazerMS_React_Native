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


#import <MOLPayXDK/MOLPayLib.h>

#import <React/RCTView.h>
#import <React/RCTRootView.h>
#include "MOLPayReactViewController.h"

@interface MOLPayReactManager ()

@end

// CalendarManager.m
@implementation MOLPayReactManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(setPaymentDetails:(NSDictionary *)paymentDetails callback:(RCTResponseSenderBlock)callback)
{
    MOLPayReactViewController *mpvc = [[MOLPayReactViewController alloc] init];
  
    [mpvc.view setBackgroundColor:[UIColor whiteColor]];
  mpvc.PaymentDetails = paymentDetails;
  UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mpvc];
  mpvc.didDismiss = ^(NSDictionary *data) {
    callback(@[data]);
  };
  
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:nil];
}


@end
