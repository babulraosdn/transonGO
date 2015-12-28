//
//  UIColor+toGo.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "UIColor+toGo.h"



@implementation UIColor (toGo)

+ (UIColor *)navigationBarColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor NAVIGATION_BAR_COLOR];
    return color;
}

+ (UIColor *)backgroundColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor BACKGROUND_COLOR];
    return color;
}

+ (UIColor *)buttonBackgroundColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor BUTTON_BACKGROUND_COLOR];
    return color;
}

+ (UIColor *)lightGrayConnectWithColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor LIGHT_GRAY_COLOR];
    return color;
}

+ (UIColor *)blueSignUpColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor BLUE_COLOR];
    return color;
}

+ (UIColor *)darkBackgroundColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor DARK_BACKGROUND_COLOR];
    return color;
}

+ (UIColor *)textColorBlackColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor TEXT_BLACK_COLOR];
    return color;
}

+ (UIColor *)textColorWhiteColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor TEXT_WHITE_COLOR];
    return color;
}

@end


