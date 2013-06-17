//
//  GViewController.h
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *tfLogin;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UILabel *lbLoginFailed;
- (IBAction)onLogin;

@end
