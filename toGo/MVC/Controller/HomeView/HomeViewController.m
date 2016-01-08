//
//  HomeViewController.m
//  toGo
//
//  Created by Babul Rao on 08/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
