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
@property(nonatomic) AEAudioUnitFilter *testEQ;

@end

@implementation Conductor

long frameSize = 256;

void timingCallback(__unsafe_unretained id receiver, __unsafe_unretained AEAudioController *audioController, const AudioTimeStamp *time, UInt32 frames, AEAudioTimingContext context) {
    if (context != AEAudioTimingContextOutput) return;
    
}

- (AEAudioControllerTimingCallback)timingReceiverCallback {
    return &timingCallback;
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
        
        _testEQ = [[AEAudioUnitFilter alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Effect, kAudioUnitSubType_NBandEQ) audioController:_audioController error:NULL];
        
        UInt32 numBands = 5;
        TOThrowOnError(AudioUnitSetProperty(_testEQ.audioUnit,
                                            kAUNBandEQProperty_NumberOfBands,
                                            kAudioUnitScope_Global,
                                            0,
                                            &numBands,
                                            sizeof(numBands)));
        
        NSArray *bands = [[NSArray alloc] initWithObjects:
                          [NSNumber numberWithFloat:63.6],
                          [NSNumber numberWithFloat:133.0],
                          [NSNumber numberWithFloat:324.0],
                          [NSNumber numberWithFloat:2060.0],
                          [NSNumber numberWithFloat:10030.0],
                          nil];
        
        for (int i = 0; i < bands.count; i++) {
            TOThrowOnError(AudioUnitSetParameter(_testEQ.audioUnit,
                                                 kAUNBandEQParam_Frequency+i,
                                                 kAudioUnitScope_Global,
                                                 0,
                                                 (AudioUnitParameterValue)[[bands objectAtIndex:i] floatValue],
                                                 0));
            
            TOThrowOnError(AudioUnitSetParameter(_testEQ.audioUnit,
                                                 kAUNBandEQParam_BypassBand+i,
                                                 kAudioUnitScope_Global,
                                                 0,
                                                 0,
                                                 0));
            
            TOThrowOnError(AudioUnitSetParameter(_testEQ.audioUnit,
                                                 kAUNBandEQParam_Bandwidth+i,
                                                 kAudioUnitScope_Global,
                                                 0,
                                                 0.05,
                                                 0));
        }
        
        TOThrowOnError(AudioUnitSetParameter(_testEQ.audioUnit,
                                             kAUNBandEQParam_Gain,
                                             kAudioUnitScope_Global,
                                             0,
                                             (AudioUnitParameterValue)16,
                                             0));
        
        TOThrowOnError(AudioUnitSetParameter(_testEQ.audioUnit,
                                             kAUNBandEQParam_Gain+1,
                                             kAudioUnitScope_Global,
                                             0,
                                             (AudioUnitParameterValue)-96,
                                             0));
        
        TOThrowOnError(AudioUnitSetParameter(_testEQ.audioUnit,
                                             kAUNBandEQParam_Gain+2,
                                             kAudioUnitScope_Global,
                                             0,
                                             (AudioUnitParameterValue)-96,
                                             0));
        
        TOThrowOnError(AudioUnitSetParameter(_testEQ.audioUnit,
                                             kAUNBandEQParam_Gain+3,
                                             kAudioUnitScope_Global,
                                             0,
                                             (AudioUnitParameterValue)-96,
                                             0));
        
        TOThrowOnError(AudioUnitSetParameter(_testEQ.audioUnit,
                                             kAUNBandEQParam_Gain+4,
                                             kAudioUnitScope_Global,
                                             0,
                                             (AudioUnitParameterValue)-96,
                                             0));
        
    }
    
    return self;
}

void TOThrowOnError(OSStatus status)
{
    if (status != noErr) {
        @throw [NSException exceptionWithName:@"TOAudioErrorException"
                                       reason:[NSString stringWithFormat:@"Status is not 'noErr'! Status is %ld).", (long)status]
                                     userInfo:nil];
    }
}

- (void)start {
    [_audioController addTimingReceiver:self];
    [_audioController addChannels:[NSArray arrayWithObject:_audioFilePlayer]];
    [_audioController addFilter:_testEQ];
}

- (void)stop {
    [_audioController removeTimingReceiver:self];
    [_audioController removeChannels:[NSArray arrayWithObject:_audioFilePlayer]];
}

@end
