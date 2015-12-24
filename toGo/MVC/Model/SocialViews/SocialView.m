//
//  SocialView.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "SocialView.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"


@implementation SocialView

# pragma mark - facebook Integration
-(void)faceBookLogin
{
    
    
    NSURL* URL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    _account = [[ACAccountStore alloc] init];
    ACAccountType *accountTypeF = [_account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    FacebookAPI_Key, ACFacebookAppIdKey,
                                    @[@"public_profile",@"email",@"user_birthday"], ACFacebookPermissionsKey, nil];
    [_account requestAccessToAccountsWithType:accountTypeF options:options completion:^(BOOL granted, NSError *error) {
        if(granted) {
            SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                    requestMethod:SLRequestMethodGET
                                                              URL:URL
                                                       parameters:nil];
            [request setValue:[NSDictionary dictionaryWithObject:@"id,name,email,birthday,first_name,last_name" forKey:@"fields"] forKey:@"parameters"];
            
            NSArray *accounts = [_account accountsWithAccountType:accountTypeF];
            //_facebookAccount = [accounts lastObject];
            ACAccount *fbAcc = [accounts lastObject];
            [request setAccount:fbAcc]; // Authentication - Requires user context
            [request performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
                // parse the response or handle the error
                if (responseData)
                {
                    //                    NSString* newStr = [[NSString alloc] initWithData:responseData
                    //                                                             encoding:NSUTF8StringEncoding];
                    //                    NSLog(@"data:%@",newStr);
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil]];
                        if ([userInfoDict objectForKey:@"id"]) {
                            [userInfoDict setValue:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",[userInfoDict objectForKey:@"id"]] forKey:@"profileImage"];
                        }
                        
                        [self.delegate finishLogin:FACEBOOK responseDict:userInfoDict showAlerViewController:NO alertViewContoller:nil];
                        
                        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        
                        //[self callSignInWithSocialAPI:FACEBOOK andData:userInfoDict];
                    });
                }
            }];
        }else {
            NSLog(@"Error:%@",error.description);
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                if (error.code == 7) {
                    //[UIUtils  showAlertWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME) withMessage:error.description otherAction:nil];
                }else if(error.code == 6) {
                    if([UIAlertController class]){
                        NSString *alertMessage = NSLOCALIZEDSTRING(@"1. Go to Settings.\n2. Tap Facebook.\n3. Enter your facebook credentials.");
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLOCALIZEDSTRING(@"Facebook Account not Setup") message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                        }];
                        [alertVC addAction:cancel];
                        UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                        }];
                        [alertVC addAction:settings];
                        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
                        paragraphStyle.alignment =  NSTextAlignmentLeft;
                        NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc]initWithString:alertMessage attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
                        [alertVC setValue:messageText forKey:@"attributedMessage"];
                        [self.delegate finishLogin:FACEBOOK responseDict:nil showAlerViewController:YES alertViewContoller:alertVC];
                        return;
                    }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                    UIAlertView *alert;
                    if(IS_OS_8_OR_LATER){
                        alert = [[UIAlertView alloc] initWithTitle:@"Facebook Account not Setup" message:@"1. Go to Settings.\n2. Tap Facebook.\n 3.Enter your facebook credentials." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                    }else{
                        alert = [[UIAlertView alloc] initWithTitle:@"Facebook Account not Setup" message:@"1. Go to Settings.\n2. Tap Facebook.\n 3.Enter your facebook credentials." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    }
                    [alert show];
#pragma GCC diagnostic pop
                }else{
                    if (error.description) {
                        //[  showAlertWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME) withMessage:error.description otherAction:nil];
                    }else{
                        if([UIAlertController class]){
                            NSString *alertMessage = NSLOCALIZEDSTRING(@"1. Go to Settings.\n2. Tap Facebook.\n3. Enable application to use facebook account.");
                            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLOCALIZEDSTRING(@"Facebook account disabled") message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                [alertVC dismissViewControllerAnimated:YES completion:nil];
                            }];
                            [alertVC addAction:cancel];
                            UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                [alertVC dismissViewControllerAnimated:YES completion:nil];
                            }];
                            [alertVC addAction:settings];
                            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
                            paragraphStyle.alignment =  NSTextAlignmentLeft;
                            NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc]initWithString:alertMessage attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
                            [alertVC setValue:messageText forKey:@"attributedMessage"];
                            [self.delegate finishLogin:FACEBOOK responseDict:nil showAlerViewController:YES alertViewContoller:alertVC];
                            return;
                        }
                        
                        //  [UIUtils showAlertWithTitle:@"Facebook account disabled" withMessage:@"1. Go to Settings.\n2. Tap Facebook.\n 3. Enable application to use facebook account." otherAction:[[NSArray alloc]initWithObjects:@"Cancel",@"Settings", nil]];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                        
                        UIAlertView *alert;
                        
                        if(IS_OS_8_OR_LATER){
                            alert = [[UIAlertView alloc] initWithTitle:@"Facebook account disabled" message:@"1. Go to Settings.\n2. Tap Facebook.\n 3. Enable application to use facebook account." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                        }else{
                            alert = [[UIAlertView alloc] initWithTitle:@"Facebook account disabled" message:@"1. Go to Settings.\n2. Tap Facebook.\n 3. Enable application to use facebook account." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        }
                        [alert show];
#pragma GCC diagnostic pop
                        
                    }
                    
                }
                //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        }
    }];
}

