//
//  UIView+RGSFrame.h
//  ChatWith
//
//  Created by PC on 1/8/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RGSFrame)

-(void)setFrameSizeWidth:(float)width;
-(void)setFrameSizeHeight:(float)height;
-(void)setFrameOriginX:(float)x;
-(void)setFrameOriginY:(float)y;

-(void)setFrameOrigin:(CGPoint)point;
-(void)setFrameSize:(CGSize)size;


@end
