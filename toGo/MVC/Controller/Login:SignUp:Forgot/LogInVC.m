//
//  LogInVC.m
//  ooVooSdkSampleShow
//
//  Created by Udi on 3/30/15.
//  Copyright (c) 2015 ooVoo LLC. All rights reserved.
//

#import "LogInVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import "SlideMenuViewController.h"
#import <ooVooSDK/ooVooPushService.h>
#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>

#import "UIView-Extensions.h"
#import "ActiveUserManager.h"
//#import "SettingBundle.h"
#import "UserDefaults.h"
#define User_isInVideoView @"User_isInVideoView"
#define Segue_Authorization @"ToAuthorizationView"
#define Segue_MenuConferenceVC @"Segue_MenuConferenceVC"
#define Segue_VideoConference @"Segue_VideoConferenceVC"
#define UserDefault_UserId @"UserID"
#define UserDefault_DisplayName @"displayName"
#import <ooVooSDK/ooVooPushService.h>


@interface LogInVC ()<UITextFieldDelegate> {
    AppDelegate  *appDelegate;
    SocialView *socialView;
    __weak IBOutlet UIActivityIndicatorView *spinner;
    NSMutableDictionary *loginDictionary;
    UITextField *activeField;
    NSString *userIDString;
    NSString *passwordString;
    AlertViewCustom *alertViewCustom;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,readwrite)BOOL isChecked;
@property (weak, nonatomic) IBOutlet UIImageView *rememberMeImageView;


@property (weak, nonatomic) IBOutlet UIView *signUpUIView;
@property (weak, nonatomic) IBOutlet UILabel *signUplabel;
@property (weak, nonatomic) IBOutlet UILabel *doNotHaveAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectWithLabel;
@property (weak, nonatomic) IBOutlet UILabel *orlabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIView *viewAuthorization_Container;
@property (weak, nonatomic) IBOutlet UITextField *txt_userId;
@property (weak, nonatomic) IBOutlet UITextField *txtDisplayName;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)act_LogIn:(id)sender;
-(IBAction)loginWithSoicalAccounts:(id)sender;
@end

@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomBackButtonForNavigation];
    [self allocationsAndStaticText];
    [self setLabelButtonNames];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];
    [self setColors];
    [self setFonts];
}


- (void)viewWillAppear:(BOOL)animated {
    
    
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
//    self.txt_userId.text        =      @"testcustomer@gmail.com";
//    self.txtDisplayName.text    =      @"Test@123";
//    
//    //
//    self.txt_userId.text        =      @"testinterpreter5@gmail.com";
//    self.txtDisplayName.text    =      @"Test@123";
    
//
//    self.txt_userId.text        =      @"pankaj.turkar@smartdatainc.net";
//    self.txtDisplayName.text =     @"Test@123";
//
//    self.txt_userId.text = @"togo-ibq@ice-breakrr.com";
//    self.txtDisplayName.text = @"Int@123";
    
    //rakeshp@ice-breakrr.com/Admin@123@123 -- Customer
//    _txt_userId.text = [self randomUser];
//    _txtDisplayName.text=[self returnSavedDisplayname];
    
    userIDString = _txt_userId.text;
    passwordString = _txtDisplayName.text;
    
    [self autorize];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    self.txt_userId.text = @"";
    self.txtDisplayName.text = @"";
}


-(void)viewDidLayoutSubviews {
    
    if(IS_IPHONE_4S)
        _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    else
        _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);

}

-(void)allocationsAndStaticText{
    
    loginDictionary = [NSMutableDictionary new];
    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    self.sdk = [ooVooClient sharedInstance];
    socialView=[SocialView new];
    socialView.delegate=self;
}


-(void)setLabelButtonNames{
    self.forgotPasswordLabel.text = NSLOCALIZEDSTRING(@"FORGET_PASSWORD");
    self.signUplabel.text = NSLOCALIZEDSTRING(@"SIGNUP");
    self.orlabel.text = NSLOCALIZEDSTRING(@"OR");
    self.connectWithLabel.text = NSLOCALIZEDSTRING(@"COONNECT_WITH");
    [self.loginButton setTitle:NSLOCALIZEDSTRING(@"LOGIN") forState:UIControlStateNormal];
}

