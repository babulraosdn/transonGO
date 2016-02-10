//
//  BaseViewController.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"
#import <PKRevealController/PKRevealController.h>
#import <ooVooSDK/ooVooSDK.h>

@class AppDelegate;

@interface BaseViewController : UIViewController<PKRevealing>{
    AppDelegate  *appDelegate;
}
@property(nonatomic,strong) PKRevealController *revealController;
@property (retain, nonatomic) ooVooClient *sdk;

-(void)setSlideMenuButtonFornavigation;
-(void)setLogoutButtonForNavigation;
-(void)setCustomBackButtonForNavigation;
-(void)navigateToLoginView;
@end
