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

+ (UIColor *)slideMenuBackgroundColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor SLIDE_MENU_BACKGROUND_COLOR];
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

+ (UIColor *)textColorLightBrownColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor LIGHT_BROWN_COLOR];
    return color;
}

+ (UIColor *)textColorDarkYellowColor{
    static UIColor *color=nil;
    if (!color) color = [UIColor DARK_YELLOW_COLOR];
    return color;
}

+ (UIColor *)slideMenuBackgroundColorRow1{
    static UIColor *color=nil;
    if (!color) color = [UIColor SLIDE_COLOR_ROW_1];
    return color;
}

+ (UIColor *)slideMenuBackgroundColorRow2{
    static UIColor *color=nil;
    if (!color) color = [UIColor SLIDE_COLOR_ROW_2];
    return color;
}

+ (UIColor *)slideMenuBackgroundColorRow3{
    static UIColor *color=nil;
    if (!color) color = [UIColor SLIDE_COLOR_ROW_3];
    return color;
}

+ (UIColor *)slideMenuBackgroundColorRow4{
    static UIColor *color=nil;
    if (!color) color = [UIColor SLIDE_COLOR_ROW_4];
    return color;
}

+ (UIColor *)slideMenuBackgroundColorRow5{
    static UIColor *color=nil;
    if (!color) color = [UIColor SLIDE_COLOR_ROW_5];
    return color;
}

+ (UIColor *)slideMenuBackgroundColorRow6{
    static UIColor *color=nil;
    if (!color) color = [UIColor SLIDE_COLOR_ROW_6];
    return color;
}

+ (UIColor *)slideMenuBackgroundColorRow7{
    static UIColor *color=nil;
    if (!color) color = [UIColor SLIDE_COLOR_ROW_7];
    return color;
}

@end


