//
//  LayerRecorder.h
//  RecordMyApp
//
//  Created by Zhemin Yin on 5/27/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerView.h"

@interface LayerRecorder : NSObject
{
    CALayer *                                   mLayer;
    AVPlayerView *                              mVideoPlayerView;
    
    NSString *                                  mOutputPath;
    
    int                                         mVideoWidth;
    int                                         mVideoHeight;
    
    NSTimer *                                   mAssetWriterTimer;
	CFAbsoluteTime                              mFirstFrameWallClockTime;
    
	AVAssetWriter *                             mAssetWriter;
	AVAssetWriterInput *                        mAssetWriterInput;
	AVAssetWriterInputPixelBufferAdaptor *      mAssetWriterPixelBufferAdaptor;
}

+ (NSString *)defaultOutputPath;

- (id)initWithLayer:(CALayer *)aLayer withOutputVideoPath:(NSString *)outputPath;
- (void)setLayer:(CALayer *)aLayer;
- (void)setVideoPlayerView:(AVPlayerView *)aView;
- (BOOL)startRecording;
- (void)stopRecording;

@end
