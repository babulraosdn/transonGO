//
//  AppDelegate.m
//  toGo
//
//  Created by Babul Rao on 14/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "AppDelegate.h"
#import <GooglePlus/GooglePlus.h>
#import "WebLoginControllerViewController.h"
#import "Constants.h"

#import <ooVooSDK/ooVooSDK.h>
#import "FileLogger.h"

#import "UserDefaults.h"
#import "MessageManager.h"
#import "AlertView.h"
#import "ActiveUserManager.h"
#import "MenuConferenceVC.h"
#import "MessageManager.h"
#import <QuartzCore/QuartzCore.h>
#define User_isInVideoView @"User_isInVideoView"

#define APP_TOKEN_SETTINGS_KEY    @"12349983355077"
#define LOG_LEVEL_SETTINGS_KEY    @"LOG_LEVEL_SETTINGS_KEY"
#define APP_VIDEO_RENDER          @"APP_VIDEO_RENDER"
#define APP_MESSAGING            @"APP_MESSAGING"

#define DEVICE_TOKEN            @"DEVICE_TOKEN"
#define USER_ID                 @"USER_ID"


#ifndef TOKEN
#define TOKEN @"MDAxMDAxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZUYVW%2BB1MwyBDpt22C0WvOeMPW7fH6mMOv8d%2FAPeFZ2QeCOguU288bRzsChrixFyZ%2BKzm9nrLmfOkZwyPrAO%2BDP8wgDiVtL%2F0w9mZQ78Az5Hk6imDbhYGNGRFMqo0H2virlVE4Q%2Bpf5S%2Fm50MO%2BMh"
#endif


@interface AppDelegate ()<UIAlertViewDelegate>{
    AlertView *alert ;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (![Utility_Shared_Instance readStringUserPreference:KDEVICE_TOKEN]) {
        [Utility_Shared_Instance writeStringUserPreference:KDEVICE_TOKEN value:@"gh22hh22hh22jj22jj22jj2222hhhh22"];
    }
    
    self.cdrObject = [CDRObject new];
    self.interpreterListArray = [NSMutableArray new];
    [Fabric with:@[[Crashlytics class], [Twitter class]]];
    [self subscribePushNotifications:application];
    self.callingUsers = [NSMutableArray new];
    [self setUpGooglePlusConfiguration];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor  navigationBarColor]];
    
    //////
    [ActiveUserManager activeUser].token =[UserDefaults getObjectforKey:DEVICE_TOKEN];
    [ActiveUserManager activeUser].userId =[UserDefaults getObjectforKey:USER_ID];
    NSLog(@"My token is: %@", [ActiveUserManager activeUser].token);
    NSLog(@"[ActiveUserManager activeUser].userId--->: %@", [ActiveUserManager activeUser].userId);
    
    self.callingUsers = [NSMutableArray new];
    
    #ifdef DEBUG
        NSLog(@"Debug mode no Hockey");
    #else
    #endif
    
    [UserDefaults setBool:NO ToKey:User_isInVideoView];
    
    [self setupConnectionParameters];
    
    
    [[MessageManager sharedMessage]initSdkMessage];
    // a singeltone for retrieve a message of a incoming call
    
    {
        
        navigationController = (UINavigationController *)self.window.rootViewController;
    }
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    
    viewVideoControler = (VideoConferenceVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoConferenceVC"];
    
    NSLog(@"APP_VIDEO_RENDER---->%d",[UserDefaults getBoolForToKey:APP_VIDEO_RENDER]);
    
    
    
    
    // Handle launching from a notification
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Recieved Notification %@",localNotif);
    }
    
    
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
    //////////
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

-(void)getLanguages {
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
                iconStr = [iconStr stringByReplacingOccurrencesOfString:@"  >" withString:@""];
                iconStr = [iconStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                lObj.imagePathString = [NSString stringWithFormat:@"%@%@",BASE_URL,iconStr];
                lObj.languageName = [json objectForKey:KLANGUAGE_W];
                lObj.languageID = [json objectForKey:KLANGUAGEID_W];
                [self.languagesArray addObject:lObj];
            }
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

///////

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification  *)notif {
    // Handle the notificaton when the app is running
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Recieved Notification %@",notif);
}



