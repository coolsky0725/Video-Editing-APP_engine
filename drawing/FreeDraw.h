//
//  FreeDraw.h
//  DrawTest
//
//  Created by Zhemin Yin on 5/26/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#import "Shape.h"

@interface FreeDraw : Shape
{
    NSMutableArray *mPointList;
}

- (void)addPoint:(CGPoint)pt;
- (CGPoint)pointAtIndex:(int)index;
- (int)pointCount;

@end
