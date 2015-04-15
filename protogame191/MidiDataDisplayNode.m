//
//  MidiDataDisplayNode.m
//  protogame191
//
//  Created by Ben McK on 4/14/15.
//  Copyright (c) 2015 Henry Thiemann. All rights reserved.
//

#import "MidiDataDisplayNode.h"

@implementation MidiDataDisplayNode

-(instancetype) init{
    self = [super init];
    
    if (self) {
        self.fillColor = [SKColor blueColor];
        self.alpha = .7;
    }
    
    return self;
}

- (void)initWithInfo:(LoopData *)loopData{
    _loopData = loopData;
    [self buildRows];
    [self buildMeasures];
    [self insertNotes];
}

- (void)buildRows{
    int numInstruments = [_loopData getInstrumentNames].count;
    for(int i=1; i<numInstruments; i++){
        CGFloat dividerLineY = self.frame.size.height * i / numInstruments;
        CGRect line = CGRectMake(0, dividerLineY, self.frame.size.width, .2);
        [self addDividerLineWithRect:line alpha:.5];
    }
}

- (void)buildMeasures{
    int numMeasures = [_loopData getNumBeats]/4;
    for (int i=1; i<numMeasures; i++){
        CGFloat dividerLineX = self.frame.size.width * i / numMeasures;
        CGRect line = CGRectMake(dividerLineX, 0, .5, self.frame.size.height);
        [self addDividerLineWithRect:line alpha:1];
    }
}

- (void)addDividerLineWithRect:(CGRect) rect alpha:(float)alpha{
    SKShapeNode *dividerLine = [SKShapeNode shapeNodeWithRect:rect];
    dividerLine.fillColor = [SKColor grayColor];
    dividerLine.strokeColor = [SKColor grayColor];
    dividerLine.alpha = alpha;
    [self addChild:dividerLine];
}

- (void)insertNotes{
    for(NSString *name in [_loopData getInstrumentNames]){
        NSArray *beats = [_loopData getBeatValuesForInstrument:name];
        for(NSNumber *beat in beats){
            [self addNoteAtBeat:beat forInstrument:name color:[SKColor grayColor]];
        }
    }
}

- (void)addNoteAtBeat:(NSNumber *)beat forInstrument:(NSString *)name color:(SKColor*)noteColor{
    float beatValue = beat.floatValue;
    int numInstruments = [_loopData getInstrumentNames].count;
    int row = [[_loopData getInstrumentNames] indexOfObject:name];
    float beatYOrigin = (self.frame.size.height * row / numInstruments) + 10;
    float beatXOrigin = self.frame.size.width * beatValue / [_loopData getNumBeats];
    CGRect rect = CGRectMake(beatXOrigin, beatYOrigin, 10, 5);
    SKShapeNode *note = [SKShapeNode shapeNodeWithRect:rect cornerRadius:3];
    note.fillColor = noteColor;
    note.strokeColor = noteColor;
    [self addChild:note];
}

-(void)addUserMidiNote:(NSString *)instrument atBeat:(double)beatHit correct:(BOOL)correct{
    SKColor *correctColor = correct ? [SKColor greenColor] : [SKColor redColor];
    [self addNoteAtBeat:[NSNumber numberWithDouble:beatHit] forInstrument:instrument color:correctColor];
}

@end
