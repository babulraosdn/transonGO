//
//  UITextField+toGo.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "UITextField+toGo.h"

@implementation UITextField (toGo)
+(void)roundedCornerTEXTFIELD:(UITextField *)txtField{
    txtField.layer.cornerRadius = 6.0f;
    txtField.layer.masksToBounds = YES;
}
@end
