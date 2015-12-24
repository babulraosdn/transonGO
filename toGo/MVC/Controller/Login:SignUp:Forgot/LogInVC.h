//
//  LogInVC.h
//  ooVooSdkSampleShow
//
//  Created by Udi on 3/30/15.
//  Copyright (c) 2015 ooVoo LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ooVooSDK/ooVooSDK.h>
#import "Headers.h"
#import <TheSidebarController/TheSidebarController.h>
#import "AuthorizationLoaderVc.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
@interface LogInVC : UIViewController <AuthorizationDelegate, ooVooAccount, SocialDelegate, GPPSignInDelegate>
@property (weak, nonatomic) IBOutlet UIView *signUpUIView;
@property (weak, nonatomic) IBOutlet UILabel *signUplabel;
@property (weak, nonatomic) IBOutlet UILabel *doNotHaveAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectWithLabel;
@property (weak, nonatomic) IBOutlet UILabel *orlabel;
@property (weak, nonatomic) IBOutlet UILabel *rememberMeLabel;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIView *viewAuthorization_Container;
@property (weak, nonatomic) IBOutlet UITextField *txt_userId;
@property (weak, nonatomic) IBOutlet UITextField *txtDisplayName;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

//@property (retain, nonatomic) CustomTextFieldDelegate *textFieldDelegate;

- (IBAction)act_LogIn:(id)sender;

@property (retain, nonatomic) ooVooClient *sdk;

@end
