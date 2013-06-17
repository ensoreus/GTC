//
//  GViewController.m
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "GViewController.h"
#import "GAuthController.h"

@interface GViewController ()
@property(nonatomic, strong) GAuthController *authController;
@end

@implementation GViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.authController = [GAuthController authController];
    [self.authController setSuccessBlock:^(NSString *token){
        
    }
     ];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin {
    [self loginFailed];
}

- (void)loginPassed
{
    
}

- (void)loginFailed
{
    [self.lbLoginFailed setHidden:NO];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.lbLoginFailed setHidden:YES];
    });
}
@end
