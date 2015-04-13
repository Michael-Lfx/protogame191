//
//  LoopTimeDisplayNode.h
//  protogame191
//
//  Created by Ben McK on 4/7/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LoopTimeDisplayNode : SKShapeNode

- (void)initWithInfo:(NSDictionary *)info;
- (void)moveTimeline;
- (void)stopTimeline;

@property int beatsInSoundFile;
@property int possibleNotes;
@property float beatsPerMinute;
@property SKShapeNode *timeLine;


@end
