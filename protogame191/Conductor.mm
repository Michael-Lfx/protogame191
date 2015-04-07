//
//  Conductor.m
//  protogame191
//
//  Created by Henry Thiemann on 4/7/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import "Conductor.h"
#import "AppDelegate.h"

@interface Conductor ()

@property(nonatomic) AEAudioController *audioController;

@end

@implementation Conductor

long frameSize = 256;

void timingCallback(__unsafe_unretained id receiver, __unsafe_unretained AEAudioController *audioController, const AudioTimeStamp *time, UInt32 frames, AEAudioTimingContext context) {
    if (context != AEAudioTimingContextOutput) return;
    
}

- (AEAudioControllerTimingCallback)timingReceiverCallback {
    return &timingCallback;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _audioController = delegate.audioController;
        _audioController.preferredBufferDuration = AEConvertFramesToSeconds(_audioController, frameSize);
    }
    
    return self;
}

- (void)start {
    [_audioController addTimingReceiver:self];
}

- (void)stop {
    [_audioController removeTimingReceiver:self];
}

@end
