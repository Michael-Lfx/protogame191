//
//  SongTrainScene.m
//  protogame191
//
//  Created by Ben McK on 5/5/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import "SongTrainScene.h"

@implementation SongTrainScene

- (void) didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    self.backgroundColor = [SKColor colorWithRed:10.0/255 green:55.0/255 blue:70.0/255 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    _loopData = [[LoopData alloc] initWithDataFile:@"loopData/bouncingMark_data"]; // weird with beach, blueSun, distantPianet
    _conductor = [[Conductor alloc] initWithLoopData:_loopData];
    _nextBeat = [self getFirstBeat];
    _resetLoopTime = 0;
    _resetLoopBeat = NO;
    _streakCounter = 0;
    _lastBeat = -1; // this signals we don't know what last beat is.
    
    [_conductor addObserver:self forKeyPath:@"currentBeat" options:0 context:nil];
    
    self.view.frameInterval = 2;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    _leftTrackCenter = screenWidth/3;
    _rightTrackCenter = screenWidth*2/3;
    
    [self addTrackCover];
    [self addButtons];
    [self addTrain];
    [self initStreakDisplay];
    [self addChild: [self playButton]];
}

-(void) addButtons
{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(screenWidth/2,100)];
    leftButton.position = CGPointMake(leftButton.frame.size.width/2, leftButton.frame.size.height/2);
    leftButton.name = @"leftButton";//how the node is identified later
    leftButton.color = [SKColor purpleColor];
    SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(screenWidth/2,100)];
    rightButton.position = CGPointMake(screenWidth/2 + rightButton.frame.size.width/2, rightButton.frame.size.height/2);
    rightButton.name = @"rightButton";//how the node is identified later
    rightButton.color = [SKColor greenColor];
    [self addChild:leftButton];
    [self addChild:rightButton];
}

-(void) addTrackCover
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect rect = CGRectMake(0, 0, screenWidth, screenHeight/3);
    SKShapeNode *ballCover = [SKShapeNode shapeNodeWithRect:rect];
    ballCover.strokeColor = ballCover.fillColor = self.backgroundColor;
    [self addChild:ballCover];
}

- (void)addTrain
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    _train = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(40, 70)];
    _train.position = CGPointMake(screenWidth/2, screenHeight/3);
    [self addChild:_train];
}

-(void)initStreakDisplay
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    _streakDisplay = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%i", _streakCounter]];
    _streakDisplay.fontSize = 18;
    _streakDisplay.fontColor = [UIColor whiteColor];
    _streakDisplay.fontName = @"Avenir-Medium";
    [_streakDisplay setPosition: CGPointMake(screenWidth - 25, screenHeight - 60)];
    _streakDisplay.alpha = .6;
    _streakDisplay.userInteractionEnabled = NO;
    [self addChild:_streakDisplay];
}

- (SKSpriteNode *)playButton
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(80,40)];
    playButton.position = CGPointMake(screenWidth/2, 120);
    playButton.name = @"playButton";//how the node is identified later
    return playButton;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"playButton"]) {
        NSLog(@"Is playing: %d", (BOOL)[_conductor getIsPlaying]);
        if((BOOL)[_conductor getIsPlaying]){
            [_conductor stop];
        } else {
            [_conductor start];
        }
    } else if ([node.name isEqualToString:@"leftButton"]) {
        [self hop:@"left"];
    } else if ([node.name isEqualToString:@"rightButton"]) {
        [self hop:@"right"];
    }
}

