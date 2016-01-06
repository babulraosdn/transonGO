//
//  Constants.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#ifndef toGo_iOS_Constants_h
#define toGo_iOS_Constants_h

#ifdef __OBJC__
#import "AppDelegate.h"
#define App_Delegate         ((AppDelegate*)[[UIApplication sharedApplication]delegate])
#endif

#define APPLICATION_NAME             NSLOCALIZEDSTRING([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"])

#define IS_IPHONE                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4S                (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0)
#define IS_IPHONE_5                 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6                 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS             (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS            (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA                    ([[UIScreen mainScreen] scale] == 2.0)

#define UIColorFromRGB(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define NSLOCALIZEDSTRING(string)     NSLocalizedString(string, nil)
#define Utility_Shared_Instance       [Utility sharedInstance]
#define Web_Service_Call              [WebServiceCall sharedInstance]

#define DEBUGGING YES    //or YES
#define NSLog if(DEBUGGING)NSLog

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//********************  Social   ****************************************
#pragma mark Social Calls
#define LinkedIn_RedirectURL          @"http://www.testapp.com/testapp"
#define LinkedIn_clientId             @"77i5uwp6x5esku"
#define LinkedIn_clientSecret         @"ncAH3CMsDpVRgqg1"

#define GooglePlusClientID            @"506861358610-uc2of0fda4oh8meq6jvs9m4l5sbf8qcm.apps.googleusercontent.com"
#define ApplicationOpenGoogleAuthNotification @"ApplicationOpenGoogleAuthNotification"

#define FacebookAPI_Key             @"1634906070093280"
#define kPublicProfile              @"public_profile"
#define kBirthday                   @"user_birthday"
#define kLocation                   @"user_location"
#define kEmail                      @"email"

//********************  WebService   ****************************************
#pragma mark WebService Calls
#define BASE_URL                    @"http://172.10.55.110:3000/"
#define LOGIN                       @"authenticate"
#define SIGNUP                      @"signup"
#define FORGOTPASSWORD              @"forgot"


//********************  ooVoo App Details   ****************************************
#pragma mark ooVoo App Details
#define ooVooAppID                  @"12349983355077"


//********************  Image Names   ****************************************
#pragma mark Image Names
#define SLIDE_IMAGE                 @"drawer-ico"
#define LOGOUT_IMAGE                @"logout_iPhone"
#define BACK_IMAGE                  @"back_icon_iPhone"
#define ACCOUNT_IMAGE               @"account"
#define EMAIL_PADDING_IMAGE         @"email_icon_iPhone"
#define USER_ID_PADDING_IMAGE       @"user_icon_iPhone"
#define PASSWORD_PADDING_IMAGE      @"password_icon_iPhone"
#define DEFAULT_PIC_IMAGE           @"default_pic_iPhone"
//SlideMenu
#define CALL_HISTORY_IMAGE          @"call_history_icon_iPhone"
#define FAV_INTERPRETER_IMAGE       @"fav_interpreter_icon_iPhone"
#define ORDER_INTERPRETER_IMAGE     @"order_interpreter_iPhone"
#define PROFILE_IMAGE               @"profile_icon_iPhone"
#define PURCHASE_IMAGE              @"purchase_icon_iPhone"
#define SETTINGS_IMAGE              @"Settings_icon_iPhone"
///

//********************  Colors CODES  ****************************************
#pragma mark Colors Codes
#define BLACK_COLOR                 @""
#define WHITE_COLOR                 @""
#define GRAY_COLOR                  @"848484"
#define DARK_ORANGE                 @"2551400"

//********************  Strings Constants   ****************************************
#pragma mark Strings Constants
#define FACEBOOK                    @"facebbok"
#define TWITTER                     @"twitter"
#define LINKEDIN                    @"linkedin"
#define GOOGLE_PLUS                 @"google plus"

#pragma mark WebService Strings Constants
#define INTERPRETER                 @"interpreter"
#define CUSTOMER                    @"customer"

//********************  WebService Parameters   ****************************************
#pragma mark WebService Parameters
#define KUSERNAME_W                    @"username"
#define KEMAIL_W                       @"email"
#define KPASSWORD_W                    @"password"
#define KTYPE_W                        @"type"
#define KCODE_W                        @"code"

//********************  ViewConroller Names  ****************************************
#define PROFILE_VIEW_CONTROLLER                 @"ProfileViewEditViewController"
#define LOGIN_VIEW_CONTROLLER                   @"LoginViewController"
#define DASHBOARD_USER_VIEW_CONTROLLER          @"DashBoardViewController"
#define DASHBOARD_INTERPRETER_VIEW_CONTROLLER   @"DashboardInterpreterViewController"
#define SETTINGS_VIEW_CONTROLLER                @"SettingsViewController"
#define SLIDE_MENU_VIEW_CONTROLLER              @"SlideMenuViewController"
#define FEEDBACK_LIST_VIEW_CONTROLLER           @"FeedBackListViewController"

//********************  Font Names   ****************************************
#define KFontFamily_ROBOTO_REGULAR                        @"Roboto-Regular"
#define KFontFamily_ROBOTO_LIGHT                          @"Roboto-Light"
#define KFontFamily_ROBOTO_BOLD                           @"Roboto-Bold"
#define KFontFamily_ROBOTO_MEDIUM                         @"Roboto-Medium"
#define KFontFamily_ROBOTO_THIN                           @"Roboto-Thin"
#endif
