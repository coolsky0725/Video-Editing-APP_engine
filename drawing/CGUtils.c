//
//  CGUtils.c
//  DrawTest
//
//  Created by Zhemin Yin on 5/25/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#include <stdio.h>
#include "CGUtils.h"

CGFloat distanceBetween2Points(CGPoint pt1, CGPoint pt2)
{
    return (CGFloat)sqrtf((pt2.x - pt1.x) * (pt2.x - pt1.x) + (pt2.y - pt1.y) * (pt2.y - pt1.y));
}

int isEqualPoint(CGPoint pt1, CGPoint pt2, CGFloat delta)
{
    if (distanceBetween2Points(pt1, pt2) < delta*2)
        return 1;
    
    return 0;
}

CGFloat distanceFromPointToLine(CGPoint pt, CGPoint lineStartPt, CGPoint lineEndPt)
{
    //Assumed Line is ax + by + c = 0
    CGFloat a = lineEndPt.y - lineStartPt.y;
    CGFloat b = -(lineEndPt.x - lineStartPt.x);
    CGFloat c = - a * lineStartPt.x - b * lineStartPt.y;
    
    CGFloat distance = (CGFloat)(fabsf(a * pt.x + b * pt.y + c) / sqrtf(a * a + b * b));
    return distance;
}