//
//  DrumPadNode.m
//  protogame191
//
//  Created by Ben McK on 4/7/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import "DrumPadNode.h"

@implementation DrumPadNode

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.strokeColor = [SKColor colorWithWhite:1 alpha:.8];
        self.fillColor = [SKColor colorWithWhite:1 alpha:.6];
    }
    
    return self;
}

- (void)setUpNode{
    
}

- (void)flashNode{
    self.fillColor = [SKColor colorWithWhite:1 alpha:.95];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(unflash) userInfo:nil repeats:NO];
//    [self performSelector:@selector(unflash) withObject:nil afterDelay:.01];
//    [NSTimer scheduledTimerWithTimeInterval:0.5
//                                     target:self
//                                   selector:@selector(unflash)
//                                   userInfo:nil
//                                    repeats:NO];
}

- (void)unflashNode{
    self.fillColor = [SKColor colorWithWhite:1 alpha:.6];
}

@end
