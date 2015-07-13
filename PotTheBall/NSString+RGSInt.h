//
//  NSString+RGSInt.h
//  PotTheBall
//
//  Created by PC on 6/28/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* NSStringFromInt(int num)
{
    return [NSString stringWithFormat:@"%d", num];
    
}

@interface NSString (RGSInt)

@end
