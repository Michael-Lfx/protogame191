//
//  Conductor.h
//  protogame191
//
//  Created by Henry Thiemann on 4/7/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TheAmazingAudioEngine/TheAmazingAudioEngine.h>
#import "LoopData.h"

@interface Conductor : NSObject <AEAudioTimingReceiver>

- (instancetype)initWithLoopData:(LoopData *)data;
- (void)start;
- (void)stop;
- (double)getCurrentBeat;

@property double currentBeat;

@end
