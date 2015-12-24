//
//  SignUpBaseViewController.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SignUpBaseViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmpasswordTextField;
@end
