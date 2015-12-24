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
    
    UITextField *activeField;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,readwrite)BOOL isChecked;
@property (weak, nonatomic) IBOutlet UIImageView *rememberMeImageView;

- (IBAction)rememberMeButtonPressed:(id)sender;
-(IBAction)loginWithSoicalAccounts:(id)sender;
@end

@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.title = NSLOCALIZEDSTRING(@"TOGO");
    self.view.backgroundColor = [UIColor backgroundColor];
    
    
//    scrollView.pagingEnabled = YES;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.scrollsToTop = NO;

    
    
    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    self.sdk = [ooVooClient sharedInstance];
    self.sdk.Account.delegate = self;
    
    socialView=[SocialView new];
    socialView.delegate=self;
    
    //[self setKeyBoardReturntypesAndDelegates];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];
    [self setColors];
    [self setFonts];
    
    [self registerForKeyboardNotifications];
    
}
-(void)viewDidLayoutSubviews{
    _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);

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


-(void)setKeyBoardReturntypesAndDelegates{
    /*
    self.txt_userId.tag=0;
    self.txtDisplayName.tag=1;
    if (!self.textFieldDelegate) {
        self.textFieldDelegate = [[CustomTextFieldDelegate alloc]init];
        self.textFieldDelegate.owner =  self;
    }
    self.txt_userId.returnKeyType    = UIReturnKeyNext;
    self.txtDisplayName.returnKeyType = UIReturnKeyGo;
    self.txt_userId.delegate=self.textFieldDelegate;
    self.txtDisplayName.delegate=self.textFieldDelegate;
    self.textFieldDelegate.selector = @selector(onLogin:);
    */
}

-(void)setPlaceHolders{
    self.txt_userId.placeholder = NSLOCALIZEDSTRING(@"USER_ID");
    self.txtDisplayName.placeholder = NSLOCALIZEDSTRING(@"PASSWORD");
    [self.loginButton setTitle:NSLOCALIZEDSTRING(@"LOGIN") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.txt_userId];
    [UITextField roundedCornerTEXTFIELD:self.txtDisplayName];
    [UIButton roundedCornerButton:self.loginButton];
}

-(void)setPadding{
    self.txt_userId.leftViewMode=UITextFieldViewModeAlways;
    self.txt_userId.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"USER_ID_PADDING_IMAGE") frame:CGRectMake(10, 0, 17, 17)];
    
    self.txtDisplayName.leftViewMode=UITextFieldViewModeAlways;
    self.txtDisplayName.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"PASSWORD_PADDING_IMAGE") frame:CGRectMake(10, 0, 17, 17)];
}

-(void)setColors{
    self.orlabel.textColor = [UIColor buttonBackgroundColor];
    self.connectWithLabel.textColor = [UIColor lightGrayConnectWithColor];
    self.loginButton.backgroundColor  = [UIColor buttonBackgroundColor];
    self.signUplabel.textColor = [UIColor blueSignUpColor];
}

-(void)setFonts{
    
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
    [self autorize];
    
   
}
- (void)viewDidDisappear:(BOOL)animated {
    self.txt_userId.text = @"";
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
    
    if ([self isUserIdEmpty])
        return;
    
    [UserDefaults setObject:_txt_userId.text ForKey:UserDefault_UserId];
    [UserDefaults setObject:_txtDisplayName.text ForKey:UserDefault_DisplayName];
    
    //[sender setEnabled:false];
    [spinner startAnimating];
    
   

    [self.sdk.Account login:self.txt_userId.text
                 completion:^(SdkResult *result) {
                     NSLog(@"result code=%d result description %@", result.Result, result.description);
                     [spinner stopAnimating];
                     if (result.Result != sdk_error_OK){
                         [[[UIAlertView alloc] initWithTitle:@"Login Error" message:result.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
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
           [self performSegueWithIdentifier:Segue_MenuConferenceVC sender:nil]; //Segue_VideoConference
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

-(IBAction)loginWithSoicalAccounts:(id)sender{
    
    [SVProgressHUD dismiss];
    //[SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"Please wait...")]];
    UIButton *selectedButton = (UIButton *)sender;
    if (selectedButton.tag ==1) {
        //facebook
        //[socialView faceBookLogin];
        [self btnFacebookSigninClicked];
    }
    else if (selectedButton.tag ==2) {
        //twitter
        [socialView twitterLogin];
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
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"Please wait...")]];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email, name, first_name, last_name, birthday, picture, gender"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             
             if (error) {
                 [SVProgressHUD dismiss];
             }else{
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
                     [SVProgressHUD dismiss];
                 });
             }
         }];
    }
}


#pragma mark Social Delegate Methods

