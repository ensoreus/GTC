//
//  GAuthController.h
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessfulAuthBlock)(NSString *);
typedef void (^FailedAuthBlock)(NSError *);

@interface GAuthController : NSObject
@property (nonatomic, strong) SuccessfulAuthBlock successBlock;
@property (nonatomic, strong) FailedAuthBlock failedBlock;
@property (nonatomic, strong) NSString *token;

+ (GAuthController *) authController;
- (void)authWithLogin:(NSString *)login  password:(NSString *)password;
@end