-(void)setPlaceHolders{
    self.txt_userId.placeholder = NSLOCALIZEDSTRING(@"EMAIL");
    self.txtDisplayName.placeholder = NSLOCALIZEDSTRING(@"PASSWORD");
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.txt_userId];
    [UITextField roundedCornerTEXTFIELD:self.txtDisplayName];
    [UIButton roundedCornerButton:self.loginButton];
}

-(void)setPadding{
    self.txt_userId.leftViewMode=UITextFieldViewModeAlways;
    self.txt_userId.leftView=[Utility_Shared_Instance setImageViewPadding:USER_ID_PADDING_IMAGE frame:CGRectMake(10, 0, 16, 16)];
    
    self.txtDisplayName.leftViewMode=UITextFieldViewModeAlways;
    self.txtDisplayName.leftView=[Utility_Shared_Instance setImageViewPadding:PASSWORD_PADDING_IMAGE frame:CGRectMake(10, 0, 15, 20)];
}

-(void)setColors{
    self.orlabel.textColor = [UIColor buttonBackgroundColor];
    self.connectWithLabel.textColor = [UIColor textColorBlackColor];//lightGrayConnectWithColor
    self.loginButton.backgroundColor  = [UIColor buttonBackgroundColor];
    self.signUplabel.textColor = [UIColor textColorBlackColor];
}

-(void)setFonts{
    self.forgotPasswordLabel.font = [UIFont small];
    self.signUplabel.font = [UIFont small];
    self.orlabel.font = [UIFont smaller];
    self.connectWithLabel.font = [UIFont largeSizeThin];
    self.loginButton.titleLabel.font = [UIFont largeSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - Authorization ...

- (void)autorize {
    
    
    //[Utility_Shared_Instance showProgress];
    NSString* token = @"MDAxMDAxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZUYVW%2BB1MwyBDpt22C0WvOeMPW7fH6mMOv8d%2FAPeFZ2QeCOguU288bRzsChrixFyZ%2BKzm9nrLmfOkZwyPrAO%2BDP8wgDiVtL%2F0w9mZQ78Az5Hk6imDbhYGNGRFMqo0H2virlVE4Q%2Bpf5S%2Fm50MO%2BMh";
    NSLog(@"Token -->Login--->%@",token);
    
    [self.sdk authorizeClient:token
                   completion:^(SdkResult *result) {
                       
                       sdk_error err = result.Result;
                       if (err == sdk_error_OK) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [SVProgressHUD dismiss];
                           });
                           NSLog(@"good autorization");
                           sleep(0.5);
                           //[_delegate AuthorizationDelegate_DidAuthorized];
                       }
                       else {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [SVProgressHUD dismiss];
                           });
                           NSLog(@"fail  autorization");
//                           self.btn_Authorizate.hidden = false;
//                           self.lbl_Status.font=[UIFont systemFontOfSize:13];
//                           self.lbl_Status.text = @"Authorization Failed.";
                           
                           if (err == sdk_error_InvalidToken) {
                               double delayInSeconds = 0.75;
                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                   [SVProgressHUD dismiss];
//                                   [[[UIAlertView alloc] initWithTitle:@"ooVoo Sdk"
//                                                               message:[NSString stringWithFormat:NSLocalizedString(@"Error: %@", nil), @"App Token probably invalid or might be empty.\n\nGet your App Token at http://developer.oovoo.com.\nGo to Settings->ooVooSample screen and set the values, or set @APP_TOKEN constants in code."]
//                                                              delegate:nil
//                                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                                                     otherButtonTitles:nil] show];
                               });
                              // [_spinner stopAnimating];
                               
                           }
                           else if (err != sdk_error_InvalidToken)
                           {
                            
                               double delayInSeconds = 0.75;
                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                   [SVProgressHUD dismiss];
//                                   [[[UIAlertView alloc] initWithTitle:@"ooVoo Sdk"
//                                                               message:[NSString stringWithFormat:NSLocalizedString(@"Error: %@", nil), [result description]]
//                                                              delegate:nil
//                                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                                                     otherButtonTitles:nil] show];
                               });
                               //[_spinner stopAnimating];
                           }
                       }
                       
                   }];
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}


#pragma mark - IBAction

