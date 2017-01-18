//
//  ViewController.h
//  MOLPayXDKlib
//
//  Created by Leow on 10/13/28 H.
//  Copyright © 28 Heisei Facebook. All rights reserved.
//

#ifndef ViewController_h
#define ViewController_h


#endif /* ViewController_h */


#import <UIKit/UIKit.h>

@interface MOLPayReactViewController : UIViewController
@property(nonatomic) NSDictionary *PaymentDetails;
@property (nonatomic, copy) void (^didDismiss)(NSDictionary *data);

@end

