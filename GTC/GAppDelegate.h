//
//  GAppDelegate.h
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GViewController;

@interface GAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GViewController *viewController;

@end
