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


////1
/////*
//#define APP_TOKEN_SETTINGS_KEY    @"12349983355392"
//#define LOG_LEVEL_SETTINGS_KEY    @"LOG_LEVEL_SETTINGS_KEY"
//#define APP_VIDEO_RENDER            @"APP_VIDEO_RENDER"
//#define APP_MESSAGING            @"APP_MESSAGING"
//
//
//#ifndef TOKEN
//
//#define TOKEN @"MDAxMDAxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACs5wargiqXmlwM3bTZvfNOocpZHMgFFy9TaEfqCu4GrTO7y6TKXQZXtPLNmO1fWi4w1oUzY5wcXlSuiLl5YHFJx2%2FZP6baqkSrDP5ywPkbVGsHlvRUHkLmE%2B6%2BeY4LVVAxLwTliCn%2FDCPSve1wV6hT"
//#endif
////*/
//
///* //2
// #define APP_TOKEN_SETTINGS_KEY    @"12349983355077"
// #define LOG_LEVEL_SETTINGS_KEY    @"LOG_LEVEL_SETTINGS_KEY"
// #define APP_VIDEO_RENDER            @"APP_VIDEO_RENDER"
// #define APP_MESSAGING            @"APP_MESSAGING"
// 
// 
// #ifndef TOKEN
// 
// #define TOKEN @"MDAxMDAxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZUYVW%2BB1MwyBDpt22C0WvOeMPW7fH6mMOv8d%2FAPeFZ2QeCOguU288bRzsChrixFyZ%2BKzm9nrLmfOkZwyPrAO%2BDP8wgDiVtL%2F0w9mZQ78Az5Hk6imDbhYGNGRFMqo0H2virlVE4Q%2Bpf5S%2Fm50MO%2BMh"
// #endif
// */



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

#define CARD_NUMBER_LIMIT 16
#define CVV_LIMIT 4
#define PHONE_NUMBER_LIMIT 12
#define POSTAL_CODE_LIMIT 6

#define CHARACTER_LIMIT 10000000
#define NUMBERS_ONLY @"0123456789."
#define ACCEPTABLE_CHARACTERS_NAME @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

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
//#define ooVooAppID                  @"12349983355077"//OLD //2
#define ooVooAppID                  @"12349983355392"//New //1


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
#define EDIT_PEN_IMAGE              @"Edit_iPhone"
#define LIGHT_BUTTON_IMAGE          @"light-button"
#define SWITCH_OFF_IMAGE            @"toggle_off_iPhone"
#define SWITCH_ON_IMAGE             @"toggle_on_iPhone"
#define CLOSE_LANGUAGES_IMAGE       @"close_iPhone"
#define CheckOrTick_IMAGE           @"Tick_iPhone"



//SlideMenu
#define DASHBOARD_SLIDE_IMAGE       @"dashboard_iPhone"
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

#define PROFILE_COMPLETE            @"1"
#define PROFILE_INCOMPLETE          @"0"

#define INTERPRETER_AVAILABLE       @"1"
#define INTERPRETER_UN_AVAILABLE    @"0"

#define NORMAL_LOGIN                @"0"
#define FACEBOOK_LOGIN              @"1"
#define TWITTER_LOGIN               @"1"
#define GOOGLE_LOGIN                @"1"
#define POST_REQUEST                @"POST"
#define GET_REQUEST                 @"GET"
#define KDEVICE_TOKEN               @"DEVICE_TOKEN_IS"

//********************  WebService Names  ****************************************
#pragma mark WebService Calls
#define BASE_URL                    @"http://54.153.22.179:3000/"      //LIVE URL
//#define BASE_URL                  @"http://172.10.55.110:3000/"      //Local URL

#define LOGIN_W                       @"authenticate"
#define SIGNUP_W                      @"signup"
#define FORGOTPASSWORD_W              @"forgot"
#define SOCIAL_LOGIN_W                @"loginSignUp"
#define PROFILE_INFO_W                @"api/getAgentInfo"
#define PROFILE_INFO_W_USER           @"api/getUserProfile"
#define PROFILE_IMAGE_UPLOAD_W        @"api/upload"
#define GET_COUNTRY_LIST_W            @"getCountryList"
#define GET_STATE_LIST_W              @"getState?country="
#define GET_INTERPRETER_BY_LANGUAGE_W @"getInterpreterByLanguage"//This will return price also

//getUserProfile
//
#define UPDATE_INTERPRETER_STATUS_W         @"api/updateAgentAvailability"
#define UPDATE_INTERPRETER_PROFILE_INFO_W   @"api/updateAgentProfile"
#define UPDATE_USER_PROFILE_INFO_W          @"api/updateUserProfile"
#define GET_LANGUAGES_W                     @"getLanguageList"
#define GET_LANGUAGE_PRICE_W                @"getLanguagePrice"
#define SAVE_CALL_DETAILS                   @"api/saveCallDetails"
#define CREATE_CDR                          @"api/createCDR"
#define GET_DASHBOARD_DATA                  @"getDashboardData"

//updateUserProfile
//

//********************  WebService Parameters   ****************************************
#pragma mark WebService Parameters
#define KUSERNAME_W                    @"username"
#define KEMAIL_W                       @"email"
#define KPASSWORD_W                    @"password"
#define KUSER_TYPE_W                   @"utype"
#define KTYPE_W                        @"type"
#define KLOGIN_TYPE_W                  @"logintype"
#define KAUTHORIZATION_W               @"Authorization"
#define KCOMPLETION_W                  @"completion"

