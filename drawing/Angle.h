//
//  Angle.h
//  DrawTest
//
//  Created by Zhemin Yin on 5/26/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#import "Shape.h"

@interface Angle : Shape

@property(nonatomic) CGPoint centerPt;
@property(nonatomic) CGPoint startPt;
@property(nonatomic) CGPoint endPt;
@property(nonatomic, readonly) int valueMul10;

- (void)calcValue;

@end
