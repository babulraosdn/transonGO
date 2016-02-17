//
//  SettingsViewController.m
//  toGo
//
//  Created by Babul Rao on 05/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *setYourPrefferedlanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *prefferedLanguagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicationActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePasswordlabel;
@property (weak, nonatomic) IBOutlet UILabel *emailFeddBackLabel;
@property (weak, nonatomic) IBOutlet UIButton *languagesButton;
@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    [self setLabelButtonNames];
    //[self setRoundCorners];
    [self setColors];
    [self setFonts];
    
}
-(void)setLabelButtonNames{
   
    self.setYourPrefferedlanguageLabel.text = NSLOCALIZEDSTRING(@"SET_YOUR_PREFERENCED_LANGUAGE");
    self.prefferedLanguagesLabel.text = NSLOCALIZEDSTRING(@"PREFFERED_LANGUAGES");
    self.applicationActionLabel.text = NSLOCALIZEDSTRING(@"APPLICATION_ACTION");
    self.notificationLabel.text = NSLOCALIZEDSTRING(@"NOTIFICATION");
    self.changePasswordlabel.text = NSLOCALIZEDSTRING(@"CHANGE_PASSWORD");
    self.emailFeddBackLabel.text = NSLOCALIZEDSTRING(@"EMAIL_FEEDBACK");
    [self.languagesButton setTitle:NSLOCALIZEDSTRING(@"LANGUAGES") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UIButton roundedCornerButton:self.languagesButton];
}


-(void)setColors{
    [self.setYourPrefferedlanguageLabel setTextColor:[UIColor textColorBlackColor]];
    [self.prefferedLanguagesLabel setTextColor:[UIColor textColorBlackColor]];
    [self.applicationActionLabel setTextColor:[UIColor textColorBlackColor]];
    [self.notificationLabel setTextColor:[UIColor textColorBlackColor]];
    [self.changePasswordlabel setTextColor:[UIColor textColorBlackColor]];
    [self.emailFeddBackLabel setTextColor:[UIColor textColorBlackColor]];
    [self.languagesButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    self.setYourPrefferedlanguageLabel.font = [UIFont largeSize];
    self.prefferedLanguagesLabel.font = [UIFont normalSize];
    self.applicationActionLabel.font = [UIFont largeSize];
    self.notificationLabel.font = [UIFont normalSize];
    self.changePasswordlabel.font = [UIFont normalSize];
    self.emailFeddBackLabel.font = [UIFont normalSize];
    self.languagesButton.titleLabel.font = [UIFont largeSize];
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
