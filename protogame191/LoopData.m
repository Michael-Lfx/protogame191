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

- (long)getBPM {
    return [[_theData valueForKey:@"bpm"] integerValue];
}

- (long)getNumBeats {
    return [[_theData valueForKey:@"beats"] integerValue];
}

- (double)getLastBeat {
    return [[_theData valueForKey:@"lastBeat"] doubleValue];
}

- (NSArray *)getInstrumentNames {
    return [[[_theData valueForKey:@"beat values"] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (double)getEQFrequencyForInstrument:(NSString *)instrumentName {
    return [[[[_theData valueForKey:@"eq values"] valueForKey:instrumentName] valueForKey:@"frequency"] doubleValue];
}

- (double)getEQBandwidthForInstrument:(NSString *)instrumentName {
    return [[[[_theData valueForKey:@"eq values"] valueForKey:instrumentName] valueForKey:@"bandwidth"] doubleValue];
}

- (NSArray *)getBeatValuesForInstrument:(NSString *)instrumentName {
    return [[_theData valueForKey:@"beat values"] valueForKey:instrumentName];
}

- (NSDictionary *)getBeatMap {
    NSMutableDictionary *beatMap = [[NSMutableDictionary alloc] init];
    
    NSArray *instrumentNames = [self getInstrumentNames];
    for (NSString *name in instrumentNames) {
        NSArray *beatValues = [self getBeatValuesForInstrument:name];
        for (NSNumber *value in beatValues) {
            if ([beatMap objectForKey:value] == nil) {
                [beatMap setObject:[NSMutableArray arrayWithObject:name] forKey:value];
            } else {
                [[beatMap objectForKey:value] addObject:name];
            }
        }
    }
//    NSLog(@"%@", beatMap);
    return beatMap;
}

@end
