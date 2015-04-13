//
//  LoopData.m
//  protogame191
//
//  Created by Henry Thiemann on 4/13/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import "LoopData.h"

@interface LoopData ()

@property(nonatomic) NSDictionary *theData;

@end

@implementation LoopData

- (instancetype)initWithDataFile:(NSString *)filename {
    self = [super init];
    
    if (self) {
        NSString *pathToPlist = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        _theData = [[NSDictionary alloc] initWithContentsOfFile:pathToPlist];
    }
    
    return self;
}

- (NSString *)getFilename {
    return [_theData valueForKey:@"filename"];
}

- (NSString *)getFiletype {
    return [_theData valueForKey:@"filetype"];
}

- (int)getBPM {
    return (int)[[_theData valueForKey:@"bpm"] integerValue];
}

- (int)getNumBeats {
    return (int)[[_theData valueForKey:@"beats"] integerValue];
}

- (NSArray *)getInstrumentNames {
    return [[_theData valueForKey:@"beat values"] allKeys];
}

- (NSArray *)getBeatValuesForInstrument:(NSString *)instrumentName {
    return [[_theData valueForKey:@"beat values"] valueForKey:instrumentName];
}

@end