-(void)finishLogin:(NSString *)mediaType responseDict:(NSMutableDictionary *)response showAlerViewController:(BOOL)isPresentAlertVC alertViewContoller:(UIAlertController *)alertViewController
{
    [SVProgressHUD dismiss];
    
    if (isPresentAlertVC) {
        [self presentViewController:alertViewController animated:YES completion:nil];
        return;
    }
    
    BOOL success;
    if ([mediaType isEqualToString:FACEBOOK]) {
        /*
         {
         {
         email = "kbabulenjoy@gmail.com";
         "first_name" = Babul;
         id = 1019635601428513;
         "last_name" = Rao;
         name = "Babul Rao";
         profileImage = "https://graph.facebook.com/1019635601428513/picture?type=large&return_ssl_resources=1";
         }
         }
         */
        success=YES;
        if ([response objectForKey:@"Error Domain=com.apple.accounts Code=6 \"(null)\""]) {
            success=NO;
            if([UIAlertController class]){
                NSString *alertMessage = NSLOCALIZEDSTRING(@"1. Go to Settings.\n2. Tap Facebook.\n3. Enter your facebook credentials.");
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLOCALIZEDSTRING(@"Facebook Account not Setup") message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertVC addAction:cancel];
                UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertVC addAction:settings];
                NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
                paragraphStyle.alignment =  NSTextAlignmentLeft;
                NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc]initWithString:alertMessage attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
                [alertVC setValue:messageText forKey:@"attributedMessage"];
                [self presentViewController:alertVC animated:YES completion:nil];
                //[SVProgressHUD dismiss];
            }
        }
    }
    else if ([mediaType isEqualToString:TWITTER]) {
        success=YES;
        /*
        2015-12-16 12:52:11.976 toGo[4938:99094] good autorization
        Printing description of response:
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Wed Dec 16 07:24:55 +0000 2015";
            entities =     {
                hashtags =         (
                );
                symbols =         (
                );
                urls =         (
                );
                "user_mentions" =         (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 677026602123792384;
            "id_str" = 677026602123792384;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            place = "<null>";
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://www.apple.com\" rel=\"nofollow\">iOS</a>";
            text = "My new Twitter message.";
            truncated = 0;
            user =     {
                "contributors_enabled" = 0;
                "created_at" = "Wed Aug 31 21:20:25 +0000 2011";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "";
                entities =         {
                    description =             {
                        urls =                 (
                        );
                    };
                };
                "favourites_count" = 0;
                "follow_request_sent" = 0;
                "followers_count" = 40;
                following = 0;
                "friends_count" = 93;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 365689054;
                "id_str" = 365689054;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "Nagpur, Maharashtra";
                name = "BABUL RAO KOONA";
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_image_url" = "http://pbs.twimg.com/profile_images/657037520484470785/F9ldUePt_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/657037520484470785/F9ldUePt_normal.jpg";
                "profile_link_color" = 0084B4;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = "babul_enjoy";
                "statuses_count" = 2;
                "time_zone" = "<null>";
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
        }
        */
    }
    else if ([mediaType isEqualToString:LINKEDIN]) {
        success=YES;
        /*
         Printing description of response:
         {
         emailAddress = "kbabulenjoy@gmail.com";
         firstName = Babul;
         id = "phq36KFc-h";
         lastName = Rao;
         pictureUrl = "https://media.licdn.com/mpr/mprx/0_I3FrdIwDPduQ4rWHdih7deVTxWoeZ9WHd_17dWWj8uOMbtYebFcpbdj1lFEnRAeXoGLa6aUSwHgz";
         
         */
    }
    else if ([mediaType isEqualToString:GOOGLE_PLUS]) {
        success=YES;
    }
    
    if (success) {
        [self createSidePanel
         ];
    }
}


#pragma mark - Google Plus

- (void)googleButtonClicked:(id)sender
{
    //    [self signOut:nil];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate =  self;
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
        
    }
    [SVProgressHUD dismiss];
    [self createSidePanel];
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
    
    
    
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:@"DashBoardViewController"]];
    
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                leftSidebarViewController:[Utility_Shared_Instance getControllerForIdentifier:@"SlideMenuViewController"]
                                                                               rightSidebarViewController:nil];
    
    appDelegate.window.rootViewController = sidebarController;
    
}

- (IBAction)rememberMeButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    if (!_isChecked) {
        [Utility_Shared_Instance writeStringUserPreference:@"remember" value:@"yes"];
        _rememberMeImageView.image=[UIImage checkedBoxImage];
        _isChecked=YES;
    }
    else{
        [Utility_Shared_Instance clearStringFromUserPreference:@"remember"];
        [Utility_Shared_Instance writeStringUserPreference:@"remember" value:@"no"];
        _rememberMeImageView.image=[UIImage uncheckBoxImage];
        _isChecked=NO;
    }
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


@end
