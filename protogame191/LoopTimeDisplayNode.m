//
//  LoopTimeDisplayNode.m
//  protogame191
//
//  Created by Ben McK on 4/7/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import "LoopTimeDisplayNode.h"

@implementation LoopTimeDisplayNode

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.strokeColor = [SKColor colorWithWhite:1 alpha:.8];
        self.fillColor = [SKColor colorWithWhite:1 alpha:.6];
    }
    
    [self initializeView];
    
    return self;
}

- (void)initializeView {
    _timeLine = [self buildTimeLine];
    [self initWithInfo:nil];
}

- (void)initWithInfo:(NSDictionary *)info{
    _beatsInSoundFile = info[@"beatsInSoundFile"] ? (int)info[@"beatsInSoundFile"] : 16;
    _beatsPerMinute = info[@"beatsPerMinute"] ? (int)info[@"beatsPerMinute"] : 100;
    _possibleNotes = info[@"numPossibleNotes"] ? (int)info[@"numPossibleNotes"] : 2;
}

- (SKShapeNode*) buildTimeLine{
    CGFloat height = [UIScreen mainScreen].bounds.size.width/2;
    CGRect rect = CGRectMake(0, 0, .5, height);
    SKShapeNode *timeLine = [SKShapeNode shapeNodeWithRect:rect];
    timeLine.fillColor = [SKColor redColor];
    timeLine.strokeColor = [SKColor redColor];
    [self addChild:timeLine];
    return timeLine;
}

- (void)moveTimeline {
    SKAction *reset = [SKAction moveToX:0 duration:0];
    _timeLine.position = CGPointMake(0, 0);
    CGFloat loopTime = _beatsInSoundFile/_beatsPerMinute * 60;
    SKAction *animateLine = [SKAction moveToX:self.frame.size.width duration:loopTime];
    SKAction *loop = [SKAction repeatActionForever:[SKAction sequence:@[reset, animateLine]]];
    [_timeLine runAction:loop withKey:@"moveTimeline"];
}

- (void)stopTimeline {
    [_timeLine removeActionForKey:@"moveTimeline"];
}

@end
