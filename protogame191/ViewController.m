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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SKView *view = (SKView *)self.view;
    view.frameInterval = 2;
    DrumMachineScene *drumScene = [[DrumMachineScene alloc] initWithSize:self.view.frame.size];
    [view presentScene:drumScene];
    
    LoopData *data = [[LoopData alloc] initWithDataFile:@"drum_simple_data"];
    NSLog(@"%@", [data getFilename]);
    NSLog(@"%@", [data getFiletype]);
    NSLog(@"%i", [data getBPM]);
    NSLog(@"%i", [data getNumBeats]);
    NSArray *instrumentNames = [data getInstrumentNames];
    for (NSString *instrumentName in instrumentNames) {
        NSLog(@"%@: %@", instrumentName, [data getBeatValuesForInstrument:instrumentName]);
    }
    
    Conductor *conductor = [[Conductor alloc] initWithLoopData:data];
    [conductor start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
