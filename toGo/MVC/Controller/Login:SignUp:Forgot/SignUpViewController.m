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
    NSString *typeString;
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
    self.title = NSLOCALIZEDSTRING(@"TOGO");
    self.view.backgroundColor = [UIColor backgroundColor];
    [self allocationsAndStaticText];
    [self registerForKeyboardNotifications];
    [self setCustomBackButtonForNavigation];
    [self setLabelButtonNames];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];
    [self setColors];
    [self setFonts];
    
    
}

-(void)viewDidLayoutSubviews{
    //_scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    
}

-(void)allocationsAndStaticText{
    signUpDictionary = [NSMutableDictionary new];
    typeString = INTERPRETER;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardWasShown:(NSNotification*)notification
{
    
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.view.frame.origin.x,self.view.frame.origin.y, kbSize.height+100, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
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
    else if (self.passwordTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.passwordTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (self.confirmpasswordTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.confirmpasswordTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![self.confirmpasswordTextField.text isEqualToString:self.passwordTextField.text])
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"PASSWORD_MISMATCH")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    
    else{
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"Please wait...")]];
        [self signUpWebServiceCall];
    }
}

-(void)signUpWebServiceCall{

    [signUpDictionary setObject:self.usernameTextField.text forKey:USERNAME];
    [signUpDictionary setObject:self.passwordTextField.text forKey:PASSWORD];
    [signUpDictionary setObject:self.emaillTextField.text forKey:EMAIL];
    [signUpDictionary setObject:typeString forKey:TYPE];
    
    [Web_Service_Call serviceCall:signUpDictionary webServicename:SIGNUP SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *dict=responseObject;
        //[self signUpSuccess];
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
        
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        [SVProgressHUD dismiss];
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"UNKNOWN_ERROR")]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
        
    }];
}

-(void)signUpSuccess{
    [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                        withMessage:NSLOCALIZEDSTRING(@"SIGNUP_SUCCESS")
                                             inView:self
                                          withStyle:UIAlertControllerStyleAlert];
    
}

-(IBAction)interpreterCustomerButtonClicked:(UIButton *)sender{
    if (sender.tag==1) {
        //Interpreter
        typeString = INTERPRETER;
        self.interpreterImageView.image = [UIImage radioONImage];
        self.customerImageView.image = [UIImage radioOffImage];
    }
    else{
        //Customer
        typeString = CUSTOMER;
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


@end
