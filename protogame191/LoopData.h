//
//  LoopData.h
//  protogame191
//
//  Created by Henry Thiemann on 4/13/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoopData : NSObject

- (instancetype)initWithDataFile:(NSString *)filename;
- (NSString *)getFilename;
- (NSString *)getFiletype;
- (long)getBPM;
- (long)getNumBeats;
- (double)getLastBeat;
- (NSArray *)getInstrumentNames;
- (double)getEQFrequencyForInstrument:(NSString *)instrumentName;
- (double)getEQBandwidthForInstrument:(NSString *)instrumentName;
- (NSArray *)getBeatValuesForInstrument:(NSString *)instrumentName;
- (NSDictionary *)getBeatMap;

@end