- (IBAction)act_LogIn:(id)sender {
    
    
//    [self createSidePanel];
//    return;

    if (self.txt_userId.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.txt_userId.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (self.txtDisplayName.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.txtDisplayName.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else{
        [self.view endEditing:YES];
        [Utility_Shared_Instance showProgress];
        [self loginWebServiceCall:NORMAL_LOGIN];
    }
}

-(void)loginWebServiceCall:(NSString *)loginWith {
    
    [loginDictionary setObject:userIDString forKey:KEMAIL_W];
    [loginDictionary setObject:passwordString forKey:KPASSWORD_W];
    [loginDictionary setObject:loginWith forKey:KLOGIN_TYPE_W];
    [loginDictionary setObject:userIDString forKey:KUSERNAME_W];
    [loginDictionary setObject:[Utility_Shared_Instance checkForNullString:[Utility_Shared_Instance readStringUserPreference:USER_TYPE]] forKey:KUSER_TYPE_W];
    
    [Web_Service_Call serviceCall:loginDictionary webServicename:LOGIN_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        
        NSDictionary *responseDict=responseObject;

        if ([responseDict objectForKey:KCODE_W]){
            
            [App_Delegate.facebookLoginManager logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
            
            if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
            {
                if ([responseDict objectForKey:KTOKEN_W])
                {
                    [Utility_Shared_Instance writeStringUserPreference:USER_TOKEN value:[responseDict objectForKey:KTOKEN_W]];
                }
                if ([responseDict objectForKey:KEMAIL_W])
                {
                    [Utility_Shared_Instance writeStringUserPreference:KEMAIL_W value:[responseDict objectForKey:KEMAIL_W]];
                }
                if ([responseDict objectForKey:KCOMPLETION_W])
                {
                    //completion = 1; Means Profile Completed req. fields
                    //completion = 0; Means Profile In-Complete req. fields
                    [Utility_Shared_Instance writeStringUserPreference:KCOMPLETION_W value:[Utility_Shared_Instance checkForNullString:[responseDict objectForKey:KCOMPLETION_W]]];
                }
                if ([[Utility_Shared_Instance readStringUserPreference:KCOMPLETION_W] isEqualToString:PROFILE_INCOMPLETE]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];

                        [AlertViewCustom showAlertViewWithMessage:NSLOCALIZEDSTRING(@"PLEASE_COMPLETE_YOUR_PROFILE") headingLabel:NSLOCALIZEDSTRING(@"COMPLETE_PROFILE_INFO") confirmButtonName:NSLOCALIZEDSTRING(@"CONFIRM") cancelButtonName:NSLOCALIZEDSTRING(@"CANCEL") viewIs:self];

                    });
                    
                }
                else{
                    [Utility_Shared_Instance writeStringUserPreference:KUID_W value:[responseDict objectForKey:KUID_W]];
                    [Utility_Shared_Instance writeStringUserPreference:KID_W value:[responseDict objectForKey:KID_W]];
                    [Utility_Shared_Instance writeStringUserPreference:KUSERNAME_W value:userIDString];
                    //[self ooVooLogin];
                    [self createSidePanel];
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                        withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                             inView:self
                                                          withStyle:UIAlertControllerStyleAlert];
                });
            }
        }
        
        [self reportAuthStatus];//This is to clear google cookies
        
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [AlertViewCustom showAlertViewWithMessage:NSLOCALIZEDSTRING(@"PLEASE_COMPLETE_YOUR_PROFILE") headingLabel:NSLOCALIZEDSTRING(APPLICATION_NAME) confirmButtonName:NSLOCALIZEDSTRING(@"") cancelButtonName:NSLOCALIZEDSTRING(@"OK") viewIs:self];
            });
        });
    }];
}




-(IBAction)loginWithSoicalAccounts:(id)sender{
    
    UIButton *selectedButton = (UIButton *)sender;
    if (selectedButton.tag ==1) {
        //facebook
        [self btnFacebookSigninClicked];
    }
    else if (selectedButton.tag ==2) {
        //twitter
        [[Twitter sharedInstance] logOut];
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error)
         {
             if (session)
             {
                 
                 [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID]
                                                           completion:^(TWTRUser *user,
                                                                        NSError *error)
                  {
                      // handle the response or error
                      if (![error isEqual:nil]) {
                          
                          NSLog(@"Twitter info   -> user = %@ ",user.description);
                          {
                              NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
                              [dict setValue:user.userID forKey:@"id"];
                              [dict setValue:user.name forKey:@"name"];
                              [dict setValue:user.screenName forKey:@"screenName"];
                              NSLog(@"User Description is %@",dict);
                              [self socialLoginSuccess:TWITTER_LOGIN userID:user.screenName password:user.screenName];
                          }
                          //[self createSidePanel];
                          
                      } else {
                      }
                  }];
                 
             } else {
                 NSLog(@"error: %@", [error localizedDescription]);
             }
         }];
    }
    else if (selectedButton.tag ==3) {
        //linkedIn
        [socialView linkedInLogin];
    }
    else if (selectedButton.tag ==4) {
        //google plus
        [self  performSelector:@selector(googleButtonClicked:) withObject:nil afterDelay:0.5];
    }
}


