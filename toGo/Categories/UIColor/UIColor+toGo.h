//
//  UIColor+toGo.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAVIGATION_BAR_COLOR colorWithRed:224.0/255.0 green:147.0/255.0 blue:40.0/255.0 alpha:1.0
#define BUTTON_BACKGROUND_COLOR colorWithRed:157.0/255.0 green:122.0/255.0 blue:84.0/255.0 alpha:1.0
#define BACKGROUND_COLOR colorWithRed:226.0/255.0 green:223.0/255.0 blue:217.0/255.0 alpha:1.0
#define SLIDE_MENU_BACKGROUND_COLOR colorWithRed:224.0/255.0 green:147.0/255.0 blue:40.0/255.0 alpha:1.0
#define LIGHT_GRAY_COLOR colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0
#define BLUE_COLOR colorWithRed:121.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1.0
#define DARK_BACKGROUND_COLOR colorWithRed:190.0/255.0 green:179.0/255.0 blue:155.0/255.0 alpha:1.0
#define TEXT_BLACK_COLOR colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0
#define TEXT_WHITE_COLOR colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0


#define SLIDE_COLOR_ROW_1 colorWithRed:180.0/255.0 green:149.0/255.0 blue:110.0/255.0 alpha:1.0
#define SLIDE_COLOR_ROW_2 colorWithRed:157.0/255.0 green:124.0/255.0 blue:83.0/255.0 alpha:1.0
#define SLIDE_COLOR_ROW_3 colorWithRed:172.0/255.0 green:112.0/255.0 blue:32.0/255.0 alpha:1.0
#define SLIDE_COLOR_ROW_4 colorWithRed:205.0/255.0 green:135.0/255.0 blue:40.0/255.0 alpha:1.0
#define SLIDE_COLOR_ROW_5 colorWithRed:213.0/255.0 green:152.0/255.0 blue:53.0/255.0 alpha:1.0
#define SLIDE_COLOR_ROW_6 colorWithRed:229.0/255.0 green:171.0/255.0 blue:68.0/255.0 alpha:1.0

@interface UIColor (toGo)
+ (UIColor *)navigationBarColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)slideMenuBackgroundColor;
+ (UIColor *)buttonBackgroundColor;
+ (UIColor *)lightGrayConnectWithColor;
+ (UIColor *)blueSignUpColor;
+ (UIColor *)darkBackgroundColor;
+ (UIColor *)textColorBlackColor;
+ (UIColor *)textColorWhiteColor;

+ (UIColor *)slideMenuBackgroundColorRow1;
+ (UIColor *)slideMenuBackgroundColorRow2;
+ (UIColor *)slideMenuBackgroundColorRow3;
+ (UIColor *)slideMenuBackgroundColorRow4;
+ (UIColor *)slideMenuBackgroundColorRow5;
+ (UIColor *)slideMenuBackgroundColorRow6;
@end
