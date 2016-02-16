//
//  CallSummaryViewController.m
//  toGO
//
//  Created by Babul Rao on 16/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "CallSummaryViewController.h"

@interface CallSummaryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *callDurationTextField;
@end

@implementation CallSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRoundCorners];
    [self setLabelButtonNames];
    [self setColors];
    [self setFonts];
}

-(void)setRoundCorners{
    [UITextField roundedCornerTEXTFIELD:self.userTextField];
    [UITextField roundedCornerTEXTFIELD:self.fromTextField];
    [UITextField roundedCornerTEXTFIELD:self.dateTextField];
    [UITextField roundedCornerTEXTFIELD:self.toTextField];
    [UITextField roundedCornerTEXTFIELD:self.timeTextField];
    [UITextField roundedCornerTEXTFIELD:self.callDurationTextField];
    [UIButton roundedCornerButton:self.backButton];
}

-(void)setLabelButtonNames{
    [self.backButton setTitle:NSLOCALIZEDSTRING(@"BACK") forState:UIControlStateNormal];
    self.headerLabel.text = NSLOCALIZEDSTRING(@"CALL_SUMMARY");
}

-(void)setColors{
    self.backButton.backgroundColor  = [UIColor buttonBackgroundColor];
}

-(void)setFonts{
    
    self.backButton.titleLabel.font = [UIFont normalSize];
    self.headerLabel.font = [UIFont normalSize];
}

-(IBAction)backButtonPressed:(id)sender{
    
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
