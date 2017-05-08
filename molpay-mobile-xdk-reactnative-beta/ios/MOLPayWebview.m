//  Copyright © 2016 MOLPay. All rights reserved.

#define DLog(...)
//#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#import "MOLPayWebview.h"

@implementation MOLPayWebview

- (id)init
{
    self = [super init];
    
    if (self) {
        self.scrollView.bounces = NO;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.scrollView.bounces = NO;
    }
    
    return self;
}

- (void)startUI
{
    
}

- (void)closemolpay {
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"closemolpay()"]];
}

- (void)transactionRequest
{
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"transactionRequest()"]];
}

- (void)updateSdkData :(id)data
{
    // Convert data to json start
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        DLog(@">>>>>>>>> updateSdkData error = %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DLog(@">>>>>>>>> jsonString = %@", jsonString);
        [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"updateSdkData(%@)", jsonString]];
    }
}

- (void)nativeWebRequestUrlUpdates :(NSDictionary*)data
{
    // Convert data to json start
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        DLog(@">>>>>>>>> nativeWebRequestUrlUpdates jsonData error = %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DLog(@">>>>>>>>>nativeWebRequestUrlUpdates jsonString = %@", jsonString);
        [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"nativeWebRequestUrlUpdates(%@)", jsonString]];
    }
    
}

- (void)nativeWebRequestUrlUpdatesOnFinishLoad :(NSDictionary*)data
{
    // Convert data to json start
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        DLog(@">>>>>>>>> nativeWebRequestUrlUpdatesOnFinishLoad jsonData error = %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DLog(@">>>>>>>>>nativeWebRequestUrlUpdatesOnFinishLoad jsonString = %@", jsonString);
        [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"nativeWebRequestUrlUpdatesOnFinishLoad(%@)", jsonString]];
    }
    
}

// Overwrite javascript function
- (void)overidingJavascriptMethod
{
    NSString *overwriteScript = @"window.open = function (open) { return function (url, name, features) { window.location = url; return window; }; } (window.open);";
    
    [self stringByEvaluatingJavaScriptFromString:overwriteScript];
    
    overwriteScript = @"window.close = function () { window.location.assign(window.location); };";
    
    [self stringByEvaluatingJavaScriptFromString:overwriteScript];
}


@end
