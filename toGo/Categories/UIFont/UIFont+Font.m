//
//  UIFont+Font.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "UIFont+Font.h"

@implementation UIFont (Font)



+ (UIFont *) boldFontWithSize:(CGFloat) fontSize {
    UIFont *font;
    
    font = [UIFont fontWithName:KFontFamily_ROBOTO_BOLD size:fontSize];
    
    return font;
}

+ (UIFont *) fontWithSize:(CGFloat) fontSize {
    UIFont *font;
    
    font = [UIFont fontWithName:KFontFamily_ROBOTO_REGULAR size:fontSize];
    
    return font;
}

+ (UIFont *) thinFontWithSize:(CGFloat) fontSize {
    UIFont *font;
    
    font = [UIFont fontWithName:KFontFamily_ROBOTO_THIN size:fontSize];
    
    return font;
}

+ (UIFont *) lightFontWithSize:(CGFloat) fontSize {
    UIFont *font;
    
    font = [UIFont fontWithName:KFontFamily_ROBOTO_LIGHT size:fontSize];
    
    return font;
}


+ (UIFont *) hugeBold {
    return [self boldFontWithSize:26.0];
}

+ (UIFont *) largertextBold {
    return [self boldFontWithSize:20.0];
}


+ (UIFont *) largerBold {
    return [self boldFontWithSize:18.0];
}

+ (UIFont *) largeTextBold {
    return [self boldFontWithSize:17.0];
}

+ (UIFont *) largeBold {
    return [self boldFontWithSize:16.0];
}

+ (UIFont *) normalTextBold{
    return [self boldFontWithSize:15.0];
}

+ (UIFont *) normalBold {
    return [self boldFontWithSize:14.0];
}


+ (UIFont *) smallBold {
    return [self boldFontWithSize:13.0];
}

+ (UIFont *) smallerBold {
    return [self boldFontWithSize:12.0];
}

+ (UIFont *) tinyBold {
    return [self boldFontWithSize:10.0];
}

+ (UIFont *) huge {
    return [self fontWithSize:26.0];
}

+ (UIFont *) hugeText {
    return [self fontWithSize:20.0];
}

+ (UIFont *) larger {
    return [self fontWithSize:18.0];
}

+ (UIFont *) largeSize {
    return [self fontWithSize:17.0];
}

+ (UIFont *) large {
    return [self fontWithSize:16.0];
}

+ (UIFont *) normalSize {
    return [self fontWithSize:15.0];
}

+ (UIFont *) normal {
    return [self fontWithSize:14.0];
}

+ (UIFont *) small {
    return [self fontWithSize:12.66];
}

+ (UIFont *) smallBig {
    return [self fontWithSize:13.5];
}


+ (UIFont *) smaller {
    return [self fontWithSize:11.6];
}

+ (UIFont *) tiny {
    return [self fontWithSize:10.0];
}


//Thin

+ (UIFont *) largerThin {
    return [self thinFontWithSize:18.0];
}

+ (UIFont *) largeSizeThin {
    return [self thinFontWithSize:16.5];
}


+ (UIFont *) normalSizeThin {
    return [self thinFontWithSize:15.0];
}

+ (UIFont *) normalThin {
    return [self thinFontWithSize:14.0];
}

+ (UIFont *) smallThin {
    return [self thinFontWithSize:13.0];
}


+ (UIFont *) smallerThin {
    return [self thinFontWithSize:12.5];
}

+ (UIFont *) tinyThin {
    return [self thinFontWithSize:10.0];
}

@end
