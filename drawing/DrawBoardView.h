//
//  DrawBoardView.h
//  DrawTest
//
//  Created by xiangmi on 5/25/13.
//  Copyright (c) 2013 xiangmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Shape.h"

#define kDrawingColorKey               @"DRAWING_COLOR"
#define kDrawingShapeKey               @"DRAWING_SHAPE"

@class DrawBoardView;

@protocol DrawBoardViewDeleate <NSObject>
@optional
- (void)drawBoardViewPropertyChanged:(DrawBoardView *)aDrawBoardView withInfo:(NSDictionary *)dictionary;
@end

@interface DrawBoardView : UIView
{
    CALayer *               mCtrlLayer;
    
	CGPoint                 mFirstPt;
	CGPoint                 mLastPt;
    
    Shape *                 mCandShape;
    Shape *                 mTempShape;
    NSMutableArray *        mShapeList;
    
    EDIT_MODE               mEditMode;
    BOOL                    mTempIsCandi;
    BOOL                    mIsDeletable;
    
    DRAWING_TOOL            mShapeType;
    DRAWING_COLOR           mShapeColorType;
    UIColor *               mShapeColor;
    
    BOOL bStartPortrait;
}

@property(nonatomic, weak) id<DrawBoardViewDeleate> delegate;
@property(nonatomic, assign) BOOL bPortrait;
@property(nonatomic, assign) BOOL bIsPinch;

- (void)setupCtrlLayer:(id)delegate;
- (void)drawShapesOnBoard:(CGContextRef)context;
- (void)drawShapeCtrlsOnBoard:(CGContextRef)context;

- (void)setShapeType:(DRAWING_TOOL)shapeType;
- (void)setShapeColor:(DRAWING_COLOR)shapeColor;

- (void)toggleDeletable;
- (BOOL)isDeletable;
- (void)clearBoard;
- (void)finishDraw;

@end
