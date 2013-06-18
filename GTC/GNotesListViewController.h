//
//  GNotesViewController.h
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GNotesListViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISearchBar *searchController;
@property (nonatomic, strong) NSMutableArray* notesArray;
@end
