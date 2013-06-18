//
//  GSyncManagerFactory.h
//  GTC
//
//  Created by Philipp Maluta on 18.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncProtocol.h"
@interface GSyncManagerFactory : NSObject
+ (id<SyncProtocol>)makeSyncManager;
@end
