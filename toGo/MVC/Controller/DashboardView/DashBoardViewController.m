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

@property(nonatomic,weak) IBOutlet NSLayoutConstraint *myLanguageTopConstraint;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *emailTopConstraint;
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
    App_Delegate.naviController= self.navigationController;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [Utility_Shared_Instance showProgress];
    [self performSelector:@selector(getProfileInfo) withObject:nil afterDelay:0.2];

}

-(void)setLabelButtonNames{
    self.headerLabel.text = NSLOCALIZEDSTRING(@"DASHBOARD_SLIDE");
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
    self.myLanguageDetailLabel.font = [UIFont smallBig];
    self.emailIDLabel.font = [UIFont normal];
    self.emailIDDetailLabel.font = [UIFont smallBig];
    self.descriptionTextView.font = [UIFont normal];
    
    self.orderInterpretationButton.titleLabel.font = [UIFont largeSize];
    self.manageMyProfileButton.titleLabel.font = [UIFont largeSize];
    self.viewPurchaseHistoryButton.titleLabel.font = [UIFont largeSize];
    self.provideFeedBackButton.titleLabel.font = [UIFont largeSize];
}

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
                [Utility_Shared_Instance writeStringUserPreference:KUID_W value:[userDict objectForKey:KUID_W]];
                [Utility_Shared_Instance writeStringUserPreference:KID_W value:[userDict objectForKey:KID_W]];
;
                self.descriptionTextView.text = [userDict objectForKey:KABOUT_USER_W];
                
                NSDictionary *profileImgDict =  [userDict objectForKey:KPROFILE_IMAGE_W];
                NSString *imageURLString = [profileImgDict objectForKey:KURL_W];
                if (imageURLString.length) {
                    [self.defaultImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]
                                             placeholderImage:[UIImage defaultPicImage]];
                    self.defaultImageView.layer.cornerRadius = self.defaultImageView.frame.size.height /2;
                    self.defaultImageView.layer.masksToBounds = YES;
                }
                
                self.emailIDDetailLabel.text = [userDict objectForKey:KEMAIL_W];
                if ([userDict objectForKey:KNAME_W]) {
                    NSDictionary *nameDict =  [userDict objectForKey:KNAME_W];
                    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",[nameDict objectForKey:KFIRST_NAME_W],[nameDict objectForKey:KLAST_NAME_W]];
                }
                else{
                    self.nameLabel.text = @"";
                }
                self.countryLabel.text = [userDict objectForKey:KCOUNTRY_W];
                if (self.countryLabel.text.length) {
                    self.countryLabel.text = [NSString stringWithFormat:@"@%@",self.countryLabel.text];
                }
                
                /*
                /////////// Languages
               // NSLog(@"--langArray -->%@",App_Delegate.languagesArray);
                 
                NSArray *langArray = [userDict objectForKey:KMYLANGUAGES_W];//[ componentsSeparatedByString:@","];
                if (langArray.count) {
                    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"languageID beginswith[c] %@",[langArray objectAtIndex:0]];
                    NSArray *sortedArray = [App_Delegate.languagesArray filteredArrayUsingPredicate:predicate];
                    if (sortedArray.count) {
                        LanguageObject *lObj = [sortedArray lastObject];
                        self.myLanguageDetailLabel.text = lObj.languageName;
                    }
                }
                else{
                    NSString *str = [userDict objectForKey:KMYLANGUAGES_W];
                    if (str.length) {
                        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"languageID beginswith[c] %@",str];
                        NSArray *sortedArray = [App_Delegate.languagesArray filteredArrayUsingPredicate:predicate];
                        if (sortedArray.count) {
                            LanguageObject *lObj = [sortedArray lastObject];
                            self.myLanguageDetailLabel.text = lObj.languageName;
                        }
                    }
                }
                /////////////////
                */
                self.myLanguageDetailLabel.text = [responseDict objectForKey:KLANGUAGE_NAME_W];
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
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
