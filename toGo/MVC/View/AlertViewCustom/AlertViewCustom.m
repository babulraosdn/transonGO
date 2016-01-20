//
//  AlertViewCustom.m
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "AlertViewCustom.h"

@implementation AlertViewCustom

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIView *)showAlertViewWithMessage:(NSString *)messageString headingLabel:(NSString *)headerString confirmButtonName:(NSString *)confrirmSting cancelButtonName:(NSString *)cancelString viewIs:(UIView *)currentView{
    
    int x = 10;
    int y = 8;
    
    int alertViewHeight = 145;
    int alertViewWidth = 270;
    
    UIView *mainView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    mainView.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:0.8];
    
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, alertViewWidth-(x+x), 20)];
    headingLabel.text = headerString;
    [headingLabel setTextColor:[UIColor textColorBlackColor]];
    
    y = y+headingLabel.frame.size.height+5;
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, alertViewWidth, 0.3)];
    lineLabel.backgroundColor = [UIColor lightGrayConnectWithColor];
    
    
    UIView *alertUIView = [[UIView alloc]initWithFrame:CGRectMake(currentView.center.x-(alertViewWidth/2), currentView.center.y-(alertViewHeight/2), alertViewWidth, alertViewHeight)];
    alertUIView.backgroundColor  = [UIColor whiteColor];
    
    
    y = y+lineLabel.frame.size.height+5;
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, alertViewWidth-(x+x), 60)];
    messageLabel.text = messageString;
    messageLabel.numberOfLines  =3;
    [messageLabel setTextColor:[UIColor lightGrayConnectWithColor]];

    y = y+messageLabel.frame.size.height+5;
    
    int buttonWidth = 80;
    int buttonHeight = 35;
    UIButton *cancelButton  = [[UIButton alloc]initWithFrame:CGRectMake(alertViewWidth-buttonWidth-10, y, buttonWidth, buttonHeight)];
    [cancelButton setTitle:cancelString forState:UIControlStateNormal];
    cancelButton.tag = 2;
    [cancelButton addTarget:self action:@selector(popUpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTintColor:[UIColor textColorWhiteColor]];
    [cancelButton setBackgroundColor:[UIColor buttonBackgroundColor]];
    
    UIButton *confirmButton  = [[UIButton alloc]initWithFrame:CGRectMake(alertViewWidth-(buttonWidth*2)-20, y, buttonWidth, buttonHeight)];
    confirmButton.tag = 1;
    [confirmButton setTitle:confrirmSting forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(popUpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTintColor:[UIColor textColorWhiteColor]];
    [confirmButton setBackgroundColor:[UIColor buttonBackgroundColor]];
    
    [UIButton roundedCornerButton:confirmButton];
    [UIButton roundedCornerButton:cancelButton];
    
    [alertUIView addSubview:headingLabel];
    [alertUIView addSubview:lineLabel];
    [alertUIView addSubview:messageLabel];
    [alertUIView addSubview:confirmButton];
    [alertUIView addSubview:cancelButton];

    mainView.tag = 999;
    //[UIView roundedCornerView:mainView];
    [mainView addSubview:alertUIView];
    
    return mainView;
}


@end
