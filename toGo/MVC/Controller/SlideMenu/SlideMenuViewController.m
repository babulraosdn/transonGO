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

@implementation SlideMenuCell
@end

@interface SlideMenuViewController ()<UITableViewDataSource,UITableViewDelegate>{
    AppDelegate *appDelegate;
}
@property(nonatomic,weak) IBOutlet UITableView *tblView;
@property(nonatomic,strong) NSMutableArray *namesArray;
@property(nonatomic,strong) NSMutableArray *imagesArray;
@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor backgroundColor];
    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    self.namesArray = [[NSMutableArray alloc]initWithObjects:NSLOCALIZEDSTRING(@"PROFILE"),NSLOCALIZEDSTRING(@"ORDER_INTERPRETATION"),NSLOCALIZEDSTRING(@"CALL_HISTORY"),NSLOCALIZEDSTRING(@"PURCHASES"),NSLOCALIZEDSTRING(@"FAVORITE_INTERPRETER"),NSLOCALIZEDSTRING(@"SETTINGS"), nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.namesArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SlideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SlideMenuCell"];
    cell.displayLabel.text = [self.namesArray objectAtIndex:indexPath.row];
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
