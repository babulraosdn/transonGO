//
//  UIImage+Image.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (UIImage *)navigationBarImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:NAVIGATION_BAR];
    return image;
}

+ (UIImage *)checkedBoxImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:CHECK_BOX_CHEKE];
    return image;
}

+ (UIImage *)uncheckBoxImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:CHECK_BOX_UNCHEKE];
    return image;
}

+ (UIImage *)radioOffImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:RADIO_OFF];
    return image;
}

+ (UIImage *)radioONImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:RADIO_ON];
    return image;
}


+ (UIImage *)switchOffImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:SWITCH_OFF_IMAGE];
    return image;
}

+ (UIImage *)switchONImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:SWITCH_ON_IMAGE];
    return image;
}

+ (UIImage *)defaultPicImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:DEFAULT_PIC];
    return image;
}

+ (UIImage *)editImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:EDIT_IMAGE];
    return image;
}

+ (UIImage *)lightButtonImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:LIGHT_BUTTON_IMAGE];
    return image;
}

+ (UIImage *)closeLanguagesImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:CLOSE_LANGUAGES_IMAGE];
    return image;
}


+ (UIImage *)setColor:(UIColor *)color frame:(CGRect)frame{
    UIView *colorView = [[UIView alloc] initWithFrame:frame];
    colorView.backgroundColor = color;
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage;
}

@end
