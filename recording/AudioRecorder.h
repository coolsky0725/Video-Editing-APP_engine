//
//  AudioRecorder.h
//  GolfSwingAnalysis
//
//  Created by Top1 on 7/26/13.
//  Copyright (c) 2013 Zhemin Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioRecorder : NSObject
{
    AVAudioRecorder * m_recorder;
}

@property(nonatomic, weak) id<AVAudioRecorderDelegate> delegate;

+ (NSString *)defaultOutputPath;

- (void)startRecording;
- (void)stopRecording;

@end