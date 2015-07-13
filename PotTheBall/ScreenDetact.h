//
//  ScreenDetact.h
//  LittleBlackDress
//
//  Created by PC on 6/10/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#ifndef LittleBlackDress_ScreenDetact_h
#define LittleBlackDress_ScreenDetact_h

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD (( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? YES : NO)
#define IS_IPHONE_5 (([UIScreen mainScreen].bounds.size.height == 568)?YES:NO)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#endif
