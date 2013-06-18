//
//  GAppDelegate.h
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLoginViewController;
@class NoteEntity;

@interface GAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic)NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;
- (void)saveContext ;
@end
