//
//  GNoteViewController.h
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteEntity.h"
@class GNotesListViewController;
@interface GNoteViewController : UIViewController
@property (nonatomic, strong)NoteEntity *noteEntity;
@property (nonatomic, weak) GNotesListViewController *notesListController;
@end
