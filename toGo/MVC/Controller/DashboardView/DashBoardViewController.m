//
//  DashBoardViewController.m
//  toGo
//
//  Created by Babul Rao on 15/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "DashBoardViewController.h"
#import "AppDelegate.h"

@interface DashBoardViewController (){
    AppDelegate  *appDelegate;
}

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    self.title = NSLOCALIZEDSTRING(@"TOGO");
    self.view.backgroundColor = [UIColor backgroundColor];
    
    //[self setSlideMenuButtonFornavigation];
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
