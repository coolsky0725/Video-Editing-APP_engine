//
//  FreeDraw.m
//  DrawTest
//
//  Created by Zhemin Yin on 5/26/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#import "FreeDraw.h"
#include "CGUtils.h"

@implementation FreeDraw
- (id)init
{
    self = [super init];
    if (self)
    {
        self.shapeType = DRAWING_TOOL_FREEDRAW;
        mPointList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BOOL)IsTappedDeleteCtrlPt:(CGPoint)pt
{
    return isEqualPoint([self pointAtIndex:0], pt, kCtrlPtRadius);
}

- (void)addPoint:(CGPoint)pt
{
    [mPointList addObject:[NSValue valueWithCGPoint:pt]];
}

- (CGPoint)pointAtIndex:(int)index
{
    return [(NSValue *)[mPointList objectAtIndex:index] CGPointValue];
}

- (int)pointCount
{
    return (int)[mPointList count];
}

@end
