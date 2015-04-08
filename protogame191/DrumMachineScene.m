//
//  DrumMachineScene.m
//  
//
//  Created by Ben McK on 4/7/15.
//
//

#import "DrumMachineScene.h"

@implementation DrumMachineScene

-(void)didMoveToView:(SKView *)view {
    
    /* Setup your scene here */
    self.backgroundColor = [SKColor colorWithRed:10.0/255 green:55.0/255 blue:70.0/255 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    [self addPads];
    [self createTimeDisplay];
    
    self.view.frameInterval = 2;
}

- (void)addPads{
    float squareWidth = 80;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    float yOffset = screenWidth/3;
    float xStart = screenWidth/6;
    float bufferZone = 60;
    for (int i = 1; i<=3; i++){
        for(int j=1; j<=3; j++){
            float xCenter = screenWidth/3 * i - xStart;
            float yCenter = screenHeight - (yOffset * j) - bufferZone;
            CGRect rect = CGRectMake(xCenter - squareWidth/2, yCenter + squareWidth/2, squareWidth, squareWidth);
            DrumPadNode *drumPad = [DrumPadNode shapeNodeWithRect:rect cornerRadius:5];
            [drumPad setUpNode];
            [self addChild:drumPad];
        }
    }
}

- (void)createTimeDisplay{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect rect = CGRectMake(0, 0, screenWidth, screenWidth/2);
    LoopTimeDisplayNode *timeDisplay = [LoopTimeDisplayNode shapeNodeWithRect:rect cornerRadius:2];
    [self addChild:timeDisplay];
}

@end
