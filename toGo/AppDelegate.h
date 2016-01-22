//
//  AppDelegate.h
//  toGo
//
//  Created by Babul Rao on 14/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoConferenceVC.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Headers.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <TwitterKit/TwitterKit.h>
//Spacing between elements
//Address, description auto size
//fonts se
//Slide menu images size
//small cell height slide menu
//Dashboard buttons close
//Alert view 
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController ;
    UIStoryboard *mainStoryboard ;
    VideoConferenceVC *viewVideoControler ;
}
@property (strong, nonatomic) FBSDKLoginManager *facebookLoginManager;
@property (strong, nonatomic) UINavigationController *navigationController ;
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) ooVooClient *sdk;
@property(nonatomic,strong)NSMutableArray *callingUsers;
@property(nonatomic,strong)NSString *emailString;
-(void)subscribePushNotifications : (UIApplication *)application;

-(void)takeTour;

@end