# pragma mark - Twitter Integration
-(void)twitterLogin
{
    // To get access to the accounts registered in the settings, we need an Account Store.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    // Since we only want Twitter accounts, we get the account type for Twitter.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // First we need to request access to the Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if ( granted == YES ) {
            // We have been granted access to the accounts.
        } else {
            // The user did not allow us to access the Twitter accounts.
            NSLog(@"We are not allowed to access the accounts.");
        }
    }];
    
    // Let's get all the registered Twitter accounts.
    NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
    
    ACAccount *account = nil;
    if( [arrayOfAccounts count] == 1 ) {
        // There is only one Twitter account, so we will use this one.
        account = [arrayOfAccounts objectAtIndex:0];
    } else if( [arrayOfAccounts count] > 1 ) {
        // There are multiple Twitter accounts.
        // We should ask the user which one to use.
        // But for the sake of this example, we can just take the first one.
        account = [arrayOfAccounts objectAtIndex:0];
    } else {
        // There are no accounts available.
        // Inform the user about this and ask him to add an account in the settings.
        NSLog(@"There are no accounts.");
        NSString *alertMessage = NSLOCALIZEDSTRING(@"1. Go to Settings.\n2. Tap Twitter.\n3. Enter your twitter credentials.");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLOCALIZEDSTRING(@"Twitter Account not Setup") message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertVC addAction:cancel];
        UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertVC addAction:settings];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment =  NSTextAlignmentLeft;
        NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc]initWithString:alertMessage attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        [alertVC setValue:messageText forKey:@"attributedMessage"];
        [self.delegate finishLogin:TWITTER responseDict:nil showAlerViewController:YES alertViewContoller:alertVC];
        return;
    }
    
    // Lets create the request.
    SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"]
                                               parameters:[NSDictionary dictionaryWithObject:@"My new Twitter message." forKey:@"status"]];
    
    
    // Now we need to set the account for this request.
    [request setAccount:account];
    
    // And finally we are able to send the request and handle the response.
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if( !error ) {
            if (responseData)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil]];
                    [self.delegate finishLogin:TWITTER responseDict:userInfoDict showAlerViewController:NO alertViewContoller:nil];
                });
            }
            /*
             {
             contributors = "<null>";
             coordinates = "<null>";
             "created_at" = "Fri Oct 09 09:43:40 +0000 2015";
             entities =     {
             hashtags =         (
             );
             symbols =         (
             );
             urls =         (
             );
             "user_mentions" =         (
             );
             };
             "favorite_count" = 0;
             favorited = 0;
             geo = "<null>";
             id = 652419145984675840;
             "id_str" = 652419145984675840;
             "in_reply_to_screen_name" = "<null>";
             "in_reply_to_status_id" = "<null>";
             "in_reply_to_status_id_str" = "<null>";
             "in_reply_to_user_id" = "<null>";
             "in_reply_to_user_id_str" = "<null>";
             "is_quote_status" = 0;
             lang = en;
             place = "<null>";
             "retweet_count" = 0;
             retweeted = 0;
             source = "<a href=\"http://www.apple.com\" rel=\"nofollow\">iOS</a>";
             text = "My new Twitter message.";
             truncated = 0;
             user =     {
             "contributors_enabled" = 0;
             "created_at" = "Tue May 05 13:16:29 +0000 2015";
             "default_profile" = 1;
             "default_profile_image" = 1;
             description = "";
             entities =         {
             description =             {
             urls =                 (
             );
             };
             };
             "favourites_count" = 1;
             "follow_request_sent" = 0;
             "followers_count" = 0;
             following = 0;
             "friends_count" = 1;
             "geo_enabled" = 1;
             "has_extended_profile" = 0;
             id = 3186168372;
             "id_str" = 3186168372;
             "is_translation_enabled" = 0;
             "is_translator" = 0;
             lang = en;
             "listed_count" = 0;
             location = "";
             name = redrocksdn;
             notifications = 0;
             "profile_background_color" = C0DEED;
             "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
             "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
             "profile_background_tile" = 0;
             "profile_image_url" = "http://abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png";
             "profile_image_url_https" = "https://abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png";
             "profile_link_color" = 0084B4;
             "profile_sidebar_border_color" = C0DEED;
             "profile_sidebar_fill_color" = DDEEF6;
             "profile_text_color" = 333333;
             "profile_use_background_image" = 1;
             protected = 0;
             "screen_name" = redrocksdn;
             "statuses_count" = 30;
             "time_zone" = "<null>";
             url = "<null>";
             "utc_offset" = "<null>";
             verified = 0;
             };
             }
             */
            
            // The request was sent successfully
            NSLog(@"success");
        } else {
            // An error occured
            NSLog(@"failure");
        }
    }];
    
    
}

# pragma mark - LinkedIn Integration

-(void)linkedInLogin {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"accessToken"]) {
        [self requestMeWithToken:[userDefaults objectForKey:@"accessToken"]];
    }else{
        [self.client getAuthorizationCode:^(NSString *code) {
            [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
                [self requestMeWithToken:[accessTokenData objectForKey:@"access_token"]];
            }                   failure:^(NSError *error) {
                NSLog(@"Quering accessToken failed %@", error);
            }];
        }                      cancel:^{
            NSLog(@"Authorization was cancelled by user");
        }                     failure:^(NSError *error) {
            NSLog(@"Authorization failed %@", error);
        }];
        [SVProgressHUD dismiss];
    }
}


- (void)requestMeWithToken:(NSString *)accessToken {
    
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,public-profile-url)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        if (!operation.error) {
            NSLog(@"current user %@", result);
            if (result)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:result];
                    [self.delegate finishLogin:LINKEDIN responseDict:userInfoDict showAlerViewController:NO alertViewContoller:nil];
                });
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:LinkedIn_RedirectURL
                                                                                    clientId:LinkedIn_clientId
                                                                                clientSecret:LinkedIn_clientSecret
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_emailaddress", @"r_basicprofile",@"rw_company_admin",@"w_share"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}


@end
