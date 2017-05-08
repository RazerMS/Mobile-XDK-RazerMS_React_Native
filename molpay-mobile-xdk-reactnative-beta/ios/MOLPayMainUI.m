//  Copyright © 2016 MOLPay. All rights reserved.

#define DLog(...)
//#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#import "MOLPayMainUI.h"

@implementation MOLPayMainUI

static MOLPayMainUI *instance = nil;

+ (MOLPayMainUI*)getInstance
{
    if (instance == nil) {
        instance = [[MOLPayMainUI alloc] init];
    }
    return instance;
}

- (void)startUI
{
    // Setup bundled web UI resources
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MOLPayXDK" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *htmlPath = [bundle pathForResource:@"index" ofType:@"html" inDirectory:@"/molpay-mobile-xdk-www"];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    // Load web resources into webview
    [self loadHTMLString:html baseURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/molpay-mobile-xdk-www/", bundlePath]]];
}

@end
