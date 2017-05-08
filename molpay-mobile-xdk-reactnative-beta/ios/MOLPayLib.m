//  Copyright © 2016 MOLPay. All rights reserved.

#define DLog(...)
//#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#import "MOLPayLib.h"
#import "MOLPayMainUI.h"

@interface MOLPayLib () <UIWebViewDelegate> {
    BOOL isMainUILoaded;
    BOOL isTransactionRequestInQueue;
}

@end

// deploy
const NSString *wrapperVersion = @"0";

@implementation MOLPayLib

// Public API
- (id)initWithDelegate:(id<MOLPayLibDelegate>)delegate andPaymentDetails:(NSDictionary *)paymentDetails
{
    self = [super init];
    
    if (self && paymentDetails) {
        isMainUILoaded = NO;
        isTransactionRequestInQueue = NO;
        NSMutableDictionary *initialPaymentDetails = [paymentDetails mutableCopy];
        
        // For submodule wrappers
        BOOL is_submodule = [initialPaymentDetails objectForKey:@"is_submodule"];
        NSString *submodule_module_id = [initialPaymentDetails objectForKey:@"module_id"];
        NSString *submodule_wrapper_version = [initialPaymentDetails objectForKey:@"wrapper_version"];
        if (is_submodule && submodule_module_id && submodule_wrapper_version) {
            [initialPaymentDetails setObject:submodule_module_id forKey:@"module_id"];
            [initialPaymentDetails setObject:[NSString stringWithFormat:@"%@.%@", wrapperVersion, submodule_wrapper_version] forKey:@"wrapper_version"];
        } else {
            [initialPaymentDetails setObject:@"molpay-mobile-xdk-ios" forKey:@"module_id"];
            [initialPaymentDetails setObject:wrapperVersion forKey:@"wrapper_version"];
        }
        
        self.molpayPaymentDetail = [initialPaymentDetails copy];
        
        // Init and add webview component with the parent frame
        [self.view addSubview:[MOLPayMainUI getInstance]];
        [[MOLPayMainUI getInstance] setFrame:self.view.frame];
        [[MOLPayMainUI getInstance] setDelegate:self];
        [[MOLPayMainUI getInstance] startUI];
    }
    
    if (self && delegate) {
        self.delegate = delegate;
    }
    
    return self;
}

- (id)initWithDelegate:(id<MOLPayLibDelegate>)delegate andPaymentDetails:(NSDictionary *)paymentDetails andFrame:(CGRect)frame
{
    self = [super init];
    [self.view setFrame:frame];
    
    if (self && paymentDetails) {
        isMainUILoaded = NO;
        isTransactionRequestInQueue = NO;
        NSMutableDictionary *initialPaymentDetails = [paymentDetails mutableCopy];
        [initialPaymentDetails setObject:@"molpay-mobile-xdk-ios" forKey:@"module_id"];
        [initialPaymentDetails setObject:wrapperVersion forKey:@"wrapper_version"];
        self.molpayPaymentDetail = [initialPaymentDetails copy];
        
        // Init and add webview component with the parent frame
        [self.view addSubview:[MOLPayMainUI getInstance]];
        [[MOLPayMainUI getInstance] setFrame:self.view.frame];
        [[MOLPayMainUI getInstance] setDelegate:self];
        [[MOLPayMainUI getInstance] startUI];
    }
    
    if (self && delegate) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)onAppGoBackground
{
    [[[[UIApplication sharedApplication] windows] firstObject] setHidden:YES];
}

- (void)onAppGoForeground
{
    [[[[UIApplication sharedApplication] windows] firstObject] setHidden:NO];
}

- (void)closemolpay
{
    [[MOLPayMainUI getInstance] closemolpay];
}

