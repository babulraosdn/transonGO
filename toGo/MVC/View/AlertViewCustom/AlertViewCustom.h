//
//  AlertViewCustom.h
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@interface AlertViewCustom : UIView
-(UIView *)showAlertViewWithMessage:(NSString *)messageString headingLabel:(NSString *)headerString confirmButtonName:(NSString *)confrirmSting cancelButtonName:(NSString *)cancelString viewIs:(UIView *)currentView;
-(void)popUpButtonClicked:(UIButton *)sender;
@end
