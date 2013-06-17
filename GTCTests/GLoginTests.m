//
//  GLoginTests.m
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "GLoginTests.h"

@implementation GLoginTests


- (void)setUp{
    self.authController = [GAuthController authController];
}

- (void)tearDown
{
    self.authController = nil;
}

- (void)testAuthControllerDeniesOnIncorrectCreds
{
    [self.authController setSuccessBlock:^(NSString *token){
        STFail(@"Auth controller should fail on Incorrect credentials");
    }];
    [self.authController setFailedBlock:^(NSError *e){
        STAssertEquals([e code], 400, @"Authorization returns wrong code, may be it is not an auth fault");
    }];
    [self.authController authWithLogin:@"Datrh" password:@"Vader" ];
    
}

- (void)testAuthControllerAcceptsCorrectCreds
{
    [self.authController setSuccessBlock:^(NSString *token){
        STAssertNotNil(token, @"On success auth returns nil token");
        
    }];
    [self.authController setFailedBlock:^(NSError *e){
        STFail(@"Auth controller fails on correct credentials");
    }];
    [self.authController authWithLogin:@"Luke" password:@"Jedi" ];
}

- (void)testAuthControllerContainsTokenAndItsNotNil
{
    [self.authController setSuccessBlock:^(NSString *token){
        STAssertNotNil(self.authController.token, @"token is nil");
    }];
    [self.authController authWithLogin:@"Luke" password:@"Jedi" ];
}

@end