// Deprecated
//- (void)transactionRequest {
//    // Delay transactionRequest is the Main UI hasn't loaded
//    if (isMainUILoaded) {
//        [[MOLPayMainUI getInstance] transactionRequest];
//    } else {
//        isTransactionRequestInQueue = YES;
//    }
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view addSubview:[MOLPayMainUI getInstance]];
    [[MOLPayMainUI getInstance] setDelegate:self];
    
    if(self.navigationController.navigationBar)
    {
        // UI frame adjustment ----------------------------
        // When a navigation bar present
        int navbarHeight = 0;
        if (self.navigationController.navigationBar) {
            navbarHeight = self.navigationController.navigationBar.frame.size.height;
        }
        
        // When a navigation bar present and a status bar also present
        int statusbarHeight = 0;
        if (![UIApplication sharedApplication].isStatusBarHidden && navbarHeight>0) {
            statusbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        // -------------------------------------------------
        
        [[MOLPayMainUI getInstance] setFrame:CGRectMake([MOLPayMainUI getInstance].frame.origin.x,
                                                        [MOLPayMainUI getInstance].frame.origin.y,
                                                        [MOLPayMainUI getInstance].frame.size.width,
                                                        [MOLPayMainUI getInstance].frame.size.height - navbarHeight - statusbarHeight)];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(onAppGoBackground)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(onAppGoForeground)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
}

// UIWebview Delegates
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([webView isEqual:[MOLPayMainUI getInstance]]) {
        DLog(@"MOLPayMainUI StartLoad");
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Run script on Popup
    NSString *requestPath = webView.request.URL.absoluteString;
    DLog(@"webViewDidFinishLoad, requestPath = %@", requestPath);
    
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:requestPath, @"requestPath", nil];
    [[MOLPayMainUI getInstance] nativeWebRequestUrlUpdates:data];
    
    if ([webView isEqual:[MOLPayMainUI getInstance]]) {
        DLog(@"MOLPayMainUI FinishLoad");
        [[MOLPayMainUI getInstance] updateSdkData:self.molpayPaymentDetail];
    }
    if (![webView isEqual:[MOLPayMainUI getInstance]]) {
        [(MOLPayWebview*)webView overidingJavascriptMethod];
    }
    isMainUILoaded = YES;
    
    // Load delayed transactionRequest
    if (isTransactionRequestInQueue) {
        [[MOLPayMainUI getInstance] transactionRequest];
        isTransactionRequestInQueue = NO;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestPath = [[request URL] absoluteString];
    DLog(@"requestPath = %@", requestPath);
    
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:requestPath, @"requestPath", nil];
    [[MOLPayMainUI getInstance] nativeWebRequestUrlUpdates:data];
    
    // Main ui handlers
    if (([requestPath rangeOfString:@"file://"].location == NSNotFound) && [webView isEqual:[MOLPayMainUI getInstance]]) {
        
        if ([requestPath rangeOfString:@"mpopenmolpaywindow://"].location != NSNotFound)
        {
            NSString *htmlStringBase64 = [requestPath stringByReplacingOccurrencesOfString:@"mpopenmolpaywindow://" withString:@""];
            htmlStringBase64 = [htmlStringBase64 stringByReplacingOccurrencesOfString:@"_" withString:@"="];
            htmlStringBase64 = [htmlStringBase64 stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
            DLog(@"htmlStringBase64 = %@", htmlStringBase64);
            
            // Base64 Decode minimum iOS7
            NSData *nsdataFromHtmlStringBase64 = [[NSData alloc] initWithBase64EncodedString:htmlStringBase64 options:0];
            NSString *htmlString = [[NSString alloc] initWithData:nsdataFromHtmlStringBase64 encoding:NSUTF8StringEncoding];
            DLog(@"Decoded htmlString: %@", htmlString);
            
            // Open new window if htmlString isn't empty string
            if (htmlString.length > 0) {
                MOLPayWebview *newWindow = [[MOLPayWebview alloc] initWithFrame:self.view.bounds];
                [self.view addSubview:newWindow];
                [newWindow setDelegate:self];
                DLog(@"self.view.subviews = %@", self.view.subviews);
                
                // Load htmlString
                [newWindow loadHTMLString:htmlString baseURL:nil];
            }
            else {
                DLog(@"mpopenmolpaywindow is empty, skip open new window");
            }
            
        }
        
        else if ([requestPath rangeOfString:@"mpcloseallwindows://"].location != NSNotFound) {
            // mpcloseallwindows handler
            while (self.view.subviews.count > 1) {
                [[[self.view subviews] lastObject] performSelector:@selector(removeFromSuperview)];
            }
            DLog(@"Transaction completed, all subviews removed except the main ui");
        }
        
        else if ([requestPath rangeOfString:@"mpclosepopupandrunscriptonmolpaywindow://"].location != NSNotFound) {
            
            NSString *scriptBase64 = [requestPath stringByReplacingOccurrencesOfString:@"mpclosepopupandrunscriptonmolpaywindow://" withString:@""];
            scriptBase64 = [scriptBase64 stringByReplacingOccurrencesOfString:@"_" withString:@"="];
            scriptBase64 = [scriptBase64 stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
            DLog(@"scriptBase64 = %@", scriptBase64);
            
            // Base64 Decode minimum iOS7
            NSData *nsdataFromScriptBase64 = [[NSData alloc] initWithBase64EncodedString:scriptBase64 options:0];
            NSString *script = [[NSString alloc] initWithData:nsdataFromScriptBase64 encoding:NSUTF8StringEncoding];
            DLog(@"Decoded script: %@", script);
            
            // Remove popup
            [[[self.view subviews] lastObject] removeFromSuperview];
            
            // Hide MOLPay window
            [[[self.view subviews] lastObject] setHidden:YES];
            // Run script on MOLPay window
            [[[self.view subviews] lastObject] stringByEvaluatingJavaScriptFromString:script];
            
            DLog(@"Close popup and run script on MOLPay window");
        }
        
        else if ([requestPath rangeOfString:@"mptransactionresults://"].location != NSNotFound) {
            // mptransactionresults handler
            NSString *htmlStringBase64 = [requestPath stringByReplacingOccurrencesOfString:@"mptransactionresults://" withString:@""];
            htmlStringBase64 = [htmlStringBase64 stringByReplacingOccurrencesOfString:@"_" withString:@"="];
            htmlStringBase64 = [htmlStringBase64 stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
            DLog(@"htmlStringBase64 = %@", htmlStringBase64);
            
            // Base64 Decode minimum iOS7
            NSData *nsdataFromHtmlStringBase64 = [[NSData alloc] initWithBase64EncodedString:htmlStringBase64 options:0];
            
            // Deserialize to JSON
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:nsdataFromHtmlStringBase64
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            DLog(@"result json = %@", json);
            
            // Result json to delegate
            [self.delegate transactionResult:json];
        }
        
        else if ([requestPath rangeOfString:@"mprunscriptonpopup://"].location != NSNotFound) {
            // mprunscriptonpopup handler
            NSString *scriptBase64 = [requestPath stringByReplacingOccurrencesOfString:@"mprunscriptonpopup://" withString:@""];
            scriptBase64 = [scriptBase64 stringByReplacingOccurrencesOfString:@"_" withString:@"="];
            scriptBase64 = [scriptBase64 stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
            DLog(@"scriptBase64 = %@", scriptBase64);
            
            // Base64 Decode minimum iOS7
            NSData *nsdataFromScriptBase64 = [[NSData alloc] initWithBase64EncodedString:scriptBase64 options:0];
            NSString *script = [[NSString alloc] initWithData:nsdataFromScriptBase64 encoding:NSUTF8StringEncoding];
            DLog(@"Decoded script: %@", script);
            
            // Run script on popup
            [[[self.view subviews] lastObject] stringByEvaluatingJavaScriptFromString:script];
            
            DLog(@"Run script on popup");
        }
        
        else if ([requestPath rangeOfString:@"mppinstructioncapture://"].location != NSNotFound) {
            // mppinstructioncapture handler
            NSString *dataBase64 = [requestPath stringByReplacingOccurrencesOfString:@"mppinstructioncapture://" withString:@""];
            dataBase64 = [dataBase64 stringByReplacingOccurrencesOfString:@"_" withString:@"="];
            dataBase64 = [dataBase64 stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
            DLog(@"dataBase64 = %@", dataBase64);
            
            // Base64 Decode minimum iOS7
            NSData *nsdataFromDataBase64 = [[NSData alloc] initWithBase64EncodedString:dataBase64 options:0];
            
            // Deserialize to JSON
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:nsdataFromDataBase64
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            DLog(@"result json = %@", json);
            
            NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[json objectForKey:@"base64ImageUrlData"]
                                                                   options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
            DLog(@"mppinstructioncapture handler end");
        }
        
        return NO;
    }
    
    DLog(@"self.view.subviews = %@", self.view.subviews);
    
    return YES;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"Image saved";
    
    if (error) {
        DLog(@"Error = %@", error);
        message = @"Image not saved";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
    
    DLog(@"Image saved");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"webView error = %@", error);
    if ([error code] != -999) {
        [self closemolpay];
    }
}

@end
