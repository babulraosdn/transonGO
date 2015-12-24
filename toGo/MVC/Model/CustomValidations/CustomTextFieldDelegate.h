//
//  CustomTextFieldDelegate.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Utility.h"
#import "NSString+Extensions.h"


@interface CustomTextFieldDelegate : NSObject <UITextFieldDelegate>
@property (nonatomic, weak) id owner;
@property (nonatomic, assign) SEL selector;
@end
