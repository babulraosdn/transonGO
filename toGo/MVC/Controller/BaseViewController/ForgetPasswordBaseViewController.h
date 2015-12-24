//
//  ForgetPasswordBaseViewController.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ForgetPasswordBaseViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *displaylabel;
-(IBAction)webServiceCall:(id)sender;
@end

