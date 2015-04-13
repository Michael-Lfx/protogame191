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
@property(nonatomic) AEAudioFilePlayer *audioFilePlayer;

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

- (instancetype)initWithLoopData:(LoopData *)data {
    self = [super init];
    
    if (self) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _audioController = delegate.audioController;
        _audioController.preferredBufferDuration = AEConvertFramesToSeconds(_audioController, frameSize);
        
        NSURL *file = [[NSBundle mainBundle] URLForResource:[data getFilename] withExtension:[data getFiletype]];
        _audioFilePlayer = [AEAudioFilePlayer audioFilePlayerWithURL:file audioController:_audioController error:NULL];
        _audioFilePlayer.loop = true;
    }
    
    return self;
}

- (void)start {
    [_audioController addTimingReceiver:self];
    [_audioController addChannels:[NSArray arrayWithObject:_audioFilePlayer]];
}

- (void)stop {
    [_audioController removeTimingReceiver:self];
    [_audioController removeChannels:[NSArray arrayWithObject:_audioFilePlayer]];
}

- (BOOL)didPlayInstrument:(int)instrumentNumber onBeat:(int)beatValue {
    return false;
}

@end
