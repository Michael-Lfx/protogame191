//
//  ViewController.m
//  protogame191
//
//  Created by Henry Thiemann on 4/7/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import "ViewController.h"
#import "DrumMachineScene.h"
#import "LoopData.h"
#import "Conductor.h"
#import "SongSliderScene.h"
#import "SongTrainScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SKView *view = (SKView *)self.view;
    view.frameInterval = 2;
//    DrumMachineScene *drumScene = [[DrumMachineScene alloc] initWithSize:self.view.frame.size];
    SongSliderScene *sliderScene = [[SongSliderScene alloc] initWithSize:self.view.frame.size];
    SongTrainScene *trainScene = [[SongTrainScene alloc] initWithSize:self.view.frame.size];
    [view presentScene:trainScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
