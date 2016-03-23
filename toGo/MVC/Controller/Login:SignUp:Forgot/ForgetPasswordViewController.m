//
//  ForgetPasswordViewController.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "ForgetPasswordViewController.h"


@interface ForgetPasswordViewController (){
    
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *displaylabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomBackButtonForNavigation];
    [self setLabelButtonNames];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];
    [self setColors];
    [self setFonts];

}

- (void)viewWillAppear:(BOOL)animated {
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
}

-(void)viewDidLayoutSubviews{
    _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    
}

-(void)setPlaceHolders{
    self.emailTextField.placeholder= NSLOCALIZEDSTRING(@"EMAIL");
}

-(void)setLabelButtonNames{
    self.displaylabel.text = NSLOCALIZEDSTRING(@"FILL_YOUR_EMAIL_ID_FORGOT_PASSWORD_SCREEN_TEXT");
    [self.submitButton setTitle:NSLOCALIZEDSTRING(@"SEND_EMAIL") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.emailTextField];
    [UIButton roundedCornerButton:self.submitButton];
}

-(void)setPadding{
    self.emailTextField.leftViewMode=UITextFieldViewModeAlways;
    self.emailTextField.leftView=[Utility_Shared_Instance setImageViewPadding:EMAIL_PADDING_IMAGE frame:CGRectMake(10, 3, 20, 13)];
}

-(void)setColors{
    [self.displaylabel setTextColor:[UIColor lightGrayConnectWithColor]];
    [self.submitButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    self.displaylabel.font = [UIFont normalSize];
    self.submitButton.titleLabel.font = [UIFont largeSize];
}


-(IBAction)webServiceCall:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.emailTextField.text.length<1) {
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"EMAIL")]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    }
    else if (![Utility_Shared_Instance validateEmailWithString:self.emailTextField.text]) {
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"VALID_EMAILID")]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
        return;
    }
    else{
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"PLEASE_WAIT")]];
        //WEB Service CODE
        NSMutableDictionary *forgetPasswordDict=[NSMutableDictionary new];
        [forgetPasswordDict setValue:self.emailTextField.text forKey:KEMAIL_W];
        [Web_Service_Call serviceCall:forgetPasswordDict webServicename:FORGOTPASSWORD_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
            NSDictionary *responseDict=responseObject;
            
            if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
            {
                _emailTextField.text = @"";
                //[self.navigationController popViewControllerAnimated:YES];//Not Working
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [AlertViewCustom showAlertViewWithMessage:[responseDict objectForKey:KMESSAGE_W] headingLabel:NSLOCALIZEDSTRING(@"FORGET_PASSWORD") confirmButtonName:NSLOCALIZEDSTRING(@"") cancelButtonName:NSLOCALIZEDSTRING(@"OK") viewIs:self];
                });
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                        withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                             inView:self
                                                          withStyle:UIAlertControllerStyleAlert];
                    
                });
            }
        } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                    withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                         inView:self
                                                      withStyle:UIAlertControllerStyleAlert];
               
            });
        }];
    }
}

#pragma Mark UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - AlertView Custom delegate
-(void)finishAlertViewCustomAction:(UIButton *)sender{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:999] removeFromSuperview];
}

@end