#pragma mark - Facebook Signin

- (void)btnFacebookSigninClicked{
    
    App_Delegate.facebookLoginManager = [[FBSDKLoginManager alloc] init];
    App_Delegate.facebookLoginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    //App_Delegate.facebookLoginManager.loginBehavior = FBSDKLoginBehaviorNative;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self fetchUserFacebookCredential];
    }else{
        
        [App_Delegate.facebookLoginManager logInWithReadPermissions:@[kPublicProfile,kEmail,kBirthday,kLocation] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
            } else if (result.isCancelled) {
            } else {
                
                if ([FBSDKAccessToken currentAccessToken]) {
                    
                    [self fetchUserFacebookCredential];
                }
            }
        }];
    }
}


- (void)fetchUserFacebookCredential{
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"PLEASE_WAIT")]];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email, name, first_name, last_name, birthday, picture, gender"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             
             if (error) {
                 [SVProgressHUD dismiss];
             }else{
                 
                 //[self createSidePanel];
                 [self socialLoginSuccess:FACEBOOK_LOGIN userID:[result objectForKey:@"email"] password:[result objectForKey:@"email"]];
                 //[SVProgressHUD dismiss];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     /*
                      {
                      email = "kbabulenjoy@gmail.com";
                      "first_name" = Babul;
                      gender = male;
                      id = 1023127354412671;
                      "last_name" = Rao;
                      name = "Babul Rao";
                      picture =     {
                      data =         {
                      "is_silhouette" = 0;
                      url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfa1/v/t1.0-1/p50x50/11141380_911313325594075_8980038531866931801_n.jpg?oh=31a7303c08a65821575e4b8e9eb86cfc&oe=57081B5D&__gda__=1461025293_5f1a5235ce890b54aa2235d9c4ba50fd";
                      };
                      };
                      }
                      */
                 });
             }
         }];
    }
}

#pragma mark - twitter Signin
-(IBAction)twitterLogin:(id)sender
{
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error){
        if (session)
        {
            [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID]
                                                      completion:^(TWTRUser *user,
                                                                   NSError *error)
             {
                 // handle the response or error
                 if (![error isEqual:nil]) {
                     NSLog(@"Twitter info   -> user = %@ ",user.description);
                     NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
                     [dict setValue:user.userID forKey:@"id"];
                     [dict setValue:user.name forKey:@"name"];
                     [dict setValue:user.screenName forKey:@"screenName"];
                     NSLog(@"User Description is %@",dict);
                     
                 } else {
                 }
             }];
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}



-(void)socialLoginSuccess:(NSString *)mediaType userID:(NSString *)userID password:(NSString *)password
{
    userIDString = userID;
    passwordString = @"";
    [self loginWebServiceCall:mediaType];
    //[self createSidePanel];
}

#pragma mark Social Delegate Methods
#pragma mark - Google Plus

- (void)googleButtonClicked:(id)sender
{
    //    [self signOut:nil];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate =  self;
    signIn.shouldFetchGoogleUserEmail = YES;
    [signIn authenticate];
}

- (IBAction)signOut:(id)sender {
    [[GPPSignIn sharedInstance] signOut];
    
    [self reportAuthStatus];
    //signInDisplayName_.text = @"";
}