#define KCERTIFICATES_W                @"certificates"
#define KBANK_ACCOUNT_INFORMATION_W    @"bankaccountinfo"
#define KDESCRIPTION_W                 @"description"
#define KABOUT_USER_W                  @"about_user"
#define KADDRESS_W                     @"address"
#define KGENDER                        @"gender"
#define KDOB                           @"dob"
#define KNICKNAME_W                    @"nickname"
#define KNAME_W                        @"name"
#define KFIRST_NAME_W                  @"first_name"
#define KLAST_NAME_W                   @"last_name"
#define KPASSWORD_W                    @"password"
#define KMYLANGUAGES_W                 @"mylanguage"
#define KPHONE_NUMBER_W                @"phone_number"
#define KPAYMENT_INFO_W                @"payment_info"
#define KCARD_TYPE_W                   @"card_type"
#define KCARD_NUMBER_W                 @"card_number"
#define KEXP_MONTH_W                   @"exp_month"
#define KEXP_YEAR_W                    @"exp_year"
#define KCVV_W                         @"cvv"

#define KCOUNTRY_NAME_W                @"countryName"
#define KLANGUAGE_W                    @"language"
#define KPROFILE_IMAGE_W               @"profile_img"
#define KNO_OF_CALL_W                  @"noOfCall"
#define KCALL_MINUTES_W                @"callMinutes"
#define KCALL_YTD_EARNINGS_W           @"callYtdEarnings"
#define KSTATUS_W                      @"status"
#define KID_W                          @"id"
#define KUID_W                         @"uid"
#define KINTERPRETER_AVAILABILITY_W    @"interpreter_availability"
#define KMYLANGUAGE_W                  @"mylanguage"
#define KCOUNTRY_W                     @"country"
#define KSTATE_W                       @"state"
#define KCITY_W                        @"city"
#define KPOSTALCODE_W                  @"zipcode"
#define KEIN_TAXID_W                   @"ein_taxId"
#define KURL_W                         @"url"
#define KSERVICE_TYPE_W                @"service_type"
#define KFILE_W                        @"file"
#define KINTERPRETER_AVAILABILITY_W    @"interpreter_availability"

#define KCOUNTRY_CODE_W                 @"countryCode"
#define KCOUNTRY_NAME_W                 @"countryName"
#define KCREATED_AT_W                   @"createdAt"
#define KCOUNTRY_ID_W                   @"countryId"
#define KSTATE_NAME_W                   @"stateName"

#define KLANGUAGEID_W                   @"id"
#define KLANGUAGE_ID_W                  @"languageid"
#define KICON_W                         @"icon"
#define KDATA_W                         @"data"
#define KPRICE_W                        @"price"
#define KTO_LANGUAGE_W                  @"toLanguage"
#define KFROM_LANGUAGE_W                @"fromLanguage"
#define KTO_LANGUAGE_small_L_Leter_W    @"tolanguage"
#define KFROM_LANGUAGE_small_L_Leter_W  @"fromlanguage"
#define KLANGUAGE_PRICE_W               @"languagePrice"
#define KLANGUAGE_NAME_W                @"languageName"
#define KPOOL_ID_W                      @"poolId"
#define KUSER_ID_W                      @"userId"
#define KINTERPRETER_ID_W               @"interpreterId"
#define KCALL_RECEIVED_BY_W             @"callReceivedBy"
#define KCALLID_W                       @"callId"
#define KSTART_TIME_W                   @"start_time"
#define KEND_TIME_W                     @"end_time"
#define KCOST_W                         @"cost"
#define KTOTAL_NO_CALLS_W               @"totalNoCalls"
#define KTOTAL_CALL_MINUTES_W           @"totalCallMinutes"
#define KTOTAL_CALL_AMOUNT_W            @"totalCallAmount"

//********************  WebService Response Parameters   ****************************************
#define KSUCCESS                       ((int)200)
#define KCODE_W                        @"code"
#define KMESSAGE_W                     @"message"
#define KTOKEN_W                       @"token"
#define KDASHBOARD_W                   @"dashboard"



//********************  ViewConroller Names  ****************************************
#define PROFILE_VIEW_CONTROLLER                 @"ProfileViewEditViewController"
#define LOGIN_VIEW_CONTROLLER                   @"LoginViewController"
#define DASHBOARD_USER_VIEW_CONTROLLER          @"DashBoardViewController"
#define DASHBOARD_INTERPRETER_VIEW_CONTROLLER   @"DashboardInterpreterViewController"
#define SETTINGS_VIEW_CONTROLLER                @"SettingsViewController"
#define SLIDE_MENU_VIEW_CONTROLLER              @"SlideMenuViewController"
#define FEEDBACK_LIST_VIEW_CONTROLLER           @"FeedBackListViewController"
#define HOME_VIEW_CONTROLLER                    @"HomeViewController"
#define ORDER_INTERPRETATION_VIEW_CONTROLLER                    @"OrderInterpretationViewController"
#define GIVE_FEEDBACK_VIEW_CONTROLLER           @"GiveFeedbackViewController"
#define FAVOURITE_VIEW_CONTROLLER           @"FavouriteInterpreterViewController"

//********************  Font Names   ****************************************
#define KFontFamily_ROBOTO_REGULAR                        @"Roboto-Regular"
#define KFontFamily_ROBOTO_LIGHT                          @"Roboto-Light"
#define KFontFamily_ROBOTO_BOLD                           @"Roboto-Bold"
#define KFontFamily_ROBOTO_MEDIUM                         @"Roboto-Medium"
#define KFontFamily_ROBOTO_THIN                           @"Roboto-Thin"

//********************  Segue Identifiers   ****************************************
#define Segue_MenuConferenceVC @"Segue_MenuConferenceVC"
#endif