- (void)applicationWillResignActive:(UIApplication *)application {
        //1st when enter to Back ground
//        [ooVooClient applicationWillResignActive];
//    
//        bool isMessaging = [[[NSUserDefaults standardUserDefaults] stringForKey:APP_MESSAGING]boolValue];
//        if (!isMessaging) {
//            ooVooClient *sdk = [ooVooClient sharedInstance];
//            [sdk.Messaging disconnect];
//        }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
     //2nd when enter to Back ground
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
//    
//        [ooVooClient applicationDidEnterBackground];
//        ooVooClient *sdk = [ooVooClient sharedInstance];
//        [sdk.AVChat.VideoController stopTransmitVideo];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
        //1st when enter to Fore ground
        [ooVooClient applicationWillEnterForeground];
        ooVooClient *sdk = [ooVooClient sharedInstance];
        [sdk.AVChat.VideoController startTransmitVideo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     //2nd when enter to Fore ground
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
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

- (void)SetNotificationObserversForCallMessaging {
    NSLog(@"@@@@@@@@@@@@@@@@@@@@@  SetNotificationObserversForCallMessaging  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"incomingCall" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AnswerAccept" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"killVideoController" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callCancel" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(incomingCall:) name:@"incomingCall" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AnswerAccept:) name:@"AnswerAccept" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(killVideoController) name:@"killVideoController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callCancel) name:@"callCancel" object:nil];
    
}

- (void)UnSetNotificationObserversForCallMessaging
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"incomingCall" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AnswerAccept" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"killVideoController" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callCancel" object:nil];
}
-(void)incomingCall:(NSNotification*)notif{
    
    if ([[Utility_Shared_Instance readStringUserPreference:USER_TYPE] isEqualToString:INTERPRETER]){
        //[self playSystemLineSound];
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = [NSDate date];//date;  // date after 10 sec from now
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        // Notification details
        localNotif.alertBody =  @"Someone is calling you for interpretation."; // text of you that you have fetched
        // Set the action button
        localNotif.alertAction = @"View";
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        
        // Specify custom data for the notification
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        localNotif.userInfo = infoDict;
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        
        
        NSLog(@"notification %@",notif.userInfo);
        CNMessage *message=[notif object];
        
        // if we are in video "ROOM" and i am transmitting video on other session Than i am busy
        if ([navigationController.topViewController isKindOfClass:[VideoConferenceVC class]])
        {
            VideoConferenceVC *viewController = (VideoConferenceVC *) self.naviController.topViewController;
            
            if (viewController.isViewInTransmitMode && !viewController.conferenceId)
            {
                [[MessageManager sharedMessage]messageOtherUsers:[NSArray arrayWithObject:message.fromUseriD]  WithMessageType:Busy WithConfID:viewVideoControler.conferenceId Compelition:^(BOOL CallSuccess) {
                    
                }];
                
                return;
            }
            
        }

        NSLog(@"################### incomingCall ###########################");
        
        alert = [[AlertView alloc]initWithTitle:@"Someone is calling you for interpretation." message:@"" delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Answer", nil];
        alert.from=message.fromUseriD;
        alert.conferenceID=message.confId;
        
        [alert show];
    }

}

-(void)orderInterpreattionObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(killVideoController) name:@"killVideoController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callCancel) name:@"callCancel" object:nil];
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
}

-(void)callCancel{
    // the caller canceled his call than remove alert
    NSLog(@"------callCancel-->%f",[[NSDate date] timeIntervalSince1970]);
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
    }
    else // I rejected the call
    {
        [[MessageManager sharedMessage]messageOtherUsers:[NSArray arrayWithObject:alertView.message] WithMessageType:AnswerDecline WithConfID:alertView.conferenceID Compelition:^(BOOL CallSuccess) {
            
        }];
    }
    
    alertView=nil;
    
}


