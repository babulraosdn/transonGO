//
//  AlertViewCustom.h
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@protocol ALERTVIEWCUSTOMDELEGATE <NSObject>
-(void)finishAlertViewCustomAction:(UIButton *)sender;
@end

@interface AlertViewCustom : UIView
@property(nonatomic,weak) id <ALERTVIEWCUSTOMDELEGATE> delegate;
+(void)showAlertViewWithMessage:(NSString *)messageString headingLabel:(NSString *)headerString confirmButtonName:(NSString *)confrirmSting cancelButtonName:(NSString *)cancelString viewIs:(UIViewController *)currentView;
-(void)popUpButtonClicked:(UIButton *)sender;
@end
