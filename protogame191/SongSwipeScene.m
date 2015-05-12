//
//  SongSwipeScene.m
//  protogame191
//
//  Created by Ben McK on 5/5/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import "SongSwipeScene.h"

@implementation SongSwipeScene

#pragma mark - INITIALIZATION

- (void) didMoveToView:(SKView *)view
{
    // setup scene
    self.backgroundColor = [SKColor colorWithRed:10.0/255 green:55.0/255 blue:70.0/255 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // setup global variables
    _loopData = [[LoopData alloc] initWithDataFile:@"loopData/cypress_data"]; // weird with beach, blueSun, distantPianet
    _conductor = [[Conductor alloc] initWithLoopData:_loopData];
    _nextBeat = [self getFirstBeat];
    _resetLoopTime = 0;
    _resetLoopBeat = NO;
    _streakCounter = 0;
    _lastBeat = -1; // this signals we don't know what last beat is.
    
    
    [_conductor addObserver:self forKeyPath:@"currentBeat" options:0 context:nil];
    self.view.frameInterval = 2;
    
    // add nodes
    [self initStreakDisplay];
    [self addPlayButton];
    [self addSwipeZone];
    [self addHitZone];
    [self addSwipeRecognizers];
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

- (void)addPlayButton
{
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(80,40)];
    playButton.position = CGPointMake(40, 350);
    playButton.name = @"playButton";//how the node is identified later
    [self addChild:playButton];
}

- (void)addSwipeZone
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    SKSpriteNode *swipeZone = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(screenWidth,screenHeight/3)];
    swipeZone.alpha = .4;
    swipeZone.position = CGPointMake(swipeZone.size.width/2, swipeZone.size.height/2);
    swipeZone.name = @"swipeZone";//how the node is identified later
    [self addChild:swipeZone];
}

- (void)addHitZone
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    SKSpriteNode *hitZone = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(screenWidth,80)];
    hitZone.alpha = .4;
    hitZone.position = CGPointMake(screenWidth/2, screenHeight/3 + hitZone.size.height/2);
    hitZone.name = @"hitZone";//how the node is identified later
    [self addChild:hitZone];
}

- (void)addSwipeRecognizers
{
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *upSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *downSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];

    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    [self.view addGestureRecognizer:upSwipeRecognizer];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    [self.view addGestureRecognizer:downSwipeRecognizer];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchLocation = [sender locationInView:sender.view];
        touchLocation = [self convertPointFromView:touchLocation];
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
        if([touchedNode.name isEqualToString:@"swipeZone"]){
            SKSpriteNode *hitZone = (SKSpriteNode *)[self childNodeWithName:@"hitZone"];
            NSArray *arrowNodes = [self nodesAtPoint:hitZone.position];
            if(sender.direction == UISwipeGestureRecognizerDirectionDown){
                for(SKNode *node in arrowNodes){
                    if([node.name isEqualToString:@"down"]){
                        [node removeAllActions];
                        [self removeChildrenInArray:@[node]];
                        _streakCounter++;
                        [self updateStreakCounterDisplay];
                    }
                }
                NSLog(@"Swiped Down");
            } else if(sender.direction == UISwipeGestureRecognizerDirectionLeft){
                for(SKNode *node in arrowNodes){
                    if([node.name isEqualToString:@"left"]){
                        [node removeAllActions];
                        [self removeChildrenInArray:@[node]];
                        _streakCounter++;
                        [self updateStreakCounterDisplay];
                    }
                }
                NSLog(@"Swiped Left");
            } else if(sender.direction == UISwipeGestureRecognizerDirectionUp){
                for(SKNode *node in arrowNodes){
                    if([node.name isEqualToString:@"up"]){
                        [node removeAllActions];
                        [self removeChildrenInArray:@[node]];
                        _streakCounter++;
                        [self updateStreakCounterDisplay];
                    }
                }
                NSLog(@"Swiped Up");
            } else if(sender.direction == UISwipeGestureRecognizerDirectionRight){
                for(SKNode *node in arrowNodes){
                    if([node.name isEqualToString:@"right"]){
                        [node removeAllActions];
                        [self removeChildrenInArray:@[node]];
                        _streakCounter++;
                        [self updateStreakCounterDisplay];
                    }
                }
                NSLog(@"Swiped Right");
            }
        }
    }
    // check to make sure it's in swipe zone
    // check direction and act accordingly
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
    }
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
        if(firingTime > _nextBeat && (!_resetLoopBeat ||
                                      (_resetLoopBeat && (_resetLoopTime && (CACurrentMediaTime() - _resetLoopTime > [_loopData getNumBeats]-_lastBeat-preBeat)) && firingTime < .5 + [self getFirstBeat]))){
            _resetLoopBeat = NO;
            NSDictionary *beatMap = [_loopData getBeatMap];
            NSArray *beatsToFire = [beatMap objectForKey:[NSNumber numberWithDouble:_nextBeat]];
            for(NSString *instrumentName in beatsToFire){
                [self dropArrow:instrumentName duration:animationDuration];
            }
            _nextBeat = [self getNextBeat:beatMap];// update next beat by iterating through keys
        }
    }
}

