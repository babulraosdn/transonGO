//
//  UIImage+Image.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

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

+ (UIImage *)navigationBarImage{
    static UIImage *image=nil;
    if (!image) image = [UIImage imageNamed:NAVIGATION_BAR];
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
