//
//  UIImage+RGSinitWithColor.h
//  ChatWith
//
//  Created by PC on 10/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RGSinitWithColor)

//http://stackoverflow.com/questions/17460209/change-the-alpha-value-of-the-navigation-bar#17542389
//programmatically create an UIImage with 1 pixel of a given color
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
