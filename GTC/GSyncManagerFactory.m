//
//  GSyncManagerFactory.m
//  GTC
//
//  Created by Philipp Maluta on 18.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "GSyncManagerFactory.h"
#import "GSyncManager.h"
@implementation GSyncManagerFactory
+ (id<SyncProtocol>)makeSyncManager{
    return [[GSyncManager alloc] init];
}
@end
