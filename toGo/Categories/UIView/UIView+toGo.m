//
//  UIView+toGo.m
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "UIView+toGo.h"

@implementation UIView (toGo)
+(void)roundedCornerView:(UIView *)view{
    view.layer.cornerRadius = 6.0f;
    view.layer.masksToBounds = YES;
}
@end
