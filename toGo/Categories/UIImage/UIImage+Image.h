//
//  UIImage+Image.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

#define CHECK_BOX_CHEKE @"checked"
#define CHECK_BOX_UNCHEKE @"check"
#define NAVIGATION_BAR @"screenBg"
#define RADIO_OFF @"unselect_iPhone"
#define RADIO_ON @"select_iPhone"
#define DEFAULT_PIC DEFAULT_PIC_IMAGE
#define EDIT_IMAGE EDIT_PEN_IMAGE


@interface UIImage (Image)
+ (UIImage *)navigationBarImage;
+ (UIImage *)checkedBoxImage;
+ (UIImage *)uncheckBoxImage;
+ (UIImage *)radioOffImage;
+ (UIImage *)radioONImage;
+ (UIImage *)switchOffImage;
+ (UIImage *)switchONImage;
+ (UIImage *)defaultPicImage;
+ (UIImage *)editImage;
+ (UIImage *)lightButtonImage;
+ (UIImage *)closeLanguagesImage;
+ (UIImage *)setColor:(UIColor *)color frame:(CGRect)frame;
@end
