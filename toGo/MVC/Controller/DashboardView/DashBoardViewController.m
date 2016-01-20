//
//  DashBoardViewController.m
//  toGo
//
//  Created by Babul Rao on 15/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "DashBoardViewController.h"

@interface DashBoardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *provideFeedBackButton;
@property (weak, nonatomic) IBOutlet UIButton *viewPurchaseHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *manageMyProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *orderInterpretationButton;
@property (weak, nonatomic) IBOutlet UILabel *emailIDDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLanguageDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLanguageLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultPicBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    
    [self setImages];
    [self setLabelButtonNames];
    [self setRoundCorners];
    [self setColors];
    [self setFonts];
    
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //[Utility_Shared_Instance showProgress];
    //[self performSelector:@selector(getProfileInfo) withObject:nil afterDelay:0.2];
}
-(void)setLabelButtonNames{
    self.myLanguageLabel.text = NSLOCALIZEDSTRING(@"MY_LANGUAGE");
    self.emailIDLabel.text = NSLOCALIZEDSTRING(@"EMAIL_ID");
    [self.orderInterpretationButton setTitle:NSLOCALIZEDSTRING(@"ORDER_INTERPRETATION")  forState: UIControlStateNormal];
    [self.manageMyProfileButton setTitle:NSLOCALIZEDSTRING(@"MANAGE_MY_PROFILE")  forState: UIControlStateNormal];
    [self.viewPurchaseHistoryButton setTitle:NSLOCALIZEDSTRING(@"VIEW_PURCHASE_HISTORY")  forState: UIControlStateNormal];
    [self.provideFeedBackButton setTitle:NSLOCALIZEDSTRING(@"PROVIDE_FEEDBACK")  forState: UIControlStateNormal];
    
}

-(void)setImages{
    [self.manageMyProfileButton setBackgroundImage:[UIImage imageNamed:LIGHT_BUTTON_IMAGE] forState:UIControlStateNormal];
    [self.viewPurchaseHistoryButton setBackgroundImage:[UIImage imageNamed:LIGHT_BUTTON_IMAGE] forState:UIControlStateNormal];
}
-(void)setRoundCorners{
    [UIButton roundedCornerButton:self.orderInterpretationButton];
    [UIButton roundedCornerButton:self.manageMyProfileButton];
    [UIButton roundedCornerButton:self.viewPurchaseHistoryButton];
    [UIButton roundedCornerButton:self.provideFeedBackButton];
}


-(void)setColors{
    [self.nameLabel setTextColor:[UIColor navigationBarColor]];
    [self.myLanguageLabel setTextColor:[UIColor navigationBarColor]];
    [self.emailIDLabel setTextColor:[UIColor navigationBarColor]];
    [self.countryLabel setTextColor:[UIColor TEXT_BLACK_COLOR]];
    [self.myLanguageDetailLabel setTextColor:[UIColor TEXT_BLACK_COLOR]];
    [self.emailIDDetailLabel setTextColor:[UIColor TEXT_BLACK_COLOR]];
    [self.orderInterpretationButton setBackgroundColor:[UIColor buttonBackgroundColor]];
    [self.manageMyProfileButton setBackgroundColor:[UIColor buttonBackgroundColor]];
    [self.viewPurchaseHistoryButton setBackgroundColor:[UIColor buttonBackgroundColor]];
    [self.provideFeedBackButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    self.headerLabel.font = [UIFont normalSize];
    self.nameLabel.font = [UIFont largeSize];
    self.countryLabel.font = [UIFont normal];
    self.myLanguageLabel.font = [UIFont normal];
    self.myLanguageDetailLabel.font = [UIFont normal];
    self.emailIDLabel.font = [UIFont normal];
    self.emailIDDetailLabel.font = [UIFont normal];
    self.descriptionTextView.font = [UIFont normal];
    
    self.orderInterpretationButton.titleLabel.font = [UIFont largeSize];
    self.manageMyProfileButton.titleLabel.font = [UIFont largeSize];
    self.viewPurchaseHistoryButton.titleLabel.font = [UIFont largeSize];
    self.provideFeedBackButton.titleLabel.font = [UIFont largeSize];
}

-(void)getDashboardInfo
{
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"PLEASE_WAIT")]];
    //WEB Service CODE
    [Web_Service_Call getProfileInfoServiceCall:[Utility_Shared_Instance checkForNullString:[NSString stringWithFormat:@"%@%@",@"Bearer ",[Utility_Shared_Instance readStringUserPreference:USER_TOKEN]]] webServicename:PROFILE_INFO_W_USER SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
             if ([responseDict objectForKey:KDASHBOARD_W]){
                    NSMutableDictionary *dashBoardDict = [responseDict objectForKey:KDASHBOARD_W];
                    NSString *idString;
                    if ([dashBoardDict objectForKey:KID_W])
                        idString = [dashBoardDict objectForKey:KID_W];
                    if ([dashBoardDict objectForKey:KNAME_W])
                        self.nameLabel.text = [dashBoardDict objectForKey:KNAME_W];
                    if ([dashBoardDict objectForKey:KCOUNTRY_NAME_W])
                        self.countryLabel.text = [dashBoardDict objectForKey:KCOUNTRY_NAME_W];
                    if ([dashBoardDict objectForKey:KLANGUAGE_W])
                        self.myLanguageDetailLabel.text = [dashBoardDict objectForKey:KLANGUAGE_W];
                    if ([dashBoardDict objectForKey:KEMAIL_W])
                        self.emailIDDetailLabel.text = [dashBoardDict objectForKey:KEMAIL_W];
                    if ([dashBoardDict objectForKey:KDESCRIPTION_W])
                        self.descriptionTextView.text = [dashBoardDict objectForKey:KDESCRIPTION_W];
                    if ([dashBoardDict objectForKey:KPROFILE_IMAGE_W])
                        self.defaultImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dashBoardDict objectForKey:KPROFILE_IMAGE_W]]]];
              }

            });
            dispatch_async(dispatch_get_main_queue(), ^{
                
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

/*
-(void)getProfileInfo
{
    //WEB Service CODE
    [Web_Service_Call serviceCallWithRequestType:nil requestType:GET_REQUEST includeHeader:YES includeBody:NO webServicename:PROFILE_INFO_W_USER SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
                NSMutableDictionary *userDict = [responseDict objectForKey:@"user"];
                [Utility_Shared_Instance writeStringUserPreference:KID_W value:[userDict objectForKey:KID_W]];
                NSDictionary *profileImgDict =  [userDict objectForKey:KPROFILE_IMAGE_W];
                NSString *imageURLString = [profileImgDict objectForKey:KURL_W];
                if (imageURLString.length) {
                    self.defaultImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]]];
                    self.defaultImageView.layer.cornerRadius = self.defaultImageView.frame.size.height /2;
                    self.defaultImageView.layer.masksToBounds = YES;
                }
            });
            
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}
*/

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
