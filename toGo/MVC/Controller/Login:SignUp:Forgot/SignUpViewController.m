//
//  SignUpViewController.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate>{
    NSMutableDictionary *signUpDictionary;
    UITextField *activeField;
    
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak,nonatomic) IBOutlet UITextField *emaillTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *confirmpasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *registerAsLabel;
@property (weak, nonatomic) IBOutlet UILabel *interpreterLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *interpreterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *customerImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(IBAction)interpreterCustomerButtonClicked:(UIButton *)sender;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self allocationsAndStaticText];
    [self setCustomBackButtonForNavigation];
    [self setLabelButtonNames];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];
    [self setColors];
    [self setFonts];
}

-(void)allocationsAndStaticText{
    signUpDictionary = [NSMutableDictionary new];
}

-(void)setLabelButtonNames{
    self.registerAsLabel.text = NSLOCALIZEDSTRING(@"REGISTER_AS");
    self.interpreterLabel.text = NSLOCALIZEDSTRING(@"INTERPRETER");
    self.customerLabel.text = NSLOCALIZEDSTRING(@"CUSTOMER");
    [self.submitButton setTitle:NSLOCALIZEDSTRING(@"REGISTER_NOW") forState:UIControlStateNormal];
}

-(void)setPlaceHolders{
    self.usernameTextField.placeholder=NSLOCALIZEDSTRING(@"USERNAME");
    self.emaillTextField.placeholder=NSLOCALIZEDSTRING(@"EMAIL");
    self.passwordTextField.placeholder=NSLOCALIZEDSTRING(@"PASSWORD");
    self.confirmpasswordTextField.placeholder=NSLOCALIZEDSTRING(@"CONFIRM_PASSWORD");
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.usernameTextField];
    [UITextField roundedCornerTEXTFIELD:self.emaillTextField];
    [UITextField roundedCornerTEXTFIELD:self.passwordTextField];
    [UITextField roundedCornerTEXTFIELD:self.confirmpasswordTextField];
    [UIButton roundedCornerButton:self.submitButton];
}

-(void)setPadding{
    self.usernameTextField.leftViewMode=UITextFieldViewModeAlways;
    self.usernameTextField.leftView=[Utility_Shared_Instance setImageViewPadding:USER_ID_PADDING_IMAGE frame:CGRectMake(10, 1, 16, 16)];
    
    self.emaillTextField.leftViewMode=UITextFieldViewModeAlways;
    self.emaillTextField.leftView=[Utility_Shared_Instance setImageViewPadding:EMAIL_PADDING_IMAGE frame:CGRectMake(10, 3, 20, 13)];
    
    self.passwordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.passwordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:PASSWORD_PADDING_IMAGE frame:CGRectMake(10, -3, 15, 20)];
    
    self.confirmpasswordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.confirmpasswordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:PASSWORD_PADDING_IMAGE frame:CGRectMake(10, -1, 15, 20)];
}

-(void)setColors{
    [self.registerAsLabel setTextColor:[UIColor navigationBarColor]];
    [self.interpreterLabel setTextColor:[UIColor textColorBlackColor]];
    [self.customerLabel setTextColor:[UIColor lightGrayConnectWithColor]];
    [self.submitButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    self.registerAsLabel.font = [UIFont normalSize];
    self.interpreterLabel.font = [UIFont smallBig];
    self.customerLabel.font = [UIFont smallBig];
    self.submitButton.titleLabel.font = [UIFont largeSize];
}


-(IBAction)webServiceCall:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.usernameTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.usernameTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (self.emaillTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.emaillTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![Utility_Shared_Instance validateEmailWithString:self.emaillTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"VALID_EMAILID")]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![Utility_Shared_Instance passwordIsValid:self.passwordTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"PASSWORD_VALIDATION")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![Utility_Shared_Instance passwordIsValid:self.confirmpasswordTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"PASSWORD_VALIDATION")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![self.confirmpasswordTextField.text isEqualToString:self.passwordTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"PASSWORD_MISMATCH")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    
    
    else{
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"PLEASE_WAIT")]];
        [self signUpWebServiceCall];
    }
}

-(void)signUpWebServiceCall{

    [signUpDictionary setObject:self.usernameTextField.text forKey:KUSERNAME_W];
    [signUpDictionary setObject:self.passwordTextField.text forKey:KPASSWORD_W];
    [signUpDictionary setObject:self.emaillTextField.text forKey:KEMAIL_W];
    [signUpDictionary setObject:[Utility_Shared_Instance checkForNullString:[Utility_Shared_Instance readStringUserPreference:USER_TYPE]] forKey:KTYPE_W];
    
    [Web_Service_Call serviceCall:signUpDictionary webServicename:SIGNUP_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [AlertViewCustom showAlertViewWithMessage:[responseDict objectForKey:KMESSAGE_W] headingLabel:NSLOCALIZEDSTRING(APPLICATION_NAME) confirmButtonName:NSLOCALIZEDSTRING(@"") cancelButtonName:NSLOCALIZEDSTRING(@"OK") viewIs:self];
        });
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            _usernameTextField.text = @"";
            _emaillTextField.text= @"";
            _passwordTextField.text= @"";
            _confirmpasswordTextField.text= @"";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [AlertViewCustom showAlertViewWithMessage:[responseObject objectForKey:KMESSAGE_W] headingLabel:NSLOCALIZEDSTRING(APPLICATION_NAME) confirmButtonName:NSLOCALIZEDSTRING(@"") cancelButtonName:NSLOCALIZEDSTRING(@"OK") viewIs:self];
        });
    }];
}



-(IBAction)interpreterCustomerButtonClicked:(UIButton *)sender{
    if (sender.tag==1) {
        //Interpreter
        self.interpreterImageView.image = [UIImage radioONImage];
        self.customerImageView.image = [UIImage radioOffImage];
    }
    else{
        //Customer
        self.customerImageView.image = [UIImage radioONImage];
        self.interpreterImageView.image = [UIImage radioOffImage];
    }
}


#pragma Mark UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
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
