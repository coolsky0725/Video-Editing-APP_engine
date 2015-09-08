//
//  Arrow.m
//  vaton_coach
//
//  Created by kjs on 4/24/14.
//  Copyright (c) 2014 kjs. All rights reserved.
//

#import "Arrow.h"
#include "CGUtils.h"

@implementation Arrow

- (id)init
{
    self = [super init];
    if (self)
    {
        self.shapeType = DRAWING_TOOL_ARROW;
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
