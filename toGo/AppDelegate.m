//
//  AppDelegate.m
//  toGo
//
//  Created by Babul Rao on 14/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "AppDelegate.h"


#import <ooVooSDK/ooVooSDK.h>
#import "FileLogger.h"

#import "UserDefaults.h"
//#import "SettingBundle.h"

#import <GooglePlus/GooglePlus.h>
#import "WebLoginControllerViewController.h"

#import "MessageManager.h"
#import "AlertView.h"
#import "ActiveUserManager.h"
#import "Constants.h"
#define User_isInVideoView @"User_isInVideoView"




#define APP_TOKEN_SETTINGS_KEY    @"APP_TOKEN_SETTINGS_KEY"
#define LOG_LEVEL_SETTINGS_KEY    @"LOG_LEVEL_SETTINGS_KEY"
#define APP_VIDEO_RENDER            @"APP_VIDEO_RENDER"
#define APP_MESSAGING            @"APP_MESSAGING"


#ifndef TOKEN
#define TOKEN @"MDAxMDAxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZUYVW%2BB1MwyBDpt22C0WvOeMPW7fH6mMOv8d%2FAPeFZ2QeCOguU288bRzsChrixFyZ%2BKzm9nrLmfOkZwyPrAO%2BDP8wgDiVtL%2F0w9mZQ78Az5Hk6imDbhYGNGRFMqo0H2virlVE4Q%2Bpf5S%2Fm50MO%2BMh"
#endif


@interface AppDelegate ()<UIAlertViewDelegate>{
    AlertView *alert ;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        
    [Fabric with:@[[Crashlytics class], [Twitter class]]];

    
    [self subscribePushNotifications:application];
    
    self.sdk = [ooVooClient sharedInstance];
    self.callingUsers = [NSMutableArray new];
#ifdef DEBUG
    NSLog(@"Debug mode no Hockey");
#else

#endif
    
    
    
    [UserDefaults setBool:NO ToKey:User_isInVideoView];
    [self setUpGooglePlusConfiguration];
    [self setupConnectionParameters];
    
    
    [[MessageManager sharedMessage]initSdkMessage]; // a singeltone for retrieve a message of a incoming call
    
    navigationController = (UINavigationController *)self.window.rootViewController;
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main_ooVoo" bundle: nil];
    
    viewVideoControler = (VideoConferenceVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoConferenceVC"];
    NSLog(@"***********************   didFinishLaunchingWithOptions  ****************************");
    [self SetNotificationObserversForCallMessaging];
    
    
    NSLog(@"%d",[UserDefaults getBoolForToKey:APP_VIDEO_RENDER]);
    
    
    ///////// Nav Bar Image  /////////
    /* //WORKINg CODE for Image
    UIImage *gradientImage32 = [[UIImage navigationBarImage] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage navigationBarImage]
                                       forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:gradientImage32 forBarMetrics:UIBarMetricsDefault];
    */
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor  navigationBarColor]];
    
    ////////////////////////////////////////////
    
    //[self performSelector:@selector(crashButtonTapped:) withObject:nil afterDelay:0];
    return YES;
}


- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}

-(void)setUpGooglePlusConfiguration{
    
    /////////////////////////  GPPSignIn  Google_Plus   //////////////////////////////
    /*
     //IMPORTANT STEPS  - Google_Plus
     1. Please add "Principal class" key in info plist with data "Application"
     2. Please add "GooglePlusClientID" key in info plist -  Create Client Id from - https://developers.google.com/+/mobile/ios/getting-started
     3. Please add "WebLoginControllerViewController" Files in your project
     */
    GPPSignIn *sign = [GPPSignIn sharedInstance] ;
    [GPPSignIn sharedInstance].clientID = GooglePlusClientID;
    // Read Google+ deep-link data.
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openWebView:) name:@"ApplicationOpenGoogleAuthNotification" object:nil];
    /////////////////////   Google_Plus END   ////////////////////////////////////
}



/*
- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}
*/


