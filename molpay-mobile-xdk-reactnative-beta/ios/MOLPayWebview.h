//  Copyright © 2016 MOLPay. All rights reserved.

#import <UIKit/UIKit.h>

@protocol MOLPayWebviewDelegate <NSObject>
@required
- (void)onStatusChanged: (NSDictionary *)data;
@end

@interface MOLPayWebview : UIWebView

@property (nonatomic, strong) id <MOLPayWebviewDelegate> molpayWebviewDelegate;

- (void)startUI;
- (void)closemolpay;
- (void)transactionRequest;
- (void)updateSdkData :(id)data;
- (void)nativeWebRequestUrlUpdates :(NSDictionary*)data;
- (void)nativeWebRequestUrlUpdatesOnFinishLoad :(NSDictionary*)data;
- (void)overidingJavascriptMethod;

@end