-(void)passToVideoConferenceWithConferenceId:(NSString*)confID fromUserID:(NSString*)userID{
    
    {
        viewVideoControler.isCommingFromCall=true;
        viewVideoControler.conferenceId=confID;
        
        
        NSLog(@"In Pass to video converence PUSH with conferenceid %@",confID);
        
        
        
        
        if(![navigationController.topViewController isKindOfClass:[VideoConferenceVC class]])
        {// if view controller is not shown yet
            
            @try {
                [self.naviController pushViewController:viewVideoControler animated:NO];
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
                    [self.naviController popToViewController:viewVideoControler animated:NO];
                }else {
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
}

#pragma mark - Push notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString:@""];
    
    NSLog(@"deviceToken:%@",devToken);
    
    
    NSLog(@"My token is: %@", deviceToken);
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    [ActiveUserManager activeUser].token = hexToken;
    
    [Utility_Shared_Instance writeStringUserPreference:hexToken value:KDEVICE_TOKEN];
    
    [UserDefaults setObject:hexToken ForKey:DEVICE_TOKEN];
    NSLog(@"My token is: %@", [ActiveUserManager activeUser].token);
    NSLog(@"[ActiveUserManager activeUser].userId--->: %@", [ActiveUserManager activeUser].userId);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"user info %@",userInfo);
    
    NSLog(@"%% didReceiveRemoteNotification");
    
    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}



-(void)playSystemSound{
    
    NSString *path = [NSString stringWithFormat:@"%@/video incoming call rev.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    
    [self initAudioSoundWith:soundUrl];
    
    [_audioPlayer play];
    
}

-(void)initAudioSoundWith:(NSURL*)url{
    
    if (_audioPlayer) {
        _audioPlayer.delegate=nil;
        _audioPlayer=nil;
    }

}

-(void)playSystemLineSound{
    
    NSString *path = [NSString stringWithFormat:@"%@/CallLine.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    [self initAudioSoundWith:soundUrl];
    [_audioPlayer play];
    
    
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    if([_audioPlayer play]){
        newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    }
    [self initAudioSoundWith:soundUrl];
    [_audioPlayer play];
    
    if([_audioPlayer play]){
        newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    }
    [self initAudioSoundWith:soundUrl];
    [_audioPlayer play];
    
    
}

#pragma mark - AVAudioFoundation Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [player play];
}

-(void)stopCallSound{
    [_audioPlayer stop];
    _audioPlayer.delegate=nil;
    _audioPlayer=nil;
}

-(void)killVideoView{
     self.sdk = [ooVooClient sharedInstance];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"killVideoController" object:nil];
    [self.sdk.AVChat leave];
    [self.sdk.AVChat.AudioController unInitAudio:^(SdkResult *result) {
        NSLog(@"unInit Resoult %d",result.Result);
    }];
}
////////////

-(void)saveDisconnectedCallDetailsinServer : (InterpreterListObject *)receivedInterpreter isNoOnePicksCallorEndedByCustomer:(BOOL)isNoOnePicksCallorEndedByCustomer {
    
    //WEB Service CODE
    [Utility_Shared_Instance showProgress];
    NSMutableArray *disconnectedInterpreters = [NSMutableArray new];
    InterpreterListObject *tempObj;
    for (InterpreterListObject *iObj in self.interpreterListArray) {
        tempObj = iObj;
        {
            [disconnectedInterpreters addObject:iObj.idString];
        }
    }

    NSMutableDictionary *callDict= [NSMutableDictionary new];
    [callDict setObject:[Utility_Shared_Instance checkForNullString:tempObj.poolIdString] forKey:KPOOL_ID_W];
    [callDict setObject:[Utility_Shared_Instance checkForNullString:[Utility_Shared_Instance readStringUserPreference:KID_W]] forKey:KUSER_ID_W];
    [callDict setObject:disconnectedInterpreters forKey:KINTERPRETER_ID_W];
    [callDict setObject:[Utility_Shared_Instance GetCurrentTimeStamp] forKey:KSTART_TIME_W];
    
    if (!isNoOnePicksCallorEndedByCustomer) {
        
        [callDict setObject:[Utility_Shared_Instance checkForNullString:self.cdrObject.receivedInterpreter.uidString] forKey:KCALL_RECEIVED_BY_W];
        [callDict setObject:[Utility_Shared_Instance checkForNullString:self.cdrObject.conferenceIDString] forKey:KCALLID_W];
        [callDict setObject:[Utility_Shared_Instance checkForNullString:[Utility_Shared_Instance GetCurrentTimeStamp]] forKey:KSTART_TIME_W];
    }
    
    [Web_Service_Call serviceCallWithRequestType:callDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:SAVE_CALL_DETAILS SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            if ([responseDict objectForKey:KDATA_W]) {
                NSMutableArray *dataArray = [responseDict objectForKey:KDATA_W];
                for (id json in dataArray) {
                    LanguageObject *lObj = [LanguageObject new];
                    NSString *iconStr = [json objectForKey:KICON_W];
                    iconStr = [iconStr stringByReplacingOccurrencesOfString:@"<img src='" withString:@""];
                    iconStr = [iconStr stringByReplacingOccurrencesOfString:@"'  />" withString:@""];
                    lObj.imagePathString = [NSString stringWithFormat:@"%@%@",BASE_URL,iconStr];
                    lObj.languageName = [json objectForKey:KLANGUAGE_W];
                    lObj.languageID = [json objectForKey:KLANGUAGEID_W];
                    [self.languagesArray addObject:lObj];
                }
            }
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

-(void)saveCDR{
    
    if(!self.isCallDisconnectOrCallEndDefault){
        //WEB Service CODE
        [Utility_Shared_Instance showProgress];
        
        NSMutableDictionary *callDict= [NSMutableDictionary new];
        [callDict setObject:self.cdrObject.receivedInterpreter.poolIdString forKey:KPOOL_ID_W];
        [callDict setObject:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KUSER_ID_W];
        NSMutableArray *interpreters = [NSMutableArray new];
        for (InterpreterListObject *iObj in self.interpreterListArray) {
            [interpreters addObject:iObj.idString];
        }
        [callDict setObject:interpreters forKey:KINTERPRETER_ID_W];
        [callDict setObject:[Utility_Shared_Instance checkForNullString:self.cdrObject.receivedInterpreter.uidString] forKey:KCALL_RECEIVED_BY_W];
        [callDict setObject:self.cdrObject.fromLanguageIDString forKey:KFROM_LANGUAGE_small_L_Leter_W];
        [callDict setObject:self.cdrObject.toLanguageIDString forKey:KTO_LANGUAGE_small_L_Leter_W];
        [callDict setObject:self.cdrObject.startTimeString forKey:KSTART_TIME_W];
        [callDict setObject:self.cdrObject.endTimeString forKey:KEND_TIME_W];
        [callDict setObject:self.cdrObject.costString forKey:KCOST_W];
        
        [Web_Service_Call serviceCallWithRequestType:callDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:CREATE_CDR SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
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
                    lObj.languageID = [json objectForKey:KLANGUAGEID_W];
                    [self.languagesArray addObject:lObj];
                }
            }
        } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
    }
}


-(void)updateInterpreterCallStatus {
    
    //WEB Service CODE
    [Utility_Shared_Instance showProgress];
    
    NSMutableDictionary *callDict= [NSMutableDictionary new];
    int yourInt = 0;
    [callDict setObject:[Utility_Shared_Instance readStringUserPreference:KUID_W] forKey:@"id"];
    [callDict setObject:[NSNumber numberWithInt:yourInt] forKey:KCALL_STATUS_W];
    [callDict setObject:[Utility_Shared_Instance readStringUserPreference:KEMAIL_W] forKey:KEMAIL_ID_W];
    
    [Web_Service_Call serviceCallWithRequestType:callDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:UPDATE_INTERPRETER_CALL_STATUS SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
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
                lObj.languageID = [json objectForKey:KLANGUAGEID_W];
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

