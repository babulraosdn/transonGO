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

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController ;
    UIStoryboard *mainStoryboard ;
    VideoConferenceVC *viewVideoControler ;
}
@property (strong, nonatomic) UINavigationController *navigationController ;
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) ooVooClient *sdk;
@property(nonatomic,strong)NSMutableArray *callingUsers;

-(void)subscribePushNotifications : (UIApplication *)application;
@end

