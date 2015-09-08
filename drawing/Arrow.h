//
//  Arrow.h
//  vaton_coach
//
//  Created by kjs on 4/24/14.
//  Copyright (c) 2014 kjs. All rights reserved.
//

#import "Shape.h"

@interface Arrow : Shape
{
    NSMutableArray *mPointList;
}

- (void)addPoint:(CGPoint)pt;
- (CGPoint)pointAtIndex:(int)index;
- (int)pointCount;

@end
