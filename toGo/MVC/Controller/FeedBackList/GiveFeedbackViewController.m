//
//  GiveFeedbackViewController.m
//  toGO
//
//  Created by Babul Rao on 10/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "GiveFeedbackViewController.h"

@interface GiveFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UIView *ratingsUIView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextView *serviceTextView;
@property (weak, nonatomic) IBOutlet UITextView *interpreterTextView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerRatingsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sendRatingsButton;
@property (weak, nonatomic) IBOutlet UILabel *yourFeedBackLabel;
@end

@implementation GiveFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    
    [self setPlaceHolders];
    [self setImages];
    [self setLabelButtonNames];
    [self setRoundCorners];
    [self setColors];
    [self setFonts];
    [self setPadding];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    App_Delegate.naviController= self.navigationController;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)setPlaceHolders{
    self.nameTextField.placeholder = NSLOCALIZEDSTRING(@"NAME");
    self.timeTextField.placeholder = NSLOCALIZEDSTRING(@"TIME");
}

-(void)setLabelButtonNames{
    self.yourFeedBackLabel.text = NSLOCALIZEDSTRING(@"YOUR_FEEDBACK_HAS_WEIGHT");
    self.offerRatingsLabel.text = NSLOCALIZEDSTRING(@"OFFER_RATINGS");
    [self.sendRatingsButton setTitle:NSLOCALIZEDSTRING(@"SEND_RATINGS")  forState: UIControlStateNormal];
    self.headerLabel.text = NSLOCALIZEDSTRING(@"FEEDBACK");
}

-(void)setImages{
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.nameTextField];
    [UITextField roundedCornerTEXTFIELD:self.timeTextField];
    [UITextView roundedCornerTextView:self.serviceTextView];
    [UITextView roundedCornerTextView:self.interpreterTextView];
    [UIButton roundedCornerButton:self.sendRatingsButton];
}

-(void)setPadding{
    self.nameTextField.leftViewMode=UITextFieldViewModeAlways;
    self.timeTextField.leftView=[Utility_Shared_Instance setImageViewPadding:USER_ID_PADDING_IMAGE frame:CGRectMake(10, 0, 16, 16)];
}

-(void)setColors{
    self.yourFeedBackLabel.textColor = [UIColor textColorBlackColor];
    self.offerRatingsLabel.textColor = [UIColor textColorBlackColor];
    [self.sendRatingsButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    self.headerLabel.font = [UIFont normalSize];
    self.yourFeedBackLabel.font = [UIFont normalSize];
    self.offerRatingsLabel.font = [UIFont normalSize];
    self.sendRatingsButton.titleLabel.font = [UIFont largeSize];
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
