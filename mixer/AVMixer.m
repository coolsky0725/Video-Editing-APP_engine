 //
//  AVMixer.m
//  AssertPlayer
//
//  Created by Top1 on 8/16/13.
//  Copyright (c) 2013 Top1. All rights reserved.
//

#import "AVMixer.h"

@implementation AVMixer
+ (NSString *)defaultOutputPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/final_movie.mov", documentsDirectory];
}

- (void)startMixingWithVideoPath:(NSString *)videoPath withAudioPath:(NSString *)audioPath
{
    [self startMixingWithVideoURL:[NSURL fileURLWithPath:videoPath] withAudioURL:[NSURL fileURLWithPath:audioPath]];
}

- (void)startMixingWithVideoURL:(NSURL *)videoURL withAudioURL:(NSURL *)audioURL
{
    [self stopMixing];
    
    
    [NSThread sleepForTimeInterval:1];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    //Get min duraion
    CMTime assetDuration = CMTimeMinimum(videoAsset.duration, audioAsset.duration);
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    
    //Add audio track
    
//    NSArray *array1=[audioAsset tracksWithMediaType:AVMediaTypeAudio];
    if ([[audioAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0)
    {
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, assetDuration)
                                       ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                        atTime:kCMTimeZero error:nil];
    }

    //Add video track
//    NSArray* arry = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    
    if ([[videoAsset tracksWithMediaType:AVMediaTypeVideo] count] > 0)
    {
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, assetDuration)
                                       ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                        atTime:kCMTimeZero error:nil];
    }
    
    
    
    
    //Create exporter
    NSString *exportPath = [AVMixer defaultOutputPath];
    NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }

    _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                    presetName:AVAssetExportPresetPassthrough];
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^(void ) {
         // your completion code here
        [self.delegate mixDidFinished:self];
    }];
}

- (void)stopMixing
{
    [_assetExport cancelExport];
    _assetExport = nil;
}
@end
