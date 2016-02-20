//
//  AppDelegate.h
//  toGo
//
//  Created by Babul Rao on 14/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Headers.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <TwitterKit/TwitterKit.h>

#import "VideoConferenceVC.h"
#import <AVFoundation/AVAudioPlayer.h>

//1. Profile image upload Spinner show
//2. Background Audio Playing

@class InterpreterListObject;
@class CDRObject;
@class VideoConferenceVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController ;
    UIStoryboard *mainStoryboard ;
    VideoConferenceVC *viewVideoControler ;
    
    AVAudioPlayer *_audioPlayer;
    //AVAudioPlayer *audioPlayer; //Plays the audio
    //VideoConferenceVCWithRender *viewVideoControllerRender;
}
@property(nonatomic,strong) CDRObject *cdrObject;
//@property(nonatomic,strong)InterpreterListObject *acceptedInterpreter;
@property (retain, nonatomic) ooVooClient *sdk;
@property(nonatomic,strong)NSMutableArray *callingUsers;
@property(nonatomic,readwrite)BOOL isCallDisconnectOrCallEndDefault;
@property(nonatomic,strong) NSString *callerIDString;//This is to disconnect the call. This ID i am sending to Andriod caller
@property(nonatomic,strong) NSString *conferenceIDString;
@property (strong, nonatomic) FBSDKLoginManager *facebookLoginManager;
@property (strong, nonatomic) UINavigationController *naviController ;
@property(nonatomic,strong) NSMutableArray *languagesArray;
@property(nonatomic,readwrite) BOOL isConnected;
@property(nonatomic,strong) NSMutableArray *interpreterListArray;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)NSString *emailString;
-(void)subscribePushNotifications : (UIApplication *)application;

-(void)takeTour;
-(void)getLanguages;

-(void)saveDisconnectedCallDetailsinServer : (InterpreterListObject *)receivedInterpreter isNoOnePicksCallorEndedByCustomer:(BOOL)isNoOnePicksCallorEndedByCustomer;
-(void)saveCDR;
- (void)SetNotificationObserversForCallMessaging;
- (void)UnSetNotificationObserversForCallMessaging;
-(void)updateInterpreterCallStatus;
-(void)orderInterpreattionObservers;
-(void)killVideoView;
@end

