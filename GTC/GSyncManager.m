//
//  GSyncManager.m
//  GTC
//
//  Created by Philipp Maluta on 18.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "GSyncManager.h"
#import "NoteEntity.h"
#import "GAppDelegate.h"

@implementation GSyncManager
- (void)synchronizeWithNotes:(NSArray *)notes{
    [self sendToServer:notes];
    [self fetchNotes];
    [[self delegate] deletesNotes:[self deletedNotes]];
}

- (void)sendToServer:(NSArray *)notes{
    //send
}

- (void)fetchNotes{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NoteEntity* note1 = [GSyncManager createNoteWithTitle:@" Der autoritär wie für" body:@"Sie Kirche er club. Übelkeit Kirche; einmalig. Investieren Die für Horrordiagnose, Auto die nur Schon werden. Internet gegen zu November. Agenten muten verschrieben Worte, Perspektiven Stress das Prozent Lärm. Sichern aber Autorin Unterschiede. Lehnt Augenmerk für Fundamentaltheologie."];
        NoteEntity* note2 = [GSyncManager createNoteWithTitle:@"Wird spannend dass auf." body:@"Tauferneuerung er mit anderen, auf war der Preisen in. Des Historische zentrale an. Systematische des Giftmord zu, und damit morgens war Stimmt. Systematische anderem bestimmte irgendwie."];
        NoteEntity *note3 = [GSyncManager createNoteWithTitle:@"November Preise Theologin Sozialethik." body:@"Lehnt Augenmerk für Fundamentaltheologie.                           Dogmatischer fassen; einer Benzin. der ausgesprochen schätzen. Ist damit Taufbekenntnis Krankenhaus."];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(SyncDelegateProtocol)]) {
            [self.delegate newNotesArrived:@[note1, note2, note3]];
        }
        
    });
    
}

- (NSArray *)deletedNotes{
    NoteEntity* note1 = [GSyncManager createNoteWithTitle:@"sss" body:@"www.google.com"];
    NoteEntity* note2 = [GSyncManager createNoteWithTitle:@"yyy" body:@"uuuuu"];
    return @[note1, note2];
}


+ (NoteEntity *)createNoteWithTitle:(NSString *)title body:(NSString* )body{
    GAppDelegate* appDelegate = (GAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:[appDelegate managedObjectContext]];
    NoteEntity* note = [[NoteEntity alloc] initWithEntity:description insertIntoManagedObjectContext:[appDelegate managedObjectContext]];
    note.title = title;
    note.body = body;
    note.geoLat = @(random() % 180 / 2);
    note.geoLong = @(random() % 360 / 2);
    note.date = [NSDate date];
    return note;
}
@end
