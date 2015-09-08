//
//  Circle.m
//  DrawTest
//
//  Created by xiangmi on 5/25/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#import "Circle.h"
#include "CGUtils.h"

@implementation Circle
- (id)init
{
    self = [super init];
    if (self)
    {
        self.shapeType = DRAWING_TOOL_CIRCLE;
        self.centerPt = CGPointZero;
        self.radius = 0.0f;
    }
    
    return self;
}

- (float)distanceFromPt:(CGPoint)pt
{
    CGFloat distance = distanceBetween2Points(self.centerPt, pt);
    if (distance > self.radius + kDistanceLimit)
        return FLT_MAX;
    
    return distance;
}

- (BOOL)IsTappedDeleteCtrlPt:(CGPoint)pt
{
    return isEqualPoint(self.centerPt, pt, kCtrlPtRadius);
}
@end
