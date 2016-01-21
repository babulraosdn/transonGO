//
//  HomeViewController.m
//  toGo
//
//  Created by Babul Rao on 08/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property(nonatomic,weak) IBOutlet UIButton *interpreterButton;
@property(nonatomic,weak) IBOutlet UIButton *customerButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLOCALIZEDSTRING(@"TOGO");
    self.view.backgroundColor = [UIColor backgroundColor];
    
    [self setLabelButtonNames];
    [self setColors];
    [self setFonts];
    
}
-(void)setLabelButtonNames{
    
    [self.interpreterButton setTitle:NSLOCALIZEDSTRING(@"INTERPRETER") forState:UIControlStateNormal];
    [self.customerButton setTitle:NSLOCALIZEDSTRING(@"CUSTOMER") forState:UIControlStateNormal];
}


-(void)setColors{
    
    [self.interpreterButton setTitleColor:[UIColor textColorBlackColor] forState:UIControlStateNormal];
    [self.customerButton setTitleColor:[UIColor textColorBlackColor] forState:UIControlStateNormal];
}

-(void)setFonts{
    self.interpreterButton.titleLabel.font = [UIFont largeSize];
    self.customerButton.titleLabel.font = [UIFont largeSize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"INTERPRETER"]) {
        [Utility_Shared_Instance writeStringUserPreference:USER_TYPE value:INTERPRETER];
    }
    if ([segue.identifier isEqualToString:@"CUSTOMER"]) {
        [Utility_Shared_Instance writeStringUserPreference:USER_TYPE value:CUSTOMER];
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