- (void)hop:(NSString *)direction {
    CGFloat jumpDuration = .25;
    CGFloat destination = [direction isEqualToString:@"left"] ? _leftTrackCenter : _rightTrackCenter;
    CGFloat distance = destination - _train.position.x ;
    SKAction *moveFirstHalf = [SKAction moveByX:distance/2 y:0 duration:jumpDuration/2];
    SKAction *rise = [SKAction scaleTo:1.4 duration:jumpDuration/2];
    rise.timingMode = SKActionTimingEaseOut;
    SKAction *moveSecondHalf = [SKAction moveByX:distance/2 y:0 duration:jumpDuration/2];
    SKAction *fall = [SKAction scaleTo:1 duration:jumpDuration/2];
    fall.timingMode = SKActionTimingEaseIn;
    SKAction *jumpFirstHalf = [SKAction group:@[moveFirstHalf, rise]];
    SKAction *jumpSecondHalf = [SKAction group:@[moveSecondHalf, fall]];
    SKAction *jump = [SKAction sequence:@[jumpFirstHalf, jumpSecondHalf]];
    [_train runAction:jump];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentBeat"]){
        double currTime = [_conductor getCurrentBeat];
        double preBeat = 2;
        double firingTime = currTime + preBeat;
        double animationDuration = preBeat * 60/[_loopData getBPM];
        if(firingTime > [_loopData getNumBeats]){ // now it oscilates from 0 to 16
            firingTime -= [_loopData getNumBeats];
        }
        if(firingTime > _nextBeat && (!_resetLoopBeat || (_resetLoopBeat && firingTime < .5 + [self getFirstBeat] &&
            (_resetLoopTime && (CACurrentMediaTime() - _resetLoopTime > [_loopData getNumBeats]-_lastBeat-preBeat))))){
            _resetLoopBeat = NO;
            NSDictionary *beatMap = [_loopData getBeatMap];
            NSArray *beatsToFire = [beatMap objectForKey:[NSNumber numberWithDouble:_nextBeat]];
            for(NSString *instrumentName in beatsToFire){
                [self drawTrack:instrumentName duration:animationDuration];
            }
            _nextBeat = [self getNextBeat:beatMap];// update next beat by iterating through keys
        }
    }
}

- (double)getFirstBeat
{
    NSDictionary *beatMap = [_loopData getBeatMap];
    NSArray *sortedKeys = [[beatMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *num1 = obj1;
        NSNumber *num2 = obj2;
        if ( num1.doubleValue < num2.doubleValue ) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
    return ((NSNumber *)sortedKeys[0]).doubleValue;
}

- (double)getNextBeat:(NSDictionary *)beatMap
{
    NSArray *sortedKeys = [[beatMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *num1 = obj1;
        NSNumber *num2 = obj2;
        if ( num1.doubleValue < num2.doubleValue ) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
    // check if user has hit the beat yet if not, turn on filter/fire mistakes
    int indexOfNextKey = [sortedKeys indexOfObject:[NSNumber numberWithDouble:_nextBeat]] + 1;
    if(indexOfNextKey >= sortedKeys.count){
        indexOfNextKey = 0;
        _resetLoopTime = CACurrentMediaTime();
        _lastBeat = _nextBeat;
        _resetLoopBeat = YES;
    }
    return ((NSNumber *)sortedKeys[indexOfNextKey]).doubleValue;
}

- (void)drawTrack:(NSString *)instrumentName duration:(double)animationDuration
{
//    // duration to get top of track to top of train
//    int noteNumber = [[instrumentName substringFromIndex:(instrumentName.length - 1)] intValue];
//    int numInstruments = [[_loopData getInstrumentNames] count];
//    int column = numInstruments - noteNumber;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    // calculate track length
//    SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:20];
//    circle.fillColor = [SKColor greenColor];
//    [circle setPosition:CGPointMake(column * screenWidth/numInstruments + (screenWidth/numInstruments)/2, screenHeight + circle.frame.size.height/2)];
//    [self addChild:circle];
//    circle.zPosition = -1;
//    SKAction *dropBall = [SKAction moveToY:screenHeight/5 + circle.frame.size.height/2 duration:animationDuration];
//    [circle runAction:dropBall completion:^(void){
//        if(_slider.value >= _slider.maximumValue * (column/(double)numInstruments) && _slider.value <= _slider.maximumValue * (column+1)/(double)numInstruments){
//            _streakCounter ++;
//        } else {
//            _streakCounter = 0;
////            [self flashRedScreen];
//        }
//        [self updateStreakCounterDisplay];
//        [self removeChildrenInArray:@[circle]];
//    }];
    
}

//- (void)flashRedScreen
//{
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGRect rect = CGRectMake(0, 0, screenWidth, screenHeight);
//    SKShapeNode *redCover = [SKShapeNode shapeNodeWithRect:rect];
//    redCover.fillColor = [SKColor redColor];
//    redCover.userInteractionEnabled = NO;
//    [self addChild:redCover];
//    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:.4];
//    [redCover runAction:fadeOut completion:^(void){
//        [self removeChildrenInArray:@[redCover]];
//    }];
//}

- (void)updateStreakCounterDisplay
{
    _streakDisplay.text = [NSString stringWithFormat:@"%i", _streakCounter];
}

@end
