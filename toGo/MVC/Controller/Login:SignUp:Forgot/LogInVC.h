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
@interface LogInVC : BaseViewController <AuthorizationDelegate, ooVooAccount, SocialDelegate, GPPSignInDelegate>


@property (retain, nonatomic) ooVooClient *sdk;

@end
