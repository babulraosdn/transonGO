//
//  BaseViewController.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@class AppDelegate;

@interface BaseViewController : UIViewController{
    AppDelegate  *appDelegate;
}
-(void)setSlideMenuButtonFornavigation;
-(void)setLogoutButtonForNavigation;
-(void)setCustomBackButtonForNavigation;
-(void)navigateToLoginView;
@end
