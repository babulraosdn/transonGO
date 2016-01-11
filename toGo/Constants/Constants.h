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
#define USER_TYPE                   @"userType"
#define USER_TOKEN                  @"userToken"

//********************  WebService Strings Constants  ****************************************
#pragma mark WebService Strings Constants
#define INTERPRETER                 @"interpreter"
#define CUSTOMER                    @"user"
#define NORMAL_LOGIN                @"0"
#define FACEBOOK_LOGIN              @"1"
#define TWITTER_LOGIN               @"1"
#define GOOGLE_LOGIN                @"1"
#define POST_REQUEST                        @"POST"
#define GET_REQUEST                         @"GET"


//********************  WebService Names  ****************************************
#pragma mark WebService Calls
//#define BASE_URL                    @"http://54.153.22.179:3000/"
#define BASE_URL                      @"http://172.10.55.110:3000/"

#define LOGIN_W                       @"authenticate"
#define SIGNUP_W                      @"signup"
#define FORGOTPASSWORD_W              @"forgot"
#define SOCIAL_LOGIN_W                @"loginSignUp"
#define PROFILE_INFO_W                @"api/getAgentInfo"

//********************  WebService Parameters   ****************************************
#pragma mark WebService Parameters
#define KUSERNAME_W                    @"username"
#define KEMAIL_W                       @"email"
#define KPASSWORD_W                    @"password"
#define KTYPE_W                        @"utype"
#define KLOGIN_TYPE_W                  @"logintype"
#define KAUTHORIZATION_W               @"Authorization"

#define KCERTIFICATES_W                @"certificates"
#define KBANK_ACCOUNT_INFORMATION_W    @"bankaccountinfo"
#define KDESCRIPTION_W                 @"description"
#define KADDRESS_W                     @"address"
#define KNICKNAME_W                    @"nickname"
#define KNAME_W                      @"name"
#define KPASSWORD_W                    @"password"
#define KMYLANGUAGES_W                 @"mylanguage"
#define KPHONE_NUMBER_W                @"phone_number"

#define KCOUNTRY_NAME_W                @"countryName"
#define KLANGUAGE_W                    @"language"
#define KPROFILE_IMAGE_W               @"profile_img"
#define KNO_OF_CALL_W                  @"noOfCall"
#define KCALL_MINUTES_W                @"callMinutes"
#define KCALL_YTD_EARNINGS_W           @"callYtdEarnings"
#define KSTATUS_W                      @"status"
#define K_W                            @""

//********************  WebService Response Parameters   ****************************************
#define KSUCCESS                       ((int)200)
#define KCODE_W                        @"code"
#define KMESSAGE_W                     @"message"
#define KTOKEN_W                       @"token"


//********************  ViewConroller Names  ****************************************
#define PROFILE_VIEW_CONTROLLER                 @"ProfileViewEditViewController"
#define LOGIN_VIEW_CONTROLLER                   @"LoginViewController"
#define DASHBOARD_USER_VIEW_CONTROLLER          @"DashBoardViewController"
#define DASHBOARD_INTERPRETER_VIEW_CONTROLLER   @"DashboardInterpreterViewController"
#define SETTINGS_VIEW_CONTROLLER                @"SettingsViewController"
#define SLIDE_MENU_VIEW_CONTROLLER              @"SlideMenuViewController"
#define FEEDBACK_LIST_VIEW_CONTROLLER           @"FeedBackListViewController"
#define HOME_VIEW_CONTROLLER           @"HomeViewController"


//********************  Font Names   ****************************************
#define KFontFamily_ROBOTO_REGULAR                        @"Roboto-Regular"
#define KFontFamily_ROBOTO_LIGHT                          @"Roboto-Light"
#define KFontFamily_ROBOTO_BOLD                           @"Roboto-Bold"
#define KFontFamily_ROBOTO_MEDIUM                         @"Roboto-Medium"
#define KFontFamily_ROBOTO_THIN                           @"Roboto-Thin"
#endif
