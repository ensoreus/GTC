//
//  GAuthController.m
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "GAuthController.h"

@interface GAuthController ()

@end

@implementation GAuthController

+ (GAuthController *) authController;
{
    static GAuthController* sAuthController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sAuthController = [GAuthController new];
    });
    return sAuthController;
}

- (void)authWithLogin:(NSString *)login  password:(NSString *)password
{
    if ([login isEqualToString:@"Luke"] && [password isEqualToString:@"Jedi"])
    {
        self.token =  [self generateToken];
        if (self.successBlock) {
            self.successBlock(self.token);
        }else if (self.delegate) {
            [self.delegate onSuccess:self.token];
        }
        
    }else{
        if (self.failedBlock){
            self.failedBlock([self generateAuthError]);
        }else if (self.delegate)
        {
            [self.delegate onFailed:[self generateAuthError]];
        }
    }
}

- (NSString *)generateToken
{
    CFUUIDRef     myUUID;
    CFStringRef   myUUIDString;
    char          strBuffer[100];
    
    myUUID = CFUUIDCreate(kCFAllocatorDefault);
    myUUIDString = CFUUIDCreateString(kCFAllocatorDefault, myUUID);
    
    CFStringGetCString(myUUIDString, strBuffer, 100, kCFStringEncodingASCII);
    return [NSString stringWithCString:strBuffer encoding:NSUTF8StringEncoding];
     
}

- (NSError *)generateAuthError
{
    return [NSError errorWithDomain:NSOSStatusErrorDomain code:400 userInfo:nil];
}

- (void)logout
{
    self.token = nil;
}
@end
