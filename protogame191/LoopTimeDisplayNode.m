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
    [self buildMidiData];
    [self buildPlayHead];
    [self addChild:_midiData];
    [self initWithInfo:nil];
}

- (void)initWithInfo:(NSDictionary *)info{
    _beatsInSoundFile = info[@"beatsInSoundFile"] ? (int)info[@"beatsInSoundFile"] : 16;
    _beatsPerMinute = info[@"beatsPerMinute"] ? (int)info[@"beatsPerMinute"] : 100;
    _possibleNotes = info[@"numPossibleNotes"] ? (int)info[@"numPossibleNotes"] : 2;
}

- (void)buildMidiData {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = CGRectMake(0, 5, screenWidth, screenHeight - 10);
    SKShapeNode *midiData = [SKShapeNode shapeNodeWithRect:rect cornerRadius:5];
    midiData.fillColor = [SKColor blueColor];
    midiData.alpha = .7;
    _midiData = midiData;
    _midiCopy = midiData;
}

- (void) buildPlayHead{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = CGRectMake(0, 0, .5, screenHeight);
    SKShapeNode *timeLine = [SKShapeNode shapeNodeWithRect:rect];
    timeLine.position = CGPointMake(screenWidth/4, 0);
    timeLine.fillColor = [SKColor blackColor];
    timeLine.strokeColor = [SKColor blackColor];
    SKShapeNode *playHead = [SKShapeNode shapeNodeWithPath:[self trianglePath:timeLine.position]];
    playHead.fillColor = [SKColor greenColor];
    playHead.strokeColor = [SKColor blackColor];
    
    [self addChild:timeLine];
    [self addChild:playHead];
}

- (CGPathRef) trianglePath:(CGPoint) center{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat playheadHight = 10;
    CGFloat playheadWidth = 20;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(center.x, screenHeight-playheadHight)];
    [bezierPath addLineToPoint: CGPointMake(center.x - (playheadWidth)/2, screenHeight)];
    [bezierPath addLineToPoint: CGPointMake(center.x + (playheadWidth)/2, screenHeight)];
    
    [bezierPath closePath];
    return bezierPath.CGPath;
}

- (void)moveTimeline {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat xAnchor = screenWidth/4;
    SKAction *reset = [SKAction moveToX:xAnchor duration:0];
    _midiData.position = CGPointMake(0, 0);
    CGFloat loopTime = _beatsInSoundFile/_beatsPerMinute * 60;
    SKAction *animateLine = [SKAction moveToX:(xAnchor - _midiData.frame.size.width) duration:loopTime];
    SKAction *loop = [SKAction repeatActionForever:[SKAction sequence:@[reset, animateLine]]];
    [_midiData runAction:loop withKey:@"moveTimeline"];
}

- (void)stopTimeline {
    [_midiData removeActionForKey:@"moveTimeline"];
}

@end
