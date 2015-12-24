//
//  DashBoardViewController.m
//  toGo
//
//  Created by Babul Rao on 15/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "DashBoardViewController.h"
#import "AppDelegate.h"
#import <TheSidebarController/TheSidebarController.h>
@interface DashBoardViewController (){
    AppDelegate  *appDelegate;
}

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStyleDone target:self action:@selector(test)];
//    self.navigationController.navigationItem.leftBarButtonItem = anotherButton;

    
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

- (void)navigationBarLeftButtonClicked {
    
    
    if(self.sidebarController.sidebarIsPresenting){
        [self.sidebarController dismissSidebarViewController];
    }else{
        [self.sidebarController presentLeftSidebarViewControllerWithStyle:0];
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
