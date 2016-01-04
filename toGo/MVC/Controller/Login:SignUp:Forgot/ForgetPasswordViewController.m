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
    
    self.title = NSLOCALIZEDSTRING(@"TOGO");
    self.view.backgroundColor = [UIColor backgroundColor];
    [self setCustomBackButtonForNavigation];
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

-(void)setPlaceHolders{
    self.emailTextField.placeholder= NSLOCALIZEDSTRING(@"EMAIL");
    self.displaylabel.text = NSLOCALIZEDSTRING(@"FILL_YOUR_EMAIL_ID_FORGOT_PASSWORD_SCREEN_TEXT");
    [self.submitButton setTitle:NSLOCALIZEDSTRING(@"SEND_EMAIL") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.emailTextField];
    [UIButton roundedCornerButton:self.submitButton];
}

-(void)setPadding{
    self.emailTextField.leftViewMode=UITextFieldViewModeAlways;
    self.emailTextField.leftView=[Utility_Shared_Instance setImageViewPadding:NSLOCALIZEDSTRING(@"EMAIL_PADDING_IMAGE") frame:CGRectMake(10, 3, 20, 13)];
}

-(void)setColors{
    [self.displaylabel setTextColor:[UIColor lightGrayConnectWithColor]];
    [self.submitButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
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
        //WEB Service CODE
        NSMutableDictionary *forgetPasswordDict=[NSMutableDictionary new];
        [forgetPasswordDict setValue:self.emailTextField.text forKey:NSLOCALIZEDSTRING(@"EMAIL")];
        [Web_Service_Call serviceCall:forgetPasswordDict webServicename:FORGOTPASSWORD SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
            //NSDictionary *dict=responseObject;
        } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        }];
        
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"FORGET_PASSWORD_SUCCESS")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
        
        [self.navigationController popViewControllerAnimated:YES];
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



@end
