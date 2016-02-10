//
//  DashboardInterpreterViewController.m
//  toGo
//
//  Created by Babul Rao on 05/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "DashboardInterpreterViewController.h"

@interface DashboardInterpreterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *interpreterName;
@property (weak, nonatomic) IBOutlet UIButton *customerFeedBackButton;
@property (weak, nonatomic) IBOutlet UIButton *profileManagementButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *callYtdEarningsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *callYtdEarningslabel;
@property (weak, nonatomic) IBOutlet UILabel *callMinutesDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *callMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfCallDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfCallLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultPicBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
- (IBAction)switchButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)profileMgt_CustomerFeedBackButtonPressed:(UIButton *)sender;
@end

@implementation DashboardInterpreterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    [self setLabelButtonNames];
    [self setRoundCorners];
    [self setImages];
    [self setColors];
    [self setFonts];
    
    if ([[Utility_Shared_Instance readStringUserPreference:KINTERPRETER_AVAILABILITY_W] isEqualToString:INTERPRETER_UN_AVAILABLE]) {
        [self.switchButton setImage:[UIImage switchOffImage] forState:UIControlStateNormal];
    }
    else{
        [self.switchButton setImage:[UIImage switchONImage] forState:UIControlStateNormal];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    [Utility_Shared_Instance showProgress];
    [self performSelector:@selector(getDashBoardData) withObject:nil afterDelay:0.2];
    
//    
//    [self.sdk.Account login:[Utility_Shared_Instance readStringUserPreference:KUID_W]
//    // [self.sdk.Account login:@"babul123"
//    //[self.sdk.Account login:self.txt_userId.text
//completion:^(SdkResult *result) {
//    NSLog(@"result code=%d result description %@", result.Result, result.description);
//    if (result.Result != sdk_error_OK){
//        [[[UIAlertView alloc] initWithTitle:@"Login Error" message:result.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//        //[self.loginButton setEnabled:true];
//    }
//    else
//    {
//        //[self onLogin:result.Result];
//        if(![self.sdk.Messaging isConnected])
//            [self.sdk.Messaging connect];
//    }
//    
//}];
    
}

-(void)viewDidLayoutSubviews{
    _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
}

-(void)setLabelButtonNames{
    self.headerLabel.text = NSLOCALIZEDSTRING(@"DASHBOARD_SLIDE");
    self.noOfCallLabel.text = NSLOCALIZEDSTRING(@"No_OF_CALL");
    self.callMinutesLabel.text = NSLOCALIZEDSTRING(@"CALL_MINUTES");
    self.callYtdEarningslabel.text = NSLOCALIZEDSTRING(@"CALL_YTD_EARNINGS");
    self.statusLabel.text = NSLOCALIZEDSTRING(@"STATUS");
    [self.profileManagementButton setTitle:NSLOCALIZEDSTRING(@"PROFILE_MANAGEMENT") forState:UIControlStateNormal];
    [self.customerFeedBackButton setTitle:NSLOCALIZEDSTRING(@"CUSTOMER_FEEDBACK") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UIButton roundedCornerButton:self.profileManagementButton];
    [UIButton roundedCornerButton:self.customerFeedBackButton];
}

-(void)setImages{
    [self.customerFeedBackButton setBackgroundImage:[UIImage imageNamed:LIGHT_BUTTON_IMAGE] forState:UIControlStateNormal];
}

-(void)setColors{
    self.descriptionTextView.textColor = [UIColor textColorBlackColor];
    
    self.noOfCallDetailLabel.textColor = [UIColor buttonBackgroundColor];
    self.callMinutesDetailLabel.textColor = [UIColor buttonBackgroundColor];
    self.callYtdEarningsDetailLabel.textColor = [UIColor buttonBackgroundColor];
    
    [self.profileManagementButton setBackgroundColor:[UIColor buttonBackgroundColor]];
    [self.customerFeedBackButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    self.headerLabel.font = [UIFont normalSize];
    self.noOfCallLabel.font = [UIFont normalSize];
    self.callMinutesLabel.font = [UIFont normalSize];
    self.callYtdEarningslabel.font = [UIFont normalSize];
    self.statusLabel.font = [UIFont normalSize];
    self.descriptionTextView.font = [UIFont smallThin];
    self.interpreterName.font = [UIFont larger];
    self.profileManagementButton.titleLabel.font = [UIFont largeSize];
    self.customerFeedBackButton.titleLabel.font = [UIFont largeSize];
}


- (IBAction)changeAvailabilityStatus
{
    NSMutableDictionary *statusDict=[NSMutableDictionary new];
   [statusDict setValue:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KID_W];
   [statusDict setValue:[Utility_Shared_Instance readStringUserPreference:KEMAIL_W] forKey:KEMAIL_W];
    
    if ([self.switchButton.currentImage isEqual:[UIImage switchONImage] ]) {
        [statusDict setValue:@"true" forKey:KINTERPRETER_AVAILABILITY_W];
    }
    else{
        [statusDict setValue:@"false" forKey:KINTERPRETER_AVAILABILITY_W];
    }

    
   [Web_Service_Call serviceCallWithRequestType:statusDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:UPDATE_INTERPRETER_STATUS_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        
    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
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

- (IBAction)profileMgt_CustomerFeedBackButtonPressed:(UIButton *)sender {
}



-(void)getDashBoardData
{
    NSMutableDictionary *dashboardDict=[NSMutableDictionary new];
    [dashboardDict setValue:[Utility_Shared_Instance readStringUserPreference:KUID_W] forKey:KID_W];
    [dashboardDict setValue:[Utility_Shared_Instance readStringUserPreference:USER_TYPE] forKey:KTYPE_W];
    
    //WEB Service CODE
    [Web_Service_Call serviceCallWithRequestType:dashboardDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:GET_DASHBOARD_DATA SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                self.noOfCallDetailLabel.text = [NSString stringWithFormat:@"%@",[responseDict objectForKey:KTOTAL_NO_CALLS_W]];
                self.callMinutesDetailLabel.text = [NSString stringWithFormat:@"%@",[responseDict objectForKey:KTOTAL_CALL_MINUTES_W]];
                self.callYtdEarningsDetailLabel.text = [NSString stringWithFormat:@"%@",[responseDict objectForKey:KTOTAL_CALL_AMOUNT_W]];
            });
            
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}


- (IBAction)switchButtonPressed:(UIButton *)sender {
    
    if ([sender.currentImage isEqual:[UIImage switchONImage] ]) {
        [UIView animateWithDuration:0.5 animations:^{
          [sender setImage:[UIImage switchOffImage] forState:UIControlStateNormal];
        }];
        
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            [sender setImage:[UIImage switchONImage] forState:UIControlStateNormal];
        }];
        
    }
    [self changeAvailabilityStatus];
}
@end
