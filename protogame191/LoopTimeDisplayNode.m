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
}

- (void)initWithInfo:(NSDictionary *)info{
    _beatsPerMeasure = info[@"beatsPerMeasure"] ? (int)info[@"beatsPerMeasure"] : 4;
    _possibleNotes = info[@"numPossibleNotes"] ? (int)info[@"numPossibleNotes"] : 2;
}

- (SKShapeNode*) buildTimeLine{
    CGRect rect = CGRectMake(0, 0, 1, 20);
    SKShapeNode *timeLine = [SKShapeNode shapeNodeWithRect:rect];
    timeLine.fillColor = [SKColor redColor];
    timeLine.strokeColor = [SKColor redColor];
    [self addChild:timeLine];
    return timeLine;
}

@end
