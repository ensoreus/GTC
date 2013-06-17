//
//  Note.m
//  GTC
//
//  Created by Philipp Maluta on 17.06.13.
//  Copyright (c) 2013 Philipp Maluta. All rights reserved.
//

#import "NoteEntity.h"


@implementation NoteEntity

@dynamic title;
@dynamic body;
@dynamic date;
@dynamic geoLat;
@dynamic geoLong;
- (NSString *)description{
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return [NSString stringWithFormat:@"%@: %@\n %@, %f:%f", self.title, self.body, [formatter stringFromDate:self.date], [self.geoLat floatValue], [self.geoLong floatValue]];
}
@end
