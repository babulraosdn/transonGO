//
//  UIButton+toGo.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "UIButton+toGo.h"

@implementation UIButton (toGo)
+(void)roundedCornerButton:(UIButton *)button{
    button.layer.cornerRadius = 6.0f;
    button.layer.masksToBounds = YES;
}
@end
