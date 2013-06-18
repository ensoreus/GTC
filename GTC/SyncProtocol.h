//
//  SyncProtocol.h
//  GTC
//
//  Created by Philipp Maluta on 18.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncDelegateProtocol <NSObject>
- (void)newNotesArrived:(NSArray *)notes;
- (void)deletesNotes:(NSArray *)notes;

@end
@protocol SyncProtocol <NSObject>
- (void)synchronizeWithNotes:(NSArray *)notes;
- (void)setDelegate:(id<SyncDelegateProtocol>)delegate;
@end
