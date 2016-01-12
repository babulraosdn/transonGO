            //
//  LogInVC.m
//  ooVooSdkSampleShow
//
//  Created by Udi on 3/30/15.
//  Copyright (c) 2015 ooVoo LLC. All rights reserved.
//

#import "LogInVC.h"
#import "UIView-Extensions.h"
#import "ActiveUserManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//#import "SettingBundle.h"
#import "UserDefaults.h"
#import "AppDelegate.h"
#import "SlideMenuViewController.h"

#define User_isInVideoView @"User_isInVideoView"

#define Segue_Authorization @"ToAuthorizationView"
#define Segue_MenuConferenceVC @"Segue_MenuConferenceVC"

#define Segue_VideoConference @"Segue_VideoConferenceVC"


#define UserDefault_UserId @"UserID"
#define UserDefault_DisplayName @"displayName"


#import <ooVooSDK/ooVooPushService.h>

#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>

@interface LogInVC ()<UITextFieldDelegate> {
    AppDelegate  *appDelegate;
    SocialView *socialView;
    __weak IBOutlet UIActivityIndicatorView *spinner;
    NSMutableDictionary *loginDictionary;
    UITextField *activeField;
    NSString *userIDString;
    NSString *passwordString;
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
    [self registerForKeyboardNotifications];
    [self setLabelButtonNames];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];
    [self setColors];
    [self setFonts];
    
}
-(void)viewDidLayoutSubviews{
    
    if(IS_IPHONE_4S)
        _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    else
        _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);

}

-(void)allocationsAndStaticText{
    
    loginDictionary = [NSMutableDictionary new];
    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    self.sdk = [ooVooClient sharedInstance];
    self.sdk.Account.delegate = self;
    socialView=[SocialView new];
    socialView.delegate=self;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.view.frame.origin.x,self.view.frame.origin.y, kbSize.height+100, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

-(void)setLabelButtonNames{
    self.forgotPasswordLabel.text = NSLOCALIZEDSTRING(@"FORGET_PASSWORD");
    self.signUplabel.text = NSLOCALIZEDSTRING(@"SIGNUP");
    self.orlabel.text = NSLOCALIZEDSTRING(@"OR");
    self.connectWithLabel.text = NSLOCALIZEDSTRING(@"COONNECT_WITH");
    [self.loginButton setTitle:NSLOCALIZEDSTRING(@"LOGIN") forState:UIControlStateNormal];
}

-(void)setPlaceHolders{
    self.txt_userId.placeholder = NSLOCALIZEDSTRING(@"USER_ID");
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
    self.connectWithLabel.textColor = [UIColor lightGrayConnectWithColor];
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

- (void)viewWillAppear:(BOOL)animated {
    
    _txt_userId.text = [self randomUser];
    _txtDisplayName.text=[self returnSavedDisplayname];
    userIDString = _txt_userId.text;
    passwordString = _txtDisplayName.text;
    [self autorize];
    
   
}
- (void)viewDidDisappear:(BOOL)animated {
    self.txt_userId.text = @"";
    self.txtDisplayName.text = @"";
}

#pragma mark - Authorization ...

- (void)autorize {
    
    NSString* token =[UserDefaults getObjectforKey:@"APP_TOKEN_SETTINGS_KEY"];
    NSLog(@"Token %@",token);
    
    [self.sdk authorizeClient:token
                   completion:^(SdkResult *result) {
                       
                       sdk_error err = result.Result;
                       if (err == sdk_error_OK) {
                           NSLog(@"good autorization");
                           sleep(0.5);
                           //[_delegate AuthorizationDelegate_DidAuthorized];
                       }
                       else {
                           NSLog(@"fail  autorization");
//                           self.btn_Authorizate.hidden = false;
//                           self.lbl_Status.font=[UIFont systemFontOfSize:13];
//                           self.lbl_Status.text = @"Authorization Failed.";
                           
                           if (err == sdk_error_InvalidToken) {
                               double delayInSeconds = 0.75;
                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                   
                                   [[[UIAlertView alloc] initWithTitle:@"ooVoo Sdk"
                                                               message:[NSString stringWithFormat:NSLocalizedString(@"Error: %@", nil), @"App Token probably invalid or might be empty.\n\nGet your App Token at http://developer.oovoo.com.\nGo to Settings->ooVooSample screen and set the values, or set @APP_TOKEN constants in code."]
                                                              delegate:nil
                                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                     otherButtonTitles:nil] show];
                               });
                              // [_spinner stopAnimating];
                               
                           }
                           else if (err != sdk_error_InvalidToken)
                           {
                               double delayInSeconds = 0.75;
                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                   
                                   [[[UIAlertView alloc] initWithTitle:@"ooVoo Sdk"
                                                               message:[NSString stringWithFormat:NSLocalizedString(@"Error: %@", nil), [result description]]
                                                              delegate:nil
                                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                     otherButtonTitles:nil] show];
                               });
                               //[_spinner stopAnimating];
                           }
                       }
                       
                   }];
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    if ([identifier isEqualToString:Segue_Authorization]) {
//        if ([UserDefaults getBoolForToKey:User_isInVideoView]) {
//            [self performSegueWithIdentifier:Segue_PushTo_ConferenceVC sender:nil];
//            return NO;
//        }
//    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:Segue_Authorization]) {
        AuthorizationLoaderVc *authoVC = segue.destinationViewController;
        authoVC.delegate = self;
    }
}

#pragma mark - Authorization Delegate

- (void)AuthorizationDelegate_DidAuthorized {

    [UIView animateWithDuration:1
                     animations:^{

                       //        self.viewAuthorization_Container.y=-self.viewAuthorization_Container.height;
                       self.viewAuthorization_Container.alpha = 0;

                     }];
}

