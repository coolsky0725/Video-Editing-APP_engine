//
//  AVMixer.h
//  AssertPlayer
//
//  Created by Top1 on 8/16/13.
//  Copyright (c) 2013 Top1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVMixer;
@protocol AVMixerDelegate <NSObject>
- (void)mixDidFinished:(AVMixer *)aMixer;
@end

@interface AVMixer : NSObject
{
    AVAssetExportSession*   _assetExport;
    BOOL                    _success;
}

@property(nonatomic, weak) id<AVMixerDelegate> delegate;

+ (NSString *)defaultOutputPath;

- (void)startMixingWithVideoURL:(NSURL *)videoURL withAudioURL:(NSURL *)audioURL;
- (void)startMixingWithVideoPath:(NSString *)videoPath withAudioPath:(NSString *)audioPath;
- (void)stopMixing;
@end