- (void)applicationWillResignActive:(UIApplication *)application {
    [ooVooClient applicationWillResignActive];
    
    bool isMessaging = [[[NSUserDefaults standardUserDefaults] stringForKey:APP_MESSAGING]boolValue];
    if (!isMessaging) {
        ooVooClient *sdk = [ooVooClient sharedInstance];
        [sdk.Messaging disconnect];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [ooVooClient applicationDidEnterBackground];
    ooVooClient *sdk = [ooVooClient sharedInstance];
    [sdk.AVChat.VideoController stopTransmitVideo];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [ooVooClient applicationWillEnterForeground];
    ooVooClient *sdk = [ooVooClient sharedInstance];
    [sdk.AVChat.VideoController startTransmitVideo];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [ooVooClient applicationDidBecomeActive];
    
    bool isMessaging = [[[NSUserDefaults standardUserDefaults] stringForKey:APP_MESSAGING]boolValue];
    if (!isMessaging) {
        ooVooClient *sdk = [ooVooClient sharedInstance];
        [sdk.Messaging connect];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Configuration
- (void)setupConnectionParameters
{
    
    // accours only once on first run - set first value
    NSDictionary *dicAppToken = [NSDictionary dictionaryWithObject:TOKEN forKey:APP_TOKEN_SETTINGS_KEY];
    NSDictionary *dicAppLogLevl = [NSDictionary dictionaryWithObject:@6 forKey:LOG_LEVEL_SETTINGS_KEY];
    NSDictionary *dicAppRender = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:false] forKey:APP_VIDEO_RENDER];
    NSDictionary *dictAppMessaging = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:true] forKey:APP_MESSAGING];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicAppLogLevl];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicAppToken];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicAppRender];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictAppMessaging];
    
    [NSUserDefaults standardUserDefaults].synchronize;
    
    // if something changed by the user in the setting bundle
    NSString *curAppToken = [[NSUserDefaults standardUserDefaults] stringForKey:APP_TOKEN_SETTINGS_KEY];
    bool isVideoRender = [[NSUserDefaults standardUserDefaults] stringForKey:APP_VIDEO_RENDER];
    
    int curLogLevel = [[NSUserDefaults standardUserDefaults]  integerForKey:LOG_LEVEL_SETTINGS_KEY];
    NSNumber *logLevel = [NSNumber numberWithInt:curLogLevel];
    
    NSLog(@"value %@", [[NSUserDefaults standardUserDefaults] stringForKey:APP_MESSAGING]);
    bool isMessaging = [[[NSUserDefaults standardUserDefaults] stringForKey:APP_MESSAGING]boolValue];
    
    [[NSUserDefaults standardUserDefaults] setValue:curAppToken forKey:APP_TOKEN_SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:logLevel forKey:LOG_LEVEL_SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:isMessaging forKey:APP_MESSAGING];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}














/*

// orientation

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([self isIpad]) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return ( UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskPortrait);
}
-(BOOL)shouldAutorotate
{
    return YES;
}


-(BOOL)isIpad{
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
    
    if ( IDIOM == IPAD ) {
        return true;
    } else {
        return  false;
    }
}
*/

- (void)SetNotificationObserversForCallMessaging {
    NSLog(@"@@@@@@@@@@@@@@@@@@@@@  SetNotificationObserversForCallMessaging  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(incomingCall:) name:@"incomingCall" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AnswerAccept:) name:@"AnswerAccept" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(killVideoController) name:@"killVideoController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callCancel) name:@"callCancel" object:nil];
    
}

