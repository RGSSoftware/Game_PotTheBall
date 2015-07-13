//
//  UIColor+RGScolorwithHexString.h
//  ChatWith
//
//  Created by PC on 10/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGSColorWithHexString)


//uicolor from hex string with alphe - technique
//supports string values that may include '0x' or '#' prefix
//http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string#19072934
+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexStr;

@end
