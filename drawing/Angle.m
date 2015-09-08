//
//  Angle.m
//  DrawTest
//
//  Created by Zhemin Yin on 5/26/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#import "Angle.h"
#include "CGUtils.h"

@implementation Angle
- (id)init
{
    self = [super init];
    if (self) {
        self.shapeType = DRAWING_TOOL_ANGLE;
        self.centerPt = CGPointZero;
        self.startPt = CGPointZero;
        self.endPt = CGPointZero;
        _valueMul10 = 0;
    }
    
    return self;
}

- (float)distanceFromPt:(CGPoint)pt
{
    CGFloat distance1 = distanceFromPointToLine(pt, self.startPt, self.centerPt);
    CGFloat distance2 = distanceFromPointToLine(pt, self.endPt, self.centerPt);
    CGFloat distance = MIN(distance1, distance2);
    
    if (distance > kDistanceLimit)
        distance = FLT_MAX;
    
    return distance;
}

- (BOOL)IsTappedDeleteCtrlPt:(CGPoint)pt
{
    return isEqualPoint(self.centerPt, pt, kCtrlPtRadius);
}

- (void)calcValue
{
    CGPoint CS = CGPointMake(self.startPt.x -  self.centerPt.x, self.startPt.y -  self.centerPt.y);
    CGPoint CE = CGPointMake(self.endPt.x -  self.centerPt.x, self.endPt.y -  self.centerPt.y);
    
    CGFloat dCSCE = sqrtf((CS.x * CS.x + CS.y * CS.y) * (CE.x * CE.x + CE.y * CE.y));
    CGFloat sCSCE = CS.x * CE.x + CS.y * CE.y;
    
    
    if (dCSCE < 0.0001f)
    {
        _valueMul10 = 0;
    } else {
        float fValueMul10 = acosf(sCSCE / dCSCE) * 1800 / M_PI;
        _valueMul10 = (int)roundf(fValueMul10);
    }
}
@end
