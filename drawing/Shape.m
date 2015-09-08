//
//  Shape.m
//  DrawTest
//
//  Created by xiangmi on 5/25/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#import "Shape.h"

@implementation Shape
@synthesize shapeType, isCandi, shapeColor;

- (id)init
{
    self = [super init];
    if (self) {
        self.shapeType = DRAWING_TOOL_NONE;
        self.isCandi = YES;
        self.shapeColorType = DRAWING_COLOR_RED;
        
        self.shapeColor = [UIColor redColor];
    }
    
    return self;
}

- (float)distanceFromPt:(CGPoint)pt
{
    return FLT_MAX;
}

- (BOOL)IsTappedDeleteCtrlPt:(CGPoint)pt
{
    return NO;
}

@end
