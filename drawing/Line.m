//
//  Line.m
//  DrawTest
//
//  Created by Zhemin Yin on 5/25/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#import "Line.h"
#include "CGUtils.h"

@implementation Line
- (id)init
{
    self = [super init];
    if (self)
    {
        self.shapeType = DRAWING_TOOL_LINE;
        self.startPt = CGPointZero;
        self.endPt = CGPointZero;
    }
    
    return self;
}

- (float)distanceFromPt:(CGPoint)pt
{
    CGFloat distance = distanceFromPointToLine(pt, self.startPt, self.endPt);
    
    if (distance > kDistanceLimit)
    {
        distance = FLT_MAX;
    } else if ((self.startPt.x - kDistanceLimit > pt.x || pt.x > self.endPt.x + kDistanceLimit) || (self.startPt.y - kDistanceLimit > pt.y || pt.y > self.endPt.y + kDistanceLimit)) {
        distance = FLT_MAX;
    }
    
    return distance;
}

- (BOOL)IsTappedDeleteCtrlPt:(CGPoint)pt
{
    return isEqualPoint(self.startPt, pt, kCtrlPtRadius);
}
@end