#pragma mark - IBAction

- (IBAction)act_LogIn:(id)sender {
    
    //[self createSidePanel];
    //return;
    
    
    AlertViewCustom *alertView = [[AlertViewCustom alloc]init];
    UIView *viewIs = [alertView showAlertViewWithMessage:@"Please confirm the Registration by clicking the verification link on email" headingLabel:@"Confirm Registration" confirmButtonName:@"Confirm" cancelButtonName:@"Cancel" viewIs:self.view];
    //[self.view addSubview:viewIs]; //Alert View Custom
    //[App_Delegate takeTour];//Take a Tour
    
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
        [self loginWebServiceCall:NORMAL_LOGIN];
    }
}

-(void)loginWebServiceCall:(NSString *)loginWith{
    
    [loginDictionary setObject:userIDString forKey:KEMAIL_W];
    [loginDictionary setObject:passwordString forKey:KPASSWORD_W];
    [loginDictionary setObject:loginWith forKey:KLOGIN_TYPE_W];
    [loginDictionary setObject:userIDString forKey:KUSERNAME_W];
    [loginDictionary setObject:[Utility_Shared_Instance checkForNullString:[Utility_Shared_Instance readStringUserPreference:USER_TYPE]] forKey:KTYPE_W];
    
    
    //[loginDictionary setObject:@"obaidr@yopmail.com" forKey:KEMAIL_W];
    //[loginDictionary setObject:@"Obaid@123" forKey:KPASSWORD_W];
    //[loginDictionary setObject:@"togo-ibq@ice-breakrr.com" forKey:KEMAIL_W];
    
    [Web_Service_Call serviceCall:loginDictionary webServicename:LOGIN_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        
        NSDictionary *responseDict=responseObject;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:[responseDict objectForKey:KMESSAGE_W]
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
        });
        
        if ([responseDict objectForKey:KCODE_W]){
            if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
            {
                if ([responseDict objectForKey:KTOKEN_W]) {
                    [Utility_Shared_Instance writeStringUserPreference:USER_TOKEN value:[responseDict objectForKey:KTOKEN_W]];
                }
                [self ooVooLogin];
                [self createSidePanel];
            }
        }
        
        [self reportAuthStatus];//This is to clear google cookies
        
        
        
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
        });
    }];
}


-(void)ooVooLogin{
    [UserDefaults setObject:_txt_userId.text ForKey:UserDefault_UserId];
    [UserDefaults setObject:_txtDisplayName.text ForKey:UserDefault_DisplayName];
    //[sender setEnabled:false];
    //[spinner startAnimating];
    
    [self.sdk.Account login:self.txt_userId.text
                 completion:^(SdkResult *result) {
                     NSLog(@"result code=%d result description %@", result.Result, result.description);
                     //[spinner stopAnimating];
                     if (result.Result != sdk_error_OK){
                         [SVProgressHUD dismiss];
                         [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                             withMessage:@"USERID SHOULD BE MINIUMUM 6 CHARACTERS"
                                                                  inView:self
                                                               withStyle:UIAlertControllerStyleAlert];
                     }
                     else
                     {
                         [SVProgressHUD dismiss];
                         [self onLogin:result.Result];
                         if(![self.sdk.Messaging isConnected])
                             [self.sdk.Messaging connect];
                     }
                 }];
}


-(IBAction)loginWithSoicalAccounts:(id)sender{
    
    UIButton *selectedButton = (UIButton *)sender;
    if (selectedButton.tag ==1) {
        //facebook
        //[socialView faceBookLogin];
        [self btnFacebookSigninClicked];
    }
    else if (selectedButton.tag ==2) {
        //twitter
        //[socialView twitterLogin];
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
    
    FBSDKLoginManager *facebookLoginManager = [[FBSDKLoginManager alloc] init];
    facebookLoginManager.loginBehavior = FBSDKLoginBehaviorNative;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self fetchUserFacebookCredential];
    }else{
        
        [facebookLoginManager logInWithReadPermissions:@[kPublicProfile,kEmail,kBirthday,kLocation] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
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
            UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:DASHBOARD_INTERPRETER_VIEW_CONTROLLER]];//DashBoardViewController
            
            
            TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                        leftSidebarViewController:[Utility_Shared_Instance getControllerForIdentifier:@"SlideMenuViewController"]
                                                                                       rightSidebarViewController:nil];
            
            appDelegate.window.rootViewController = sidebarController;
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:DASHBOARD_USER_VIEW_CONTROLLER]];//DashBoardViewController
            
            
            TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                        leftSidebarViewController:[Utility_Shared_Instance getControllerForIdentifier:@"SlideMenuViewController"]
                                                                                       rightSidebarViewController:nil];
            
            appDelegate.window.rootViewController = sidebarController;
        });
    }
    
    
}


-(void)popUpButtonClicked:(UIButton *)sender{
   
    if (sender.tag == 1) {
        //Confirm Button
        NSLog(@"Confirm Selected");
    }
    else if (sender.tag == 2) {
        //Cancel Button
        NSLog(@"Cancel Selected");
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:999] removeFromSuperview];
    }
}



#pragma mark - private methods

- (void)onLogin:(BOOL)error {
    if (!error) {
        [ActiveUserManager activeUser].userId = self.txt_userId.text;
        [ActiveUserManager activeUser].displayName = self.txtDisplayName.text;
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




#pragma mark - ooVoo Account delegate

- (void)didAccountLogIn:(id<ooVooAccount>)account {
    
}

- (void)didAccountLogOut:(id<ooVooAccount>)account {
    
}

@end
