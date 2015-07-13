//
//  UIImage+RGSinitWithColor.m
//  ChatWith
//
//  Created by PC on 10/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "UIImage+RGSinitWithColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (RGSinitWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    // create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
