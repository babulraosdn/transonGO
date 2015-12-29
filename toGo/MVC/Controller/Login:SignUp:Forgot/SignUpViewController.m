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

-(IBAction)interpreterCustomerButtonClicked:(id)sender;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    signUpDictionary = [NSMutableDictionary new];
    
    self.title = NSLOCALIZEDSTRING(@"TOGO");
    self.view.backgroundColor = [UIColor backgroundColor];
    [self setCustomBackButtonForNavigation];
    //[self setKeyBoardReturntypesAndDelegates];
    [self setLabelButtonNames];
    [self setPlaceHolders];
    [self setRoundCorners];
    [self setPadding];
    [self setColors];
    [self setFonts];
    
    [self registerForKeyboardNotifications];
    
}

-(void)viewDidLayoutSubviews{
    //_scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    
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
    self.emaillTextField.tag=1;
    self.passwordTextField.tag=2;
    self.confirmpasswordTextField.tag=3;
    
    self.nameTextField.returnKeyType    = UIReturnKeyNext;
    self.emaillTextField.returnKeyType    = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    self.confirmpasswordTextField.returnKeyType = UIReturnKeyGo;
    if (!self.textFieldDelegate) {
        self.textFieldDelegate = [[CustomTextFieldDelegate alloc]init];
        self.textFieldDelegate.owner =  self;
    }
    self.emaillTextField.delegate=self.textFieldDelegate;
    self.passwordTextField.delegate=self.textFieldDelegate;
    self.nameTextField.delegate=self.textFieldDelegate;
    self.confirmpasswordTextField.delegate=self.textFieldDelegate;
    self.textFieldDelegate.selector = @selector(webServiceCall:);
    self.textFieldDelegate.owner =  self;
    */
}

-(void)setLabelButtonNames{
    self.registerAsLabel.text = NSLOCALIZEDSTRING(@"REGISTER_AS");
    self.interpreterLabel.text = NSLOCALIZEDSTRING(@"INTERPRETER");
    self.customerLabel.text = NSLOCALIZEDSTRING(@"CUSTOMER");
    [self.submitButton setTitle:NSLOCALIZEDSTRING(@"REGISTER_NOW") forState:UIControlStateNormal];
}

-(void)setPlaceHolders{
    self.emaillTextField.placeholder=NSLOCALIZEDSTRING(@"EMAIL");
    self.passwordTextField.placeholder=NSLOCALIZEDSTRING(@"PASSWORD");
    self.confirmpasswordTextField.placeholder=NSLOCALIZEDSTRING(@"CONFIRM_PASSWORD");
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.emaillTextField];
    [UITextField roundedCornerTEXTFIELD:self.passwordTextField];
    [UITextField roundedCornerTEXTFIELD:self.confirmpasswordTextField];
    [UIButton roundedCornerButton:self.submitButton];
}

-(void)setPadding{
    self.emaillTextField.leftViewMode=UITextFieldViewModeAlways;
    self.emaillTextField.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"EMAIL_PADDING_IMAGE") frame:CGRectMake(10, 3, 20, 13)];
    
    self.passwordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.passwordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"PASSWORD_PADDING_IMAGE") frame:CGRectMake(10, -3, 15, 20)];
    
    self.confirmpasswordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.confirmpasswordTextField.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"PASSWORD_PADDING_IMAGE") frame:CGRectMake(10, -1, 15, 20)];
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
    
    if (self.emaillTextField.text.length<1)
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


-(IBAction)interpreterCustomerButtonClicked:(id)sender{
    
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