-(void)incomingCall:(NSNotification*)notif{
    
    NSLog(@"notification %@",notif.userInfo);
    CNMessage *message=[notif object];
    
    // if we are in video "ROOM" and i am transmitting video on other session Than i am busy
    if ([navigationController.topViewController isKindOfClass:[VideoConferenceVC class]])
    {
        VideoConferenceVC *viewController = navigationController.topViewController;
        
        if (viewController.isViewInTransmitMode && !viewController.conferenceId)
        {
            [[MessageManager sharedMessage]messageOtherUsers:[NSArray arrayWithObject:message.fromUseriD]  WithMessageType:Busy WithConfID:viewVideoControler.conferenceId Compelition:^(BOOL CallSuccess) {
                
            }];
            return;
        }
    }
    //    else if ([navigationController.topViewController isKindOfClass:[VideoConferenceVCWithRender class]])
    //    {
    //        VideoConferenceVCWithRender *viewController = navigationController.topViewController;
    //
    //        if (viewController.isViewInTransmitMode && !viewController.conferenceId)
    //        {
    //            [[MessageManager sharedMessage]messageOtherUser:message.fromUseriD WithMessageType:Busy WithConfID:viewVideoControllerRender.conferenceId];
    //            return;
    //        }
    //
    //    }
    
    NSLog(@"################### incomingCall ###########################");
    alert = [[AlertView alloc]initWithTitle:@"Incoming Call" message:message.fromUseriD delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Answer", nil];
    alert.from=message.fromUseriD;
    alert.conferenceID=message.confId;
    
    [alert show];
}

-(void)AnswerAccept:(NSNotification*)notif // after i called other user HE accepted my call
{
    
    NSLog(@"notification %@",notif.userInfo);
    CNMessage *message=[notif object];
    
    [self passToVideoConferenceWithConferenceId:message.confId fromUserID:message.fromUseriD];
    
}



-(void)killVideoController{
    viewVideoControler=nil;
    viewVideoControler = (VideoConferenceVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoConferenceVC"];
    
    //    viewVideoControllerRender=nil;
    //    viewVideoControllerRender = (VideoConferenceVCWithRender*)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoConferenceVCWithRender"];
    
    
}

-(void)callCancel{
    // the caller canceled his call than remove alert
    [alert dismissWithClickedButtonIndex:2 animated:YES]; // no real index 2 button , means call canceled
}

#pragma mark - Alertview Delegate

-(void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //    call canceled by the caller
    if (buttonIndex==2)
    {
        alertView=nil;
        return;
    }
    if (buttonIndex!=alertView.cancelButtonIndex) // I accepted the call
    {
        //     if (![UserDefaults getBoolForToKey:@"APP_VIDEO_RENDER"]) // if it's oovoo panel render
        {
            if (viewVideoControler.conferenceId)
            { // if there is allready a conference id send it
                [[MessageManager sharedMessage]messageOtherUsers:[NSArray arrayWithObject:alertView.from] WithMessageType:AnswerAccept WithConfID:viewVideoControler.conferenceId Compelition:^(BOOL CallSuccess) {
                    
                }] ;
            }
            else
            { // this a new conference so we take the id from the user that called
                
                
                [[MessageManager sharedMessage]messageOtherUsers:[NSArray arrayWithObject:alertView.from] WithMessageType:AnswerAccept WithConfID:alertView.conferenceID Compelition:^(BOOL CallSuccess) {
                    
                }];
                
                // if i am in the room video but not is a transmited mode then make it be i transmitted mode
                if ([navigationController.topViewController isKindOfClass:[VideoConferenceVC class]])
                {
                    VideoConferenceVC *viewController = navigationController.topViewController;
                    viewController.isCommingFromCall=true;
                    viewController.conferenceId=alertView.conferenceID;
                    viewController.isCommingFromCall=true;
                    [viewController act_joinConference:nil];
                }
                else
                {
                    [self passToVideoConferenceWithConferenceId:alertView.conferenceID fromUserID:alertView.from];
                }
            }
            
        }
        //        else{
        //
        //            if (viewVideoControllerRender.conferenceId)
        //            { // if there is allready a conference id send it
        //                [[MessageManager sharedMessage]messageOtherUser:alertView.from WithMessageType:AnswerAccept WithConfID:viewVideoControler.conferenceId];
        //            }
        //            else
        //            { // this a new conference so we take the id from the user that called
        //
        //
        //                [[MessageManager sharedMessage]messageOtherUser:alertView.from WithMessageType:AnswerAccept WithConfID:alertView.conferenceID];
        //
        //                // if i am in the room video but not is a transmited mode then make it be i transmitted mode
        //                if ([navigationController.topViewController isKindOfClass:[VideoConferenceVCWithRender class]])
        //                {
        //                    VideoConferenceVCWithRender *viewController = navigationController.topViewController;
        //                    viewController.isCommingFromCall=true;
        //                    viewController.conferenceId=alertView.conferenceID;
        //                    viewController.isCommingFromCall=true;
        //                    [viewController act_joinConference:nil];
        //                }
        //                else
        //                {
        //                    [self passToVideoConferenceWithConferenceId:alertView.conferenceID fromUserID:alertView.from];
        //                }
        //            }
        //
        //        }
        
        
        
    }
    else // I rejected the call
    {
        [[MessageManager sharedMessage]messageOtherUsers:[NSArray arrayWithObject:alertView.message] WithMessageType:AnswerDecline WithConfID:alertView.conferenceID Compelition:^(BOOL CallSuccess) {
            
        }];
    }
    
    alertView=nil;
}


-(void)passToVideoConferenceWithConferenceId:(NSString*)confID fromUserID:(NSString*)userID{
    
    //  if (![UserDefaults getBoolForToKey:@"APP_VIDEO_RENDER"]) // if it's oovoo panel render
    {
        viewVideoControler.isCommingFromCall=true;
        viewVideoControler.conferenceId=confID;
        
        
        NSLog(@"In Pass to video converence PUSH with conferenceid %@",confID);
        
        
        
        
        if(![navigationController.topViewController isKindOfClass:[VideoConferenceVC class]])
        {// if view controller is not shown yet
            
            @try {
                [navigationController pushViewController:viewVideoControler animated:NO];
            } @catch (NSException * ex) {
                NSLog(@"Exception: %@", ex);
                //“Pushing the same view controller instance more than once is not supported”
                //NSInvalidArgumentException
                NSLog(@"Exception: [%@]:%@",[ex  class], ex );
                NSLog(@"ex.name:'%@'", ex.name);
                NSLog(@"ex.reason:'%@'", ex.reason);
                //Full error includes class pointer address so only care if it starts with this error
                NSRange range = [ex.reason rangeOfString:@"Pushing the same view controller instance more than once is not supported"];
                
                if ([ex.name isEqualToString:@"NSInvalidArgumentException"] &&
                    range.location != NSNotFound) {
                    //view controller already exists in the stack - just pop back to it
                    [navigationController popToViewController:viewVideoControler animated:NO];
                } else {
                    NSLog(@"ERROR:UNHANDLED EXCEPTION TYPE:%@", ex);
                }
            }
            @finally {
                //NSLog(@"finally");
            }
            
            
        }
        else // view is allready on
        {
            
        }
        
    }
    //    else
    //    {
    //        viewVideoControllerRender.isCommingFromCall=true;
    //        viewVideoControllerRender.conferenceId=confID;
    //
    //
    //        NSLog(@"In Pass to video converence PUSH with conferenceid %@",confID);
    //
    //
    //        if(![navigationController.topViewController isKindOfClass:[VideoConferenceVCWithRender class]])
    //        {// if view controller is not shown yet
    //            [navigationController pushViewController:viewVideoControllerRender animated:YES];
    //        }
    //        else // view is allready on
    //        {
    //
    //        }
    //    }
}



#pragma mark - Push notification

-(void)subscribePushNotifications : (UIApplication *)application{
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    #ifdef __IPHONE_8_0
            UIUserNotificationType types = UIUserNotificationTypeBadge |
            UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            //
            UIUserNotificationSettings *mySettings =
            [UIUserNotificationSettings settingsForTypes:types categories:nil];
            //
            [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
            [application registerForRemoteNotifications];
    #endif
        } else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [application registerForRemoteNotificationTypes:myTypes];
        }
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    [ActiveUserManager activeUser].token = hexToken;
    NSLog(@"My token is: %@", [ActiveUserManager activeUser].token);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"user info %@",userInfo);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
}


