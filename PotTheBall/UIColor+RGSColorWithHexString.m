//
//  UIColor+RGScolorwithHexString.m
//  ChatWith
//
//  Created by PC on 10/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "UIColor+RGScolorwithHexString.h"

@implementation UIColor (RGSColorWithHexString)

+ (UIColor *)colorWithHexString:(NSString *)hexStr;
{
    return [self colorWithHexString:hexStr alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

+(unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

@end
