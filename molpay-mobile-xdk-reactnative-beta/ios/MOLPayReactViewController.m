
#import "MOLPayReactViewController.h"
#import "MOLPayReactManager.h"

#import "MOLPayLib.h"

@interface MOLPayReactViewController () <MOLPayLibDelegate>
{
    MOLPayLib *mp;
    BOOL isCloseButtonClick;
    BOOL isPaymentInstructionPresent;
    BOOL isStartedMOLPay;
    NSDictionary *paymentResult;
}
@end

@implementation MOLPayReactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)closemolpay:(id)sender
{
    // Closes MOLPay
    [mp closemolpay];
    
    isCloseButtonClick = YES;
}

-(void)start {
    isPaymentInstructionPresent = NO;
    isCloseButtonClick = NO;
    isStartedMOLPay = YES;
    mp = [[MOLPayLib alloc] initWithDelegate:self andPaymentDetails:_PaymentDetails];
    
    mp.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(closemolpay:)];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mp];
    
    
    mp.navigationItem.hidesBackButton = YES;
    
    [self presentViewController:nc animated:NO completion:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(isStartedMOLPay == YES){
        NSLog(@"close");
        
        [self dismissViewControllerAnimated:NO completion:nil];
        if (self.didDismiss){
            self.didDismiss(paymentResult);
        }
    }else{
        [self start];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)transactionResult:(NSDictionary *)result{
    
    paymentResult = result;
    // All success cash channel payments will display a payment instruction, we will let the user to close manually
    if ([[result objectForKey:@"pInstruction"] integerValue] == 1 && isPaymentInstructionPresent == NO && isCloseButtonClick == NO)
    {
        isPaymentInstructionPresent = YES;
    }
    else
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
//    NSLog(@"transactionResult result = %@", result);
}

@end

