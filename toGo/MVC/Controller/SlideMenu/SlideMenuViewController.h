//
//  SlideMenuViewController.h
//  toGo
//
//  Created by Babul Rao on 15/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface SlideMenuCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *displayImageView;
@property(nonatomic,weak) IBOutlet UILabel *displayLabel;
@end

@interface SlideMenuViewController : UIViewController


@end
