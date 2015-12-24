//
//  SignUpViewController.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate>{
    NSMutableDictionary *signUpDictionary;
    NSMutableArray *signUpArray;
    UITextField *activeField;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SignUpViewController
@dynamic emailTextField,nameTextField,passwordTextField,confirmpasswordTextField,submitButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    signUpDictionary = [NSMutableDictionary new];
    
    self.title = NSLOCALIZEDSTRING(@"TOGO");
    self.view.backgroundColor = [UIColor backgroundColor];
    [self setCustomBackButtonForNavigation];
    //[self setKeyBoardReturntypesAndDelegates];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];
    [self setColors];
    [self setFonts];
    
    [self registerForKeyboardNotifications];
    
}

-(void)viewDidLayoutSubviews{
    _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    
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


-(void)setKeyBoardReturntypesAndDelegates{
    
    /*
    self.nameTextField.tag=0;
    self.emailTextField.tag=1;
    self.passwordTextField.tag=2;
    self.confirmpasswordTextField.tag=3;
    
    self.nameTextField.returnKeyType    = UIReturnKeyNext;
    self.emailTextField.returnKeyType    = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    self.confirmpasswordTextField.returnKeyType = UIReturnKeyGo;
    if (!self.textFieldDelegate) {
        self.textFieldDelegate = [[CustomTextFieldDelegate alloc]init];
        self.textFieldDelegate.owner =  self;
    }
    self.emailTextField.delegate=self.textFieldDelegate;
    self.passwordTextField.delegate=self.textFieldDelegate;
    self.nameTextField.delegate=self.textFieldDelegate;
    self.confirmpasswordTextField.delegate=self.textFieldDelegate;
    self.textFieldDelegate.selector = @selector(webServiceCall:);
    self.textFieldDelegate.owner =  self;
    */
}

-(void)setPlaceHolders{
    self.nameTextField.placeholder=NSLOCALIZEDSTRING(@"NAME");
    self.emailTextField.placeholder=NSLOCALIZEDSTRING(@"EMAIL");
    self.passwordTextField.placeholder=NSLOCALIZEDSTRING(@"PASSWORD");
    self.confirmpasswordTextField.placeholder=NSLOCALIZEDSTRING(@"CONFIRM_PASSWORD");
    [self.submitButton setTitle:NSLOCALIZEDSTRING(@"REGISTER_NOW") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.nameTextField];
    [UITextField roundedCornerTEXTFIELD:self.emailTextField];
    [UITextField roundedCornerTEXTFIELD:self.passwordTextField];
    [UITextField roundedCornerTEXTFIELD:self.confirmpasswordTextField];
    [UIButton roundedCornerButton:self.submitButton];
}

-(void)setPadding{
    self.nameTextField.leftViewMode=UITextFieldViewModeAlways;
    self.nameTextField.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"USER_ID_PADDING_IMAGE") frame:CGRectMake(10, 0, 17, 17)];
    
    self.emailTextField.leftViewMode=UITextFieldViewModeAlways;
    self.emailTextField.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"USER_ID_PADDING_IMAGE") frame:CGRectMake(10, 0, 17, 17)];
    
    self.passwordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.passwordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"PASSWORD_PADDING_IMAGE") frame:CGRectMake(10, 0, 17, 17)];
    
    self.confirmpasswordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.confirmpasswordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"PASSWORD_PADDING_IMAGE") frame:CGRectMake(10, 0, 17, 17)];
}

-(void)setColors{
    [self.submitButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
}



-(IBAction)webServiceCall:(id)sender {
    
    [self.view endEditing:YES];
    
     [self signUpWebServiceCall];
    if (self.nameTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.nameTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else  if (self.emailTextField.text.length<1)
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(self.emailTextField.placeholder)]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    else if (![Utility_Shared_Instance validateEmailWithString:self.emailTextField.text])
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
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"PASSWORD_MISMATCH")]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
    
    else{
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"SIGNUP_SUCCESS")]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
        [self signUpWebServiceCall];
    }
    
    /*
    for (id value in signUpArray) {
        if (![signUpDictionary objectForKey:value] || [[signUpDictionary objectForKey:value] length]<1) {
            [Utility_Shared_Instance showMessageWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME) andMessage:[NSString messageWithString:value]];
            break;
        }
        if (![Utility_Shared_Instance validateEmailWithString:[signUpDictionary objectForKey:NSLOCALIZEDSTRING(@"EMAIL")]]) {
            [Utility_Shared_Instance showMessageWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME) andMessage:[NSString messageWithString:NSLOCALIZEDSTRING(@"VALID_EMAILID")]];
            return;
        }
        if (![[signUpDictionary objectForKey:NSLOCALIZEDSTRING(@"PASSWORD")] isEqualToString:[signUpDictionary objectForKey:NSLOCALIZEDSTRING(@"CONFIRM_PASSWORD")]]) {
            [Utility_Shared_Instance showMessageWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME) andMessage:NSLOCALIZEDSTRING(@"PASSWORD_MISMATCH")];
            return;
        }
    }
    */
    
    //Web Service CODE
    //[self signUpWebServiceCall];
}

-(void)signUpWebServiceCall{

    [signUpDictionary setObject:@"123" forKey:@"id"];
    [signUpDictionary setObject:@"testBabul" forKey:@"username"];
    [signUpDictionary setObject:@"567t14" forKey:@"password"];
    [signUpDictionary setObject:@"tset457@gmail.com" forKey:@"email"];
    [signUpDictionary setObject:@"true" forKey:@"status"];
    
    NSString *payload = [Utility_Shared_Instance preparePayloadForDictionary:signUpDictionary];
    [Web_Service_Call serviceCall:signUpDictionary webServicename:SIGNUP SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *dict=responseObject;
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
    }];
    
    
    
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
