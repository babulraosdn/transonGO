//
//  UIColor+toGo.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAVIGATION_BAR_COLOR colorWithRed:224.0/255.0 green:147.0/255.0 blue:40.0/255.0 alpha:1.0
#define BUTTON_BACKGROUND_COLOR colorWithRed:157.0/255.0 green:122.0/255.0 blue:87.0/255.0 alpha:1.0
#define BACKGROUND_COLOR colorWithRed:226.0/255.0 green:223.0/255.0 blue:217.0/255.0 alpha:1.0
#define LIGHT_GRAY_COLOR colorWithRed:147.0/255.0 green:146.0/255.0 blue:140.0/255.0 alpha:1.0
#define BLUE_COLOR colorWithRed:121.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1.0
#define DARK_BACKGROUND_COLOR colorWithRed:190.0/255.0 green:179.0/255.0 blue:155.0/255.0 alpha:1.0


@interface UIColor (toGo)
+ (UIColor *)navigationBarColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)buttonBackgroundColor;
+ (UIColor *)lightGrayConnectWithColor;
+ (UIColor *)blueSignUpColor;
+ (UIColor *)darkBackgroundColor;
@end
