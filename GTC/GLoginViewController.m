//
//  GViewController.m
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "GLoginViewController.h"
#import "GAuthController.h"
#import "GNotesListViewController.h"

@interface GLoginViewController ()<AuthControllerDelegate>
@property(nonatomic, strong) GAuthController *authController;
@end

@implementation GLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.authController = [GAuthController authController];
    [self.authController setDelegate:self];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin {
    [self.authController authWithLogin:self.tfLogin.text password:self.tfPassword.text];
}

- (void)onSuccess:(NSString *)token{
    GNotesListViewController *notesList = [[GNotesListViewController alloc] initWithNibName:@"GNotesListViewController" bundle:nil];
    [self.navigationController pushViewController:notesList animated:YES];
}

- (void)onFailed:(NSError *)error
{
    [self.lbLoginFailed setHidden:NO];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.lbLoginFailed setHidden:YES];
    });
    
}
@end
