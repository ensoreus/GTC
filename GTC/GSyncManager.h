//
//  GSyncManager.h
//  GTC
//
//  Created by Philipp Maluta on 18.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncProtocol.h"

@interface GSyncManager : NSObject<SyncProtocol>
@property (nonatomic, weak) id<SyncDelegateProtocol> delegate;
- (void)synchronizeWithNotes:(NSArray *)notes;

@end
