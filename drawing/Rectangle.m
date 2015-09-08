//
//  Rectangle.m
//  vaton_coach
//
//  Created by kjs on 4/24/14.
//  Copyright (c) 2014 kjs. All rights reserved.
//

#import "Rectangle.h"
#include "CGUtils.h"

@implementation Rectangle

- (id)init
{
    self = [super init];
    if (self)
    {
        self.shapeType = DRAWING_TOOL_RECTANGLE;
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
