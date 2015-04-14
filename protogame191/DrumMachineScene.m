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
    
    _loopData = [[LoopData alloc] initWithDataFile:@"drum_simple_data"];
    NSLog(@"%@", [_loopData getFilename]);
    NSLog(@"%@", [_loopData getFiletype]);
    NSLog(@"%i", [_loopData getBPM]);
    NSLog(@"%i", [_loopData getNumBeats]);
    NSArray *instrumentNames = [_loopData getInstrumentNames];
    for (NSString *instrumentName in instrumentNames) {
        NSLog(@"%@: %@", instrumentName, [_loopData getBeatValuesForInstrument:instrumentName]);
    }
    
    _conductor = [[Conductor alloc] initWithLoopData:_loopData];
    
    [self addPads];
    [self createTimeDisplay];
    [self addChild: [self playButton]];
    
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

- (SKSpriteNode *)playButton
{
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(80,40)];
    playButton.position = CGPointMake(150 ,200);
    playButton.name = @"playButton";//how the node is identified later
    return playButton;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"playButton"]) {
        [_timeDisplay moveTimeline];
        [_conductor start];
    }
}

- (void)createTimeDisplay{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = CGRectMake(0, 0, screenWidth, screenWidth/2);
    _timeDisplay = [LoopTimeDisplayNode shapeNodeWithRect:rect cornerRadius:2];
    [_timeDisplay initWithInfo:_loopData];
    [self addChild:_timeDisplay];
}

-(void)update:(NSTimeInterval)currentTime{
    
}

@end
