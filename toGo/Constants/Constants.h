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

#define CARD_NUMBER_LIMIT 16
#define CVV_LIMIT 4
#define PHONE_NUMBER_LIMIT 10
#define POSTAL_CODE_LIMIT 5

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
#define INTERPRETER_UN_AVAILABLE       @"0"

#define NORMAL_LOGIN                @"0"
#define FACEBOOK_LOGIN              @"1"
#define TWITTER_LOGIN               @"1"
#define GOOGLE_LOGIN                @"1"
#define POST_REQUEST                @"POST"
#define GET_REQUEST                 @"GET"


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

//getUserProfile
//
#define UPDATE_INTERPRETER_STATUS_W         @"api/updateAgentAvailability"
#define UPDATE_INTERPRETER_PROFILE_INFO_W   @"api/updateAgentProfile"
#define UPDATE_USER_PROFILE_INFO_W          @"api/updateUserProfile"
#define GET_LANGUAGES_W                     @"getLanguageList"
#define GET_LANGUAGE_PRICE_W                     @"getLanguagePrice"

//updateUserProfile
//

//********************  WebService Parameters   ****************************************
#pragma mark WebService Parameters
#define KUSERNAME_W                    @"username"
#define KEMAIL_W                       @"email"
#define KPASSWORD_W                    @"password"
#define KTYPE_W                        @"utype"
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

#define KLANGUAGEID_W                   @"languageId"
#define KICON_W                         @"icon"
#define KDATA_W                         @"data"

#define KTO_LANGUAGE_W                  @"toLanguage"
#define KFROM_LANGUAGE_W                @"fromLanguage"
#define KLANGUAGE_PRICE_W               @"languagePrice"

#define K_W                            @""


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

//********************  Font Names   ****************************************
#define KFontFamily_ROBOTO_REGULAR                        @"Roboto-Regular"
#define KFontFamily_ROBOTO_LIGHT                          @"Roboto-Light"
#define KFontFamily_ROBOTO_BOLD                           @"Roboto-Bold"
#define KFontFamily_ROBOTO_MEDIUM                         @"Roboto-Medium"
#define KFontFamily_ROBOTO_THIN                           @"Roboto-Thin"

//********************  Segue Identifiers   ****************************************
#define Segue_MenuConferenceVC @"Segue_MenuConferenceVC"
#endif
