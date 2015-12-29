		//
//  BaseViewController.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)navigateToLoginView{

    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:@"LoginViewController"]];
    appDelegate.window.rootViewController=navController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setSlideMenuButtonFornavigation{
    UIImage *img1=[UIImage imageNamed:@"drawer-ico"];
    CGRect frameimg1 = CGRectMake(0, 0, img1.size.width, img1.size.height);
    UIButton *backBtn=[[UIButton alloc]initWithFrame:frameimg1];
    [backBtn setBackgroundImage:img1 forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBarLeftButtonClicked)
      forControlEvents:UIControlEventTouchUpInside];
    [backBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=barButton;
}

-(void)setCustomBackButtonForNavigation{
    
    
    UIImage *img1=[UIImage imageNamed:@"back-arrow.png"];
    CGRect frameimg1 = CGRectMake(0, 0, img1.size.width, img1.size.height);
    UIButton *backBtn=[[UIButton alloc]initWithFrame:frameimg1];
    [backBtn setBackgroundImage:img1 forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed)
      forControlEvents:UIControlEventTouchUpInside];
    //[backBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=barButton;
}

- (void)navigationBarLeftButtonClicked {
    
    if(self.sidebarController.sidebarIsPresenting){
        [self.sidebarController dismissSidebarViewController];
    }else{
        [self.sidebarController presentLeftSidebarViewControllerWithStyle:0];
    }
}

-(void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)webServiceCall:(id)sender{
    
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
