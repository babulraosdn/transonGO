//
//  SocialView.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Headers.h"

@protocol SocialDelegate <NSObject>
-(void)finishLogin:(NSString *)mediaType responseDict:(NSMutableDictionary *)response showAlerViewController:(BOOL)isPresentAlertVC alertViewContoller:(UIAlertController *)alertViewController;
@end

@interface SocialView : NSObject

@property (nonatomic, retain) ACAccountStore *account;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property(nonatomic,weak)id <SocialDelegate> delegate;

-(void)faceBookLogin;
-(void)linkedInLogin;
-(void)twitterLogin;
@end
