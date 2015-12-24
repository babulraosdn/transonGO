//
//  LoginViewController.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "LoginViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AppDelegate.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "DashBoardViewController.h"
#import "SlideMenuViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>//DropDownDelegate
{
    NSMutableDictionary *loginDictionary;
    NSMutableArray *loginArray;
    SocialView *socialView;
    AppDelegate  *appDelegate;

}

//@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)linkedInButtonPressed:(id)sender;

-(void)loginAuthentication;
@end

@implementation LoginViewController
@dynamic emailLabel,emailTextField,submitButton,forgetPasswordButton,signUpButton;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    socialView=[SocialView new];
    socialView.delegate=self;
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
  //  [self setBackButtonForNavigation];
    self.title = NSLOCALIZEDSTRING(@"LOGIN");
    //[self setBackButtonForNavigation];
    loginArray = [[NSMutableArray alloc]initWithObjects:NSLOCALIZEDSTRING(@"EMAIL"),NSLOCALIZEDSTRING(@"PASSWORD"), nil];
    loginDictionary = [NSMutableDictionary new];
    
    self.emailLabel.text = NSLOCALIZEDSTRING(@"EMAIL");
    self.passwordLabel.text = NSLOCALIZEDSTRING(@"PASSWORD");
    self.submitButton.titleLabel.text = NSLOCALIZEDSTRING(@"SUBMIT");
    self.forgetPasswordButton.titleLabel.text=NSLOCALIZEDSTRING(@"FORGET_PASSWORD");
    self.signUpButton.titleLabel.text=NSLOCALIZEDSTRING(@"SIGNUP");
    self.emailTextField.placeholder=NSLOCALIZEDSTRING(@"EMAIL");
    self.passwordTextField.placeholder=NSLOCALIZEDSTRING(@"PASSWORD");
    

    
    self.emailTextField.tag=0;
    self.emailTextField.returnKeyType    = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.tag=1;
    
    if (!self.textFieldDelegate) {
        self.textFieldDelegate = [[CustomTextFieldDelegate alloc]init];
        self.textFieldDelegate.owner =  self;
    }
    //self.emailTextField.delegate=self.textFieldDelegate;
    //self.passwordTextField.delegate=self.textFieldDelegate;
    self.textFieldDelegate.selector = @selector(webServiceCall:);
    self.textFieldDelegate.owner =  self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self  performSelector:@selector(googleButtonClicked:) withObject:nil afterDelay:0.5];
}


#pragma mark UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [loginDictionary setObject:textField.text forKey:[loginArray objectAtIndex:textField.tag]];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)webServiceCall:(id)sender {
    
    [self createSidePanel];
    /*
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://redrocksonline.com/api/events"]];
    
    // Initialize Session Configuration
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Initialize Session Manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    // Configure Manager
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        // Send Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

   [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

       // Process Response Object
    }] resume];
   */
    
    //[self performSelector:@selector(crashTestWednesDayAfterNoon:)];
    [self.view endEditing:YES];
//    CommonClass* obj = [[CommonClass alloc]init];
//    [obj navigateToSlideMenu];

    /*
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    appDelegate.window.rootViewController = [storyboard instantiateInitialViewController];
    [appDelegate.window makeKeyAndVisible];
    */
    
    if (self.emailTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.emailTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![Utility_Shared_Instance validateEmailWithString:self.emailTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"VALID_EMAILID")]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (self.passwordTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.passwordTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    
    else{
        
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"LOGIN_SUCCESS")]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
        [self loginAuthentication];
    }
    
    
    /*
    for (id value in loginArray) {
        if (![loginDictionary objectForKey:value] || [[loginDictionary objectForKey:value] length]<1) {
            [Utility_Shared_Instance showMessageWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME) andMessage:[NSString messageWithString:value]];
            break;
        }
        if (![Utility_Shared_Instance validateEmailWithString:[loginDictionary objectForKey:NSLOCALIZEDSTRING(@"EMAIL")]]) {
            [Utility_Shared_Instance showMessageWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME) andMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"VALID_EMAILID")]];
            return;
        }
    }
      [self loginAuthentication];
    */
    //Web Service CODE
    
    // Paradigm --
    //
}

- (IBAction)facebookButtonPressed:(id)sender {
    
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"Please wait...")]];
    [socialView faceBookLogin];
}

- (IBAction)twitterButtonPressed:(id)sender {
    
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"Please wait...")]];
    [socialView twitterLogin];
}

- (IBAction)linkedInButtonPressed:(id)sender {
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"Please wait...")]];
    [socialView linkedInLogin];
}

-(void)loginAuthentication{

    //CommonClass* obj = [[CommonClass alloc]init];
    //[obj navigateToSlideMenu];
    
    NSString *payload = [Utility_Shared_Instance preparePayloadForDictionary:loginDictionary];
    [Web_Service_Call serviceCall:payload webServicename:LOGIN SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *dict=responseObject;
        NSLog(@"Response dict SUCCESS: %@",dict);
        /*
         Printing description of responseObject:
         {
         msg = "Missing Parameters";
         success = 0;
         }
         */
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
    }];
}


-(void)finishLogin:(NSString *)mediaType responseDict:(NSMutableDictionary *)response
//-(void)finishLogin:(NSMutableDictionary *)response
{
    [SVProgressHUD dismiss];

    BOOL success;
    if ([mediaType isEqualToString:FACEBOOK]) {
        /*
         {
         id = 989871441071596;
         name = "Babul Rao";
         profileImage = "https://graph.facebook.com/989871441071596/picture?type=large&return_ssl_resources=1";
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
         {
         contributors = "<null>";
         coordinates = "<null>";
         "created_at" = "Mon Oct 12 11:28:58 +0000 2015";
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
         id = 653532807956963328;
         "id_str" = 653532807956963328;
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
         "created_at" = "Tue May 05 13:16:29 +0000 2015";
         "default_profile" = 1;
         "default_profile_image" = 1;
         description = "";
         entities =         {
         description =             {
         urls =                 (
         );
         };
         };
         "favourites_count" = 1;
         "follow_request_sent" = 0;
         "followers_count" = 0;
         following = 0;
         "friends_count" = 1;
         "geo_enabled" = 1;
         "has_extended_profile" = 0;
         id = 3186168372;
         "id_str" = 3186168372;
         "is_translation_enabled" = 0;
         "is_translator" = 0;
         lang = en;
         "listed_count" = 0;
         location = "";
         name = redrocksdn;
         notifications = 0;
         "profile_background_color" = C0DEED;
         "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
         "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
         "profile_background_tile" = 0;
         "profile_image_url" = "http://abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png";
         "profile_image_url_https" = "https://abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png";
         "profile_link_color" = 0084B4;
         "profile_sidebar_border_color" = C0DEED;
         "profile_sidebar_fill_color" = DDEEF6;
         "profile_text_color" = 333333;
         "profile_use_background_image" = 1;
         protected = 0;
         "screen_name" = redrocksdn;
         "statuses_count" = 31;
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
//        CommonClass* obj = [[CommonClass alloc]init];
//        [obj navigateToSlideMenu];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//        if (isBusinessSelected) {
//            [self navigateToBussinessStep1Controller:proDic socialType:3];
//        }else{
//            [self navigateToPersonalStep1Controller:proDic socialType:3];
//        }
        
    }
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
