//
//  LoopTimeDisplayNode.h
//  protogame191
//
//  Created by Ben McK on 4/7/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LoopData.h"
#import "MidiDataDisplayNode.h"

@interface LoopTimeDisplayNode : SKShapeNode

- (void)initWithInfo:(LoopData *)loopData;
- (void)moveTimeline;
- (void)stopTimeline;

@property LoopData *loopData;
@property MidiDataDisplayNode *midiData;
@property MidiDataDisplayNode *midiCopy;


@end
