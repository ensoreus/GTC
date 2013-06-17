//
//  Note.h
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NoteEntity : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * geoLat;
@property (nonatomic, retain) NSNumber * geoLong;
-(NSString *)description;
@end
