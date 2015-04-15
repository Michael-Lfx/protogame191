//
//  MidiDataDisplayNode.h
//  protogame191
//
//  Created by Ben McK on 4/14/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LoopData.h"

@interface MidiDataDisplayNode : SKShapeNode

- (void) initWithInfo:(LoopData*)loopData;
- (void) addUserMidiNote:(NSString *)instrument atBeat:(double)beatHit correct:(BOOL)correct;

@property LoopData *loopData;

@end
