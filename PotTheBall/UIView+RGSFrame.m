//
//  UIView+RGSFrame.m
//  ChatWith
//
//  Created by PC on 1/8/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "UIView+RGSFrame.h"

@implementation UIView (RGSFrame)
-(void)setFrameSizeWidth:(float)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
-(void)setFrameSizeHeight:(float)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
-(void)setFrameOriginX:(float)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
-(void)setFrameOriginY:(float)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
-(void)setFrameOrigin:(CGPoint)point{
    CGRect rect = self.frame;
    rect.origin = point;
    self.frame = rect;
}
-(void)setFrameSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

@end
