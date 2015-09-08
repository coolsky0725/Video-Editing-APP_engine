//
//  CGUtils.h
//  DrawTest
//
//  Created by Zhemin Yin on 5/25/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#ifndef DrawTest_CGUtils_h
#define DrawTest_CGUtils_h

#include <CoreGraphics/CoreGraphics.h>

CGFloat distanceBetween2Points(CGPoint pt1, CGPoint pt2);
int isEqualPoint(CGPoint pt1, CGPoint pt2, CGFloat delta);
CGFloat distanceFromPointToLine(CGPoint pt, CGPoint lineStartPt, CGPoint lineEndPt);

#endif
