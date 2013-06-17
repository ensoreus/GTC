//
//  GNoteViewController.m
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "GNoteViewController.h"
#import "GNotesListViewController.h"

@interface GNoteViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *tfTitle;
@property (strong, nonatomic) IBOutlet UITextView *txBody;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;

@end

@implementation GNoteViewController{
    NoteEntity *_noteEntity;
}
@synthesize noteEntity = _noteEntity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self modelToFields];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self fieldsToModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NoteEntity*)noteEntity
{
    return _noteEntity;
}

- (void)setNoteEntity:(NoteEntity *)noteEntity{
    _noteEntity = noteEntity;
    [self modelToFields];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self isTitleUnique]) {
        [self.txBody setEditable:YES];
        [textField resignFirstResponder];
        [self.txBody becomeFirstResponder];
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self lockUpBackButtonIfNeeds];
    return YES;
}

- (BOOL)lockUpBackButtonIfNeeds
{
    BOOL isUnique = [self isTitleUnique];
    self.navigationItem.backBarButtonItem.enabled = isUnique;
    return isUnique;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [self lockUpBackButtonIfNeeds];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self fieldsToModel];
}

- (IBAction)onStartEdit:(id)sender {
    if ([[self.tfTitle text] length] > 0 && [self isTitleUnique]) {
        self.txBody.editable = YES;
        self.tap.enabled = NO;
        [self.txBody becomeFirstResponder];
    }else{
        [[self tfTitle ] becomeFirstResponder];
    }
}

- (BOOL)isTitleUnique{
    NSArray* entities = [self.notesListController notesArray];
    NSArray* filtered = [entities filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[(NoteEntity*)evaluatedObject title] isEqualToString:self.tfTitle.text] && ![self.noteEntity isEqual:evaluatedObject];
    }]];
    return [filtered count] == 0;
}

- (void)fieldsToModel{
    self.noteEntity.title = self.tfTitle.text;
    self.noteEntity.body = self.txBody.text;
}

- (void)modelToFields{
    self.tfTitle.text = self.noteEntity.title;
    self.txBody.text = self.noteEntity.body;
}


@end
