//
//  CustomTextFieldDelegate.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "CustomTextFieldDelegate.h"

@implementation CustomTextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
 
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder && textField.returnKeyType == UIReturnKeyNext) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        if ([textField.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrview = (UIScrollView *) textField.superview;
            [scrview setContentOffset:CGPointZero animated:YES];
        }
        if (textField.returnKeyType == UIReturnKeyGo) {
            if ([_owner respondsToSelector:self.selector]) {
                SuppressPerformSelectorLeakWarning(
                                                   [_owner performSelector:self.selector withObject:nil];
                                                   );
            }
        }
        return YES;
    }
    
    return NO;
}

@end
