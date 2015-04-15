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
    [self buildPlayHead];
}

- (void)initWithInfo:(LoopData *)data{
    _loopData = data;
    [self buildMidiData];
}

- (void)buildMidiData {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = CGRectMake(0, 5, screenWidth * 1.5, screenHeight - 10);
    _midiData = [MidiDataDisplayNode shapeNodeWithRect:rect cornerRadius:5];
    _midiCopy = [MidiDataDisplayNode shapeNodeWithRect:rect cornerRadius:5];
    [_midiData initWithInfo:_loopData];
    [_midiCopy initWithInfo:_loopData];
    [self addChild:_midiData];
    [self addChild:_midiCopy];
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
    CGFloat midiWidth = _midiData.frame.size.width;
    CGFloat xAnchor = screenWidth/4;
    CGFloat loopTime = (float)_loopData.getNumBeats/_loopData.getBPM * 60;
    
    SKAction *startDataPlacement = [SKAction moveToX:xAnchor + midiWidth duration:0];
    SKAction *startData = [SKAction sequence:@[startDataPlacement, [SKAction moveToX:xAnchor-midiWidth duration:(loopTime*2)]]];
    
    SKAction *startCopyPlacement = [SKAction moveToX:xAnchor + (midiWidth*2) duration:0];
    SKAction *startCopy = [SKAction sequence:@[startCopyPlacement, [SKAction moveToX:xAnchor - (midiWidth) duration:(loopTime)*3]]];
    
    SKAction *animateDataOut = [SKAction moveToX:xAnchor-(midiWidth*5/4) duration:loopTime/4];
    SKAction *resetData = [SKAction moveToX:xAnchor + (midiWidth*3/4) duration:0];
    SKAction *animateDataLoop = [SKAction moveToX:(xAnchor - midiWidth) duration:loopTime*7/4];
    SKAction *loopData = [SKAction repeatActionForever:[SKAction sequence:@[animateDataOut, resetData, animateDataLoop]]];
    
    [_midiData runAction:startData completion:^(void){
        [_midiData runAction:loopData withKey:@"moveData"];
    }];
    [_midiCopy runAction:startCopy completion:^(void){
        [_midiCopy runAction:loopData withKey:@"moveData"];
    }];
    
}

- (void)stopTimeline {
    [_midiData removeActionForKey:@"moveData"];
}

- (void)addUserMidiNote:(NSString *)instrument atBeat:(double)beatHit correct:(BOOL)correct{
    [_midiData addUserMidiNote:instrument atBeat:beatHit correct:correct];
    [_midiCopy addUserMidiNote:instrument atBeat:beatHit correct:correct];
}

@end
