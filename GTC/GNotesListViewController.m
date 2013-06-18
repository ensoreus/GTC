//
//  GNotesViewController.m
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "GNotesListViewController.h"
#import "GNoteViewController.h"
#import "NoteEntity.h"
#import "GAppDelegate.h"
#import "SyncProtocol.h"
#import "GSyncManagerFactory.h"
#import "GAuthController.h"
#import "MBProgressHUD.h"

@interface GNotesListViewController ()<CLLocationManagerDelegate, UISearchBarDelegate, SyncDelegateProtocol>
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIBarButtonItem* addButton;
@property (nonatomic, strong) NSArray* currentDataSourceArray;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) id<SyncProtocol> syncManager;
@end

@implementation GNotesListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)setupManagedObjectContext
{
    self.managedObjectContext = [(GAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)viewDidLoad
{
    self.title = @"Notes";
    self.syncManager = [GSyncManagerFactory makeSyncManager];
    [self.syncManager setDelegate:self];
    [super viewDidLoad];
    [self setupToolbar];
    [self setupLocationManager];
    [self setupManagedObjectContext];
    [self setupNavigationBar];
    [self setupToolbar];
    [self fetchNotes];
	// Start the location manager.
	[[self locationManager] startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
    [self cleanStorage];
	[self.tableView reloadData];
}

- (void)viewDidUnload {
	self.notesArray = nil;
	self.locationManager = nil;
	self.addButton = nil;
    [self cleanStorage];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)repositionToolBar:(UIToolbar *)toolbar
{
	// size up the toolbar and set its frame
    [toolbar sizeToFit];
	CGFloat toolbarHeight = [toolbar frame].size.height;
	CGRect mainViewBounds = [[UIScreen mainScreen] bounds];
	[toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
								 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight * 2.0) + 2.0 + self.searchController.bounds.size.height,
								 CGRectGetWidth(mainViewBounds),
								 toolbarHeight)];
}

- (void)setupToolbar
{
    self.toolBar = [UIToolbar new];
	self.toolBar.barStyle = UIBarStyleDefault;
	
    [self repositionToolBar:self.toolBar];
	
	[self.navigationController.view addSubview:self.toolBar];
    
    UIBarButtonItem* sync = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onSync)];
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(onLogout)];
    NSArray* items = @[sync, spacer, logout];
    [self.toolBar setItems:items animated:YES];
}

- (void)setupLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [self.locationManager setDelegate:self];
}

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
	self.addButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.addButton;
}

- (void)fetchNotes
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
    
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	[self setNotesArray:mutableFetchResults];
    self.currentDataSourceArray = self.notesArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentDataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NoteEntity* note = [self noteAtRow:indexPath.row];
    cell.textLabel.text = note.title;
    // Configure the cell...
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the managed object at the given index path.
     NSManagedObject *noteToDelete = [self noteAtRow:indexPath.row];
     [self.managedObjectContext deleteObject:noteToDelete];
     
     // Update the array and table view.
     [self.notesArray removeObjectAtIndex:indexPath.row];
     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
     
     // Commit the change.
     NSError *error = nil;
     if (![self.managedObjectContext save:&error]) {
     // Handle the error.
     }
    }
}

- (void)openNoteDetails:(NoteEntity *)note {
    GNoteViewController *detailViewController = [[GNoteViewController alloc] initWithNibName:@"GNoteViewController" bundle:nil];
    detailViewController.noteEntity = note;
    detailViewController.notesListController = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)addEvent {
	
	CLLocation *location = [self.locationManager location];
	if (!location) {
		return;
	}
	NoteEntity *note = (NoteEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
	
	CLLocationCoordinate2D coordinate = [location coordinate];
	[note setGeoLat:[NSNumber numberWithDouble:coordinate.latitude]];
	[note setGeoLong:[NSNumber numberWithDouble:coordinate.longitude]];

	[note setDate:[NSDate date]];
	
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
	}

    [self.notesArray insertObject:note atIndex:0];
    [self openNoteDetails:note];
}

- (void)cleanStorage{
    NSArray *empties = [self.notesArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject title] == nil;
    }]];
    [self.notesArray removeObjectsInArray:empties];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openNoteDetails:[self noteAtRow:indexPath.row]];
}

- (NoteEntity *)noteAtRow:(NSUInteger)row{
    return [self.currentDataSourceArray objectAtIndex:row];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.addButton.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.addButton.enabled = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.currentDataSourceArray = self.notesArray;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.currentDataSourceArray = [self.notesArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject title] rangeOfString:searchText].location != NSNotFound || [[evaluatedObject body] rangeOfString:searchText].location != NSNotFound;
    }]];
    [self.tableView reloadData];
}

- (void)onLogout{
    [[GAuthController authController] logout];
    [self.notesArray removeAllObjects];
    [(GAppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    [self.tableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)onSync{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       [self.syncManager synchronizeWithNotes:self.notesArray]; 
}

- (void)newNotesArrived:(NSArray *)notes{
        [self.notesArray addObjectsFromArray:notes];
        [self.tableView reloadData];
}

- (void)deletesNotes:(NSArray *)notes{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.notesArray removeObjectsInArray:notes];
}

@end
