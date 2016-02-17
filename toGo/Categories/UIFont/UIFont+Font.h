//
//  UIFont+Font.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface UIFont (Font)

+ (UIFont *) boldFontWithSize:(CGFloat) fontSize;
+ (UIFont *) fontWithSize:(CGFloat) fontSize;
+ (UIFont *) thinFontWithSize:(CGFloat) fontSize;
+ (UIFont *) lightFontWithSize:(CGFloat) fontSize;

+ (UIFont *) hugeBold;
+ (UIFont *) largerBold;
+ (UIFont *) largeBold;
+ (UIFont *) normalBold;
+ (UIFont *) smallBold;
+ (UIFont *) smallerBold;
+ (UIFont *) tinyBold;
+ (UIFont *) largeTextBold;
+ (UIFont *) normalTextBold;
+ (UIFont *) largerTextBold;
+ (UIFont *) smallBig;

+ (UIFont *) huge;
+ (UIFont *) larger;
+ (UIFont *) large;
+ (UIFont *) normal;
+ (UIFont *) small;
+ (UIFont *) smaller;
+ (UIFont *) tiny;
+ (UIFont *) largeSize;
+ (UIFont *) normalSize;
+ (UIFont *) hugeText ;


+ (UIFont *) normalSizeThin;
+ (UIFont *) normalThin;
+ (UIFont *) smallThin;
+ (UIFont *) smallerThin;
+ (UIFont *) tinyThin;
+ (UIFont *) largerThin;
+ (UIFont *) largeSizeThin;

@end
