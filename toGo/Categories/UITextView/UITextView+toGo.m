//
//  UITextView+toGo.m
//  toGo
//
//  Created by Babul Rao on 19/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "UITextView+toGo.h"

@implementation UITextView (toGo)
+(void)roundedCornerTextView:(UITextView *)txtView{
    txtView.layer.cornerRadius = 6.0f;
    txtView.layer.masksToBounds = YES;
}
@end