#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        //signInAuthStatus_.text = [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        return;
    }else{
        
        if (!auth.code) {
            auth.code = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth.code"];
        }else{
            [[NSUserDefaults standardUserDefaults]setObject:auth.code forKey:@"auth.code"];
            [[NSUserDefaults standardUserDefaults]setObject:auth.accessToken forKey:@"auth.accessToken"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        // NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", auth.code,auth.clientID,kClientSecret,auth.redirectURI];
        // NSString *pdata = [NSString stringWithFormat:@"type=3&token=%@&secret=123&login=%@", auth.refreshToken, @"0"];
        //  NSString *pdata = [NSString stringWithFormat:@"type=3&token=%@&secret=123&login=%@",[tokenData accessToken.secret,self.isLogin];
        
        //  [dconnection fetch:1 withPostdata:pdata withGetData:@"" isSilent:NO];
        
        NSString *str =  [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",auth.accessToken];
        NSString* escapedUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",escapedUrl]];
        NSString *jsonData = [[NSString alloc] initWithContentsOfURL:url usedEncoding:nil error:nil];
        NSMutableDictionary *proDic = [[NSMutableDictionary alloc] init];
        
        proDic=[NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        
        /*
         {
         "id": "103451016822416832111",
         "name": "Babul Rao K",
         "given_name": "Babul Rao",
         "family_name": "K",
         "link": "https://plus.google.com/+BabulRaoK",
         "picture": "https://lh6.googleusercontent.com/-eJnZBkacJSk/AAAAAAAAAAI/AAAAAAAALSc/BuQKPxDuKT8/photo.jpg",
         "gender": "male",
         "locale": "en"
         }
         */
        [self socialLoginSuccess:TWITTER_LOGIN userID:[proDic objectForKey:@"email"] password:[proDic objectForKey:@"given_name"]];
    }
    //[SVProgressHUD dismiss];
    //[self createSidePanel];
}



- (void)didDisconnectWithError:(NSError *)error {
    
    if (error) {
        //signInAuthStatus_.text = [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else {
        //signInAuthStatus_.text = [NSString stringWithFormat:@"Status: Disconnected"];
        //signInDisplayName_.text = @"";
        // [self enableSignInSettings:YES];
    }
    [self reportAuthStatus];
}

#pragma mark - Helper methods

- (void)reportAuthStatus {
    if ([GPPSignIn sharedInstance].authentication) {
        //signInAuthStatus_.text = @"Status: Authenticated";
        //        [self retrieveUserInfo];
        //[self enableSignInSettings:NO];
        // NSString *userEmail = [result valueForKey:@"email"];
        [[GPPSignIn sharedInstance] disconnect];
        [[GPPSignIn sharedInstance] signOut];
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSLog(@"cookies = %@", storage);
        for (cookie in [storage cookies])
        {
            NSString* domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"google"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }
        
        //        [self loginWithOtherSites:googleEmailId];
        
    }
    else
    {
        // To authenticate, use Google+ sign-in button.
        //signInAuthStatus_.text = @"Status: Not authenticated";
        //[self enableSignInSettings:YES];
    }
}



-(void)createSidePanel{
    
    if ([[Utility_Shared_Instance readStringUserPreference:USER_TYPE] isEqualToString:INTERPRETER]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [App_Delegate UnSetNotificationObserversForCallMessaging];
            [App_Delegate SetNotificationObserversForCallMessaging];
            UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:DASHBOARD_INTERPRETER_VIEW_CONTROLLER]];//DashBoardViewController
            
            if ([[Utility_Shared_Instance readStringUserPreference:KCOMPLETION_W] isEqualToString:PROFILE_INCOMPLETE]) {
                contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:PROFILE_VIEW_CONTROLLER]];//DashBoardViewController
            }
            
            self.revealController = [PKRevealController revealControllerWithFrontViewController:contentNavigationController leftViewController:[Utility_Shared_Instance getControllerForIdentifier:SLIDE_MENU_VIEW_CONTROLLER]];
            appDelegate.window.rootViewController = self.revealController;
            
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [App_Delegate UnSetNotificationObserversForCallMessaging];
            UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:DASHBOARD_USER_VIEW_CONTROLLER]];
            if ([[Utility_Shared_Instance readStringUserPreference:KCOMPLETION_W] isEqualToString:PROFILE_INCOMPLETE]) {
                contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:PROFILE_VIEW_CONTROLLER]];//DashBoardViewController
            }
            self.revealController = [PKRevealController revealControllerWithFrontViewController:contentNavigationController leftViewController:[Utility_Shared_Instance getControllerForIdentifier:SLIDE_MENU_VIEW_CONTROLLER]];
            appDelegate.window.rootViewController = self.revealController;
            
        });
    }
}


#pragma mark - private methods




#pragma Mark UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.txt_userId) {
        userIDString = self.txt_userId.text;
    }
    else if (textField == self.txtDisplayName) {
        passwordString = self.txtDisplayName.text;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

#pragma mark - AlertView Custom delegate
-(void)finishAlertViewCustomAction:(UIButton *)sender{
    if (sender.tag ==1) {
        [self createSidePanel];
    }else{
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:999] removeFromSuperview];
    }
   
}