#pragma mark Google_Plus Start
//Google_Plus
-(void)openWebView:(NSNotification *)noti{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    WebLoginControllerViewController *obj = (WebLoginControllerViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"WebLoginControllerViewController"];
    [obj loadURL:noti.object];
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
        [navi.visibleViewController presentViewController:obj animated:YES completion:nil];
    }else{
        [self.window.rootViewController presentViewController:obj animated:YES completion:nil];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation] ||[GPPURLHandler handleURL:url
                                                                                       sourceApplication:sourceApplication
                                                                                              annotation:annotation];
    /*
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
    */
}

#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alertView = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alertView show];
    alertView = nil;
}

#pragma mark Google_Plus END


-(void)takeTour
{
    NSString *curentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    curentVersion = [curentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    [TakeTourView launchTakeTourViewWithNewVersion:YES];
}

-(void)getLanguages{
    //WEB Service CODE
    [Utility_Shared_Instance showProgress];
    self.languagesArray = [NSMutableArray new];
    [Web_Service_Call serviceCallWithRequestType:nil requestType:GET_REQUEST includeHeader:YES includeBody:NO webServicename:GET_LANGUAGES_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            NSMutableArray *dataArray = [responseDict objectForKey:KDATA_W];
            for (id json in dataArray) {
                LanguageObject *lObj = [LanguageObject new];
                NSString *iconStr = [json objectForKey:KICON_W];
                iconStr = [iconStr stringByReplacingOccurrencesOfString:@"<img src='" withString:@""];
                iconStr = [iconStr stringByReplacingOccurrencesOfString:@"'  />" withString:@""];
                lObj.imagePathString = [NSString stringWithFormat:@"%@%@",BASE_URL,iconStr];
                lObj.languageName = [json objectForKey:KLANGUAGE_W];
                lObj.languageCode = [json objectForKey:KLANGUAGEID_W];
                [self.languagesArray addObject:lObj];
            }
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}


@end

