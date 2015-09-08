//
//  LayerRecorder.m
//  RecordMyApp
//
//  Created by Zhemin Yin on 5/27/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import "LayerRecorder.h"

#define TIME_SCALE NSEC_PER_SEC
#define FRAME_RATE 24.0

@implementation LayerRecorder

- (id)init
{
    self = [super init];
    if (self)
    {
        mLayer = NULL;
        mOutputPath = [[NSString alloc] initWithString:[LayerRecorder defaultOutputPath]];
    }
    
    return self;
}

- (id)initWithLayer:(CALayer *)aLayer withOutputVideoPath:(NSString *)outputPath
{
    self = [super init];
    if (self)
    {
        mLayer = aLayer;
        mOutputPath = [[NSString alloc] initWithString:outputPath];
    }
    
    return self;
}

- (void)initialize
{
    mVideoWidth = 0;
    mVideoHeight = 0;
    
    CGSize videoSize = [self calcVideoSize];
    mVideoWidth = (int)videoSize.width;
    mVideoHeight = (int)videoSize.height;
    
}

#pragma mark - Output Path
+ (NSString *)defaultOutputPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/screen_record.mov", documentsDirectory];
}

#pragma mark - Internal Utils
- (CGSize)calcVideoSize
{
    CGSize videoSize = CGSizeZero;
    
    if (mLayer.frame.size.width > videoSize.width)
        videoSize.width = mLayer.frame.size.width;
    
    if (mLayer.frame.size.height > videoSize.height)
        videoSize.height = mLayer.frame.size.height;
    
    return videoSize;
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
{
    
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height,  kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (CGContextRef)createBitmapContextOfSize:(CGSize)size {
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	bitmapBytesPerRow   = (size.width * 4);
	bitmapByteCount     = (bitmapBytesPerRow * size.height);
	colorSpace = CGColorSpaceCreateDeviceRGB();

	context = CGBitmapContextCreate (NULL,
									 size.width,
									 size.height,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaNoneSkipFirst/*kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little*/);
	
	CGContextSetAllowsAntialiasing(context,NO);
	if (context== NULL) {
		return NULL;
	}
	CGColorSpaceRelease( colorSpace );
	
	return context;
}

- (CGImageRef)cgImageOfLayer:(CALayer *)aLayer
{
    CGContextRef context = [self createBitmapContextOfSize:aLayer.frame.size];

    if (mVideoPlayerView) {
//        float angle = -45 / 180.0 * M_PI;
//        CGContextTranslateCTM(context, -mVideoWidth / 2.0f, -mVideoHeight / 2.0);
//        CGContextRotateCTM(context, angle);
//        CGContextTranslateCTM(context, mVideoWidth / 2.0f, mVideoHeight / 2.0);
//        CGAffineTransform rotate90 = CGAffineTransformMake(cosf(angle), sinf(angle), -sinf(angle), cosf(angle), 0, 0);
//        CGContextConcatCTM(context, rotate90);
//        
//        CGImageRef videoImage = [mVideoPlayerView getCurrentFrame];
//        
//        int a = CGImageGetWidth(videoImage);
//        CGContextDrawImage(context, CGRectMake(0, 0, mVideoWidth, mVideoHeight), videoImage);
//        CGImageRelease(videoImage);
    }
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, aLayer.frame.size.height);
    CGContextConcatCTM(context, flipVertical);

    [aLayer.presentationLayer renderInContext:context];
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    return cgImage;
}

- (UIImage *)getFrameAsUIImage
{
    CGImageRef cgImage = [self cgImageOfLayer:mLayer];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

- (void)writeFrame:(id)sender
{
	if (mAssetWriterInput.readyForMoreMediaData)
    {
		
		CVReturn cvErr = kCVReturnSuccess;
		
        
		// prepare the pixel buffer
		CVPixelBufferRef pixelBuffer = NULL;
        
		// get screenshot image!
        CGImageRef cgImage = [self cgImageOfLayer:mLayer];
        CGImageRetain(cgImage);
        
        size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
        
		CFDataRef imageData= CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
        CGImageRelease(cgImage);
        
        
        cvErr = CVPixelBufferCreateWithBytes(kCFAllocatorDefault,
											 mVideoWidth,
											 mVideoHeight,
											 kCVPixelFormatType_32ARGB,
											 (void*)CFDataGetBytePtr(imageData),
											 bytesPerRow,
											 NULL,
											 NULL,
											 NULL,
											 &pixelBuffer);
        
		// calculate the time
		CFAbsoluteTime thisFrameWallClockTime = CFAbsoluteTimeGetCurrent();
		CFTimeInterval elapsedTime = thisFrameWallClockTime - mFirstFrameWallClockTime;
//		NSLog (@"elapsedTime: %f", elapsedTime);
		CMTime presentationTime =  CMTimeMake (elapsedTime * TIME_SCALE, TIME_SCALE);

		// write the sample
		BOOL appended = [mAssetWriterPixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentationTime];

		if (appended) {
//			NSLog (@"appended sample at time %lf", CMTimeGetSeconds(presentationTime));
		} else {
//			NSLog (@"failed to append");
			[self stopRecording];
		}

        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0) ;
        CVPixelBufferRelease(pixelBuffer);
        
        
        
        CFRelease(imageData);
        
    } else {
        [self stopRecording];
    }
}

#pragma mark - Interface
- (void)setLayer:(CALayer *)aLayer
{
    mLayer = aLayer;
}

- (void)setVideoPlayerView:(AVPlayerView *)aView
{
    mVideoPlayerView = aView;
}

- (BOOL)startRecording {
    [self initialize];
    
    if (!mVideoWidth || !mVideoHeight || ![mOutputPath length])
    {
        return NO;
    }
    
	// create the AVAssetWriter
	if ([[NSFileManager defaultManager] fileExistsAtPath:mOutputPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:mOutputPath error:nil];
	}
	
	NSURL *videoURL = [NSURL fileURLWithPath:mOutputPath];
	NSError *videoError = nil;

	mAssetWriter = [[AVAssetWriter alloc] initWithURL:videoURL
                                             fileType:AVFileTypeQuickTimeMovie
                                               error: &videoError];
    
	NSDictionary* videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:
										   [NSNumber numberWithDouble:1024.0*1024.0], AVVideoAverageBitRateKey,
										   nil ];
	
    NSDictionary *assetWriterInputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
											  AVVideoCodecH264, AVVideoCodecKey,
											  [NSNumber numberWithInt:mVideoWidth], AVVideoWidthKey,
											  [NSNumber numberWithInt:mVideoHeight], AVVideoHeightKey,
                                              videoCompressionProps, AVVideoCompressionPropertiesKey,
											  nil];
    
	mAssetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeVideo
                                                           outputSettings:assetWriterInputSettings];
	mAssetWriterInput.expectsMediaDataInRealTime = YES;
    
	[mAssetWriter addInput:mAssetWriterInput];

	NSDictionary* bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
	mAssetWriterPixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:mAssetWriterInput sourcePixelBufferAttributes:bufferAttributes];
    
	[mAssetWriter startWriting];
	mFirstFrameWallClockTime = CFAbsoluteTimeGetCurrent();
	[mAssetWriter startSessionAtSourceTime: CMTimeMake(0, TIME_SCALE)];
    
	
	// start writing samples to it
	mAssetWriterTimer = [NSTimer scheduledTimerWithTimeInterval:1 / FRAME_RATE
														target:self
													  selector:@selector(writeFrame:)
													  userInfo:nil
													   repeats:YES];

    return YES;
}


- (void)stopRecording {
    if (mAssetWriterTimer)
    {
        [mAssetWriterTimer invalidate];
        mAssetWriterTimer = nil;
	}
    
    if (mAssetWriterInput)
    {
        [mAssetWriterInput markAsFinished];
        int status = (int)mAssetWriter.status;
        while (status == AVAssetWriterStatusUnknown) {
            [NSThread sleepForTimeInterval:0.2];
            status = (int)mAssetWriter.status;
        }
        mAssetWriterInput = nil;
    }
    
    if (mAssetWriter)
    {
        [mAssetWriter finishWritingWithCompletionHandler: ^()
        {
            mAssetWriterPixelBufferAdaptor = nil;
            mAssetWriterInput = nil;
            mAssetWriter = nil;
        }];
    }
}

@end
