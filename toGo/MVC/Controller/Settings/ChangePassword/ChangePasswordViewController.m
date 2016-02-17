//
//  ChangePasswordViewController.m
//  toGO
//
//  Created by Babul Rao on 15/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) IBOutlet UITextField *oldPasswordTextField;
@property(nonatomic,strong) IBOutlet UITextField *confirmPasswordTextField;
@property(nonatomic,strong) IBOutlet UITextField *passwordTextField;
@property(nonatomic,strong) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomBackButtonForNavigation];
    [self setLogoutButtonForNavigation];
    [self setLabelButtonNames];
    [self setColors];
    [self setFonts];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];

}

-(void)viewDidLayoutSubviews {
    _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

-(void)setLabelButtonNames{
    self.headerLabel.text = NSLOCALIZEDSTRING(@"CHANGE PASSWORD");
    [self.submitButton setTitle:NSLOCALIZEDSTRING(@"RESET_PASSWORD") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.oldPasswordTextField];
    [UITextField roundedCornerTEXTFIELD:self.passwordTextField];
    [UITextField roundedCornerTEXTFIELD:self.confirmPasswordTextField];
    [UIButton roundedCornerButton:self.submitButton];
}


-(void)setColors{
    [self.submitButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    self.headerLabel.font = [UIFont normalSize];
    self.submitButton.titleLabel.font = [UIFont largeSize];
}


-(void)setPlaceHolders{
    
    self.oldPasswordTextField.placeholder = NSLOCALIZEDSTRING(@"OLD_PASSWORD");
    self.passwordTextField.placeholder = NSLOCALIZEDSTRING(@"NEW_PASSWORD");
    self.confirmPasswordTextField.placeholder = NSLOCALIZEDSTRING(@"CONFIRM_PASSWORD");
}

-(void)setPadding{
    
    self.oldPasswordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.oldPasswordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:PASSWORD_PADDING_IMAGE frame:CGRectMake(10, 0, 16, 16)];
    
    self.passwordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.passwordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:PASSWORD_PADDING_IMAGE frame:CGRectMake(10, 0, 16, 16)];
    
    self.confirmPasswordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.confirmPasswordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:PASSWORD_PADDING_IMAGE frame:CGRectMake(10, 0, 16, 16)];
    
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)submitButtonPressed:(id)sender{
    
    [self.view endEditing:YES];
    
    if (self.oldPasswordTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.oldPasswordTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (self.passwordTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.passwordTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (self.confirmPasswordTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.confirmPasswordTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![Utility_Shared_Instance passwordIsValid:self.passwordTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"PASSWORD_VALIDATION")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![Utility_Shared_Instance passwordIsValid:self.confirmPasswordTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"PASSWORD_VALIDATION")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"PASSWORD_MISMATCH")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    
    
    else{
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"PLEASE_WAIT")]];
        [self changePasswordWebServiceCall];
    }
}

-(void)changePasswordWebServiceCall{
    NSMutableDictionary *changePasswordDict = [NSMutableDictionary new];
    [changePasswordDict setObject:self.oldPasswordTextField.text forKey:KCURRENT_PASSWORD_W];
    [changePasswordDict setObject:self.passwordTextField.text forKey:KNEW_PASSWORD_W];
    [changePasswordDict setObject:[Utility_Shared_Instance readStringUserPreference:KEMAIL_W] forKey:KEMAIL_W];
    [changePasswordDict setObject:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KID_W];
    [changePasswordDict setObject:[Utility_Shared_Instance readStringUserPreference:USER_TYPE] forKey:KTYPE_W];
    
    [Web_Service_Call serviceCallWithRequestType:changePasswordDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:CHANGE_PASSWORD_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            _oldPasswordTextField.text= @"";
            _passwordTextField.text= @"";
            _confirmPasswordTextField.text= @"";
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                    withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                         inView:self
                                                      withStyle:UIAlertControllerStyleAlert];
                [self.navigationController popViewControllerAnimated:YES];
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
            [AlertViewCustom showAlertViewWithMessage:[responseObject objectForKey:KMESSAGE_W] headingLabel:NSLOCALIZEDSTRING(APPLICATION_NAME) confirmButtonName:NSLOCALIZEDSTRING(@"") cancelButtonName:NSLOCALIZEDSTRING(@"OK") viewIs:self];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
