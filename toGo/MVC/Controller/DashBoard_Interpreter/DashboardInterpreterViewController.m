//
//  DashboardInterpreterViewController.m
//  toGo
//
//  Created by Babul Rao on 05/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "DashboardInterpreterViewController.h"

@interface DashboardInterpreterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *interpreterName;
@property (weak, nonatomic) IBOutlet UIButton *customerFeedBackButton;
@property (weak, nonatomic) IBOutlet UIButton *profileManagementButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UISwitch *segmentControl;
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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation DashboardInterpreterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    [self setLabelButtonNames];
    [self setRoundCorners];
    [self setColors];
    [self setFonts];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews{
    _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
}

-(void)setLabelButtonNames{
    
    self.headerLabel.text = NSLOCALIZEDSTRING(@"DASHBOARD");
    self.noOfCallLabel.text = NSLOCALIZEDSTRING(@"No_OF_CALL");
    self.callMinutesLabel.text = NSLOCALIZEDSTRING(@"CALL_MINUTES");
    self.callYtdEarningslabel.text = NSLOCALIZEDSTRING(@"CALL_YTD_EARNINIGS");
    self.statusLabel.text = NSLOCALIZEDSTRING(@"STATUS");
    [self.profileManagementButton setTitle:NSLOCALIZEDSTRING(@"PROFILE_MANAGEMENT") forState:UIControlStateNormal];
    [self.customerFeedBackButton setTitle:NSLOCALIZEDSTRING(@"CUSTOMER_FEEDBACK") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UIButton roundedCornerButton:self.profileManagementButton];
    [UIButton roundedCornerButton:self.customerFeedBackButton];
}


-(void)setColors{
    self.descriptionTextView.textColor = [UIColor textColorBlackColor];
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
