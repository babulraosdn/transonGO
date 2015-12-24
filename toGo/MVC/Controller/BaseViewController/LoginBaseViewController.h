//
//  LoginBaseViewController.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Headers.h"
@interface LoginBaseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *linkedInButton;
@property (weak, nonatomic) IBOutlet UIButton *googlePlusButton;

-(IBAction)webServiceCall:(id)sender;
-(void)setBackButtonForNavigation;
@end
