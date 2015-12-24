//
//  SlideMenuViewController.m
//  toGo
//
//  Created by Babul Rao on 15/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "Headers.h"
#import "AppDelegate.h"

@interface SlideMenuViewController ()<UITableViewDataSource,UITableViewDelegate>{
    AppDelegate *appDelegate;
}
@property(nonatomic,weak) IBOutlet UITableView *tblView;
@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = @"My Cell";
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //[FBSDKAccessToken setCurrentAccessToken:nil];
//    
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions" parameters:nil
//                                       HTTPMethod:@"DELETE"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//        // ...
//    }];
//    
//    FBSDKLoginManager *MANAGER  = [FBSDKLoginManager new];
//    [MANAGER logOut];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ( [FBSDKAccessToken currentAccessToken] ){
        [login logOut];
    }
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:@"LoginViewController"]];
    appDelegate.window.rootViewController = contentNavigationController;
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
