//
//  DrumMachineScene.h
//  
//
//  Created by Ben McK on 4/7/15.
//
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "DrumPadNode.h"
#import "LoopTimeDisplayNode.h"
#import "LoopData.h"
#import "Conductor.h"

@interface DrumMachineScene : SKScene

@property LoopTimeDisplayNode *timeDisplay;
@property Conductor *conductor;
@property LoopData *loopData;

@end