#pragma mark - IBAction

- (IBAction)ooVooLogin{
    
//    if ([self isUserIdEmpty])
//        return;
    
//    [UserDefaults setObject:[Utility_Shared_Instance readStringUserPreference:KUID_W] ForKey:UserDefault_UserId];
//    [UserDefaults setObject:[Utility_Shared_Instance readStringUserPreference:KUID_W] ForKey:UserDefault_DisplayName];
    //[UserDefaults setObject:_txtDisplayName.text ForKey:UserDefault_DisplayName];
    //[UserDefaults setObject:@"user1454389915259" ForKey:UserDefault_DisplayName];
//    [sender setEnabled:false];
//    [spinner startAnimating];
    
    [self.sdk.Account login:[Utility_Shared_Instance readStringUserPreference:KUID_W]
   //[self.sdk.Account login:@"babul123"
    //[self.sdk.Account login:self.txt_userId.text
                 completion:^(SdkResult *result) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [SVProgressHUD dismiss];
                     });
                     if (result.Result == 37) {
                         NSLog(@"377777777--> Failure Either Authorization  or ooVoo Server DOWN");
                     }
                     else if (result.Result == 0) {
                         NSLog(@"0 --> SUCCESS");
                     }
                     NSLog(@"result code=%d result description %@", result.Result, result.description);
                     [spinner stopAnimating];
                     if (result.Result != sdk_error_OK){
                         [[[UIAlertView alloc] initWithTitle:@"ooVoo Server Error" message:result.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                         [self.loginButton setEnabled:true];
                     }
                     else
                     {
                         [self onLogin:result.Result];
                         if(![self.sdk.Messaging isConnected])
                             [self.sdk.Messaging connect];
                     }
                 }];
}


#pragma mark - private methods

- (BOOL)isUserIdEmpty {
    
    // removing white space from start and end
    if ([[self.txt_userId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserId Missing" message:@"Please enter userId " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        self.txt_userId.text = @"";
        
        return true;
    }
    
    if (self.txt_userId.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Characters Missing" message:@"UserId Must contain at least 6 characters " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return true;
    }
    
    return false;
}


- (void)onLogin:(BOOL)error {
    
    if (!error) {
        [ActiveUserManager activeUser].userId =[Utility_Shared_Instance readStringUserPreference:KUID_W];
        
        [UserDefaults setObject:[ActiveUserManager activeUser].token ForKey:[ActiveUserManager activeUser].userId];
        
        [ActiveUserManager activeUser].displayName = [Utility_Shared_Instance readStringUserPreference:KUID_W];
        
        ///NSString * uuid = [[NSUUID UUID] UUIDString] ;
        NSString * token = [ActiveUserManager activeUser].token;
        if(token && token.length > 0){
            [self.sdk.PushService subscribe:token deviceUid:[ActiveUserManager activeUser].userId completion:^(SdkResult *result){
                [ActiveUserManager activeUser].isSubscribed = true;
            }];
        }
        
        //        NSString * uuid = [[NSUUID UUID] UUIDString] ;
        //        NSString * token = [ActiveUserManager activeUser].token;
        //        if(token && token.length > 0){
        //        [self.sdk.PushService subscribe:token deviceUid:uuid completion:^(SdkResult *result){
        //        [ActiveUserManager activeUser].isSubscribed = true;
        //            [self performSegueWithIdentifier:Segue_MenuConferenceVC sender:nil]; //Segue_VideoConference
        //        }];
        //        }
        //
        //        else
        //        {
                [self createSidePanel];
        //[self performSegueWithIdentifier:Segue_MenuConferenceVC sender:nil]; //Segue_VideoConference
        //        }
        
    }else{
        [self.loginButton setEnabled:true];
    }
}

- (NSString *)randomUser {
    
    if ([UserDefaults getObjectforKey:UserDefault_UserId]) {
        return [UserDefaults getObjectforKey:UserDefault_UserId];
    }
    return @"";
}

- (NSString *)returnSavedDisplayname {
    
    if ([UserDefaults getObjectforKey:UserDefault_DisplayName]) {
        return [UserDefaults getObjectforKey:UserDefault_DisplayName];
    }
    return @"";
}

#pragma mark - ooVoo Account delegate

- (void)didAccountLogIn:(id<ooVooAccount>)account {
    
}

- (void)didAccountLogOut:(id<ooVooAccount>)account {
    
}



@end
