//
//  LoginViewController.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginBaseViewController.h"
#import "Headers.h"
#import <TheSidebarController/TheSidebarController.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@class GPPSignInButton;
@interface LoginViewController : LoginBaseViewController<SocialDelegate,GPPSignInDelegate>
{
    NSString *empNameString;
}
@property (retain, nonatomic) CustomTextFieldDelegate *textFieldDelegate;
@end