- (void)dropArrow:(NSString *)instrumentName duration:(double)animationDuration
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    SKSpriteNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
    [arrow setScale: .15];
    [arrow setPosition:CGPointMake(screenWidth/2, screenHeight + arrow.frame.size.height/2)];
    [self randomlyRotate:arrow];
    [self addChild:arrow];
    arrow.zPosition = -1;
    SKAction *dropArrow = [SKAction moveToY:screenHeight/3 + arrow.frame.size.height/2 duration:animationDuration];
    [arrow runAction:dropArrow completion:^(void){
        SKAction *dropArrow2 = [SKAction moveToY:screenHeight/4 + arrow.frame.size.height/2 duration:animationDuration];
        [arrow runAction:dropArrow2 completion:^(void){
            _streakCounter = 0;
            [self flashRedScreen];
            [self updateStreakCounterDisplay];
            [self removeChildrenInArray:@[arrow]];
        }];
    }];
}

- (void)randomlyRotate:(SKSpriteNode *)nodeToRotate
{
    float randomNum = ((float)rand() / RAND_MAX)*3.99;
    int randomNumber = (int)randomNum;
    switch (randomNumber){
        case 0:
            [nodeToRotate setName:@"up"];
            break;
        case 1:
            [nodeToRotate setName:@"right"];
            [nodeToRotate setZRotation:(M_PI/2)];
            break;
        case 2:
            [nodeToRotate setName:@"down"];
            [nodeToRotate setZRotation:(M_PI)];
            break;
        case 3:
            [nodeToRotate setName:@"left"];
            [nodeToRotate setZRotation:(3*M_PI/2)];
            break;
        default:
            break;
    }
}

- (void)flashRedScreen
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = CGRectMake(0, 0, screenWidth, screenHeight);
    SKShapeNode *redCover = [SKShapeNode shapeNodeWithRect:rect];
    redCover.fillColor = [SKColor redColor];
    redCover.userInteractionEnabled = NO;
    [self addChild:redCover];
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:.4];
    [redCover runAction:fadeOut completion:^(void){
        [self removeChildrenInArray:@[redCover]];
    }];
}

- (void)updateStreakCounterDisplay
{
    _streakDisplay.text = [NSString stringWithFormat:@"%i", _streakCounter];
}

- (double)getFirstBeat
{
    NSDictionary *beatMap = [_loopData getBeatMap];
    NSArray *sortedKeys = [self sortedBeats:beatMap];
    return ((NSNumber *)sortedKeys[0]).doubleValue;
}

- (double)getNextBeat:(NSDictionary *)beatMap
{
    NSArray *sortedKeys = [self sortedBeats:beatMap];
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

- (NSArray *)sortedBeats:(NSDictionary *)beatMap
{
    NSArray *sortedKeys = [[beatMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *num1 = obj1;
        NSNumber *num2 = obj2;
        if ( num1.doubleValue < num2.doubleValue ) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
    return sortedKeys;
}

@end
