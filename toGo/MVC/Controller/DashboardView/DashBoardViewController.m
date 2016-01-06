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
@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
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
