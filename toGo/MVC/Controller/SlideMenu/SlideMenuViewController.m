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
@property(nonatomic,strong) NSMutableArray *imagesNamesArray;
@property(nonatomic,strong) NSMutableArray *colorCodesArray;
@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor navigationBarColor];//This changes the statusbar Color
    self.tblView.backgroundColor = [UIColor slideMenuBackgroundColor];//This is table view back goring color
    appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    self.namesArray = [[NSMutableArray alloc]initWithObjects:
                       NSLOCALIZEDSTRING(@"PROFILE"),
                       NSLOCALIZEDSTRING(@"CALL_HISTORY"),
                       NSLOCALIZEDSTRING(@"SETTINGS"), nil];
    self.imagesNamesArray = [[NSMutableArray alloc]initWithObjects:
                             PROFILE_IMAGE,
                             CALL_HISTORY_IMAGE,
                             SETTINGS_IMAGE, nil];
    self.colorCodesArray = [[NSMutableArray alloc]initWithObjects:
                            [UIColor slideMenuBackgroundColorRow1],
                            [UIColor slideMenuBackgroundColorRow2],
                            [UIColor slideMenuBackgroundColorRow3],
                            [UIColor slideMenuBackgroundColorRow4],
                            [UIColor slideMenuBackgroundColorRow5],
                            [UIColor slideMenuBackgroundColorRow6], nil];
    
    /*
    self.namesArray = [[NSMutableArray alloc]initWithObjects:
                       NSLOCALIZEDSTRING(@"PROFILE"),
                       NSLOCALIZEDSTRING(@"ORDER_INTERPRETATION"),
                       NSLOCALIZEDSTRING(@"CALL_HISTORY"),
                       NSLOCALIZEDSTRING(@"PURCHASES"),
                       NSLOCALIZEDSTRING(@"FAVORITE_INTERPRETER"),
                       NSLOCALIZEDSTRING(@"SETTINGS"), nil];
    self.imagesNamesArray = [[NSMutableArray alloc]initWithObjects:
                       PROFILE_IMAGE,
                       ORDER_INTERPRETER_IMAGE,
                       CALL_HISTORY_IMAGE,
                       PURCHASE_IMAGE,
                       FAV_INTERPRETER_IMAGE,
                       SETTINGS_IMAGE, nil];
    self.colorCodesArray = [[NSMutableArray alloc]initWithObjects:
                            [UIColor slideMenuBackgroundColorRow1],
                            [UIColor slideMenuBackgroundColorRow2],
                            [UIColor slideMenuBackgroundColorRow3],
                            [UIColor slideMenuBackgroundColorRow4],
                            [UIColor slideMenuBackgroundColorRow5],
                            [UIColor slideMenuBackgroundColorRow6], nil];
    */
    
}

#pragma Mark TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SlideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SlideMenuCell"];
    cell.displayImageView.image = [UIImage imageNamed:[self.imagesNamesArray objectAtIndex:indexPath.row]];
    cell.displayLabel.text = [self.namesArray objectAtIndex:indexPath.row];
    cell.displayLabel.font = [UIFont smallBig];
    cell.contentView.backgroundColor = [self.colorCodesArray objectAtIndex:indexPath.row];
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
    
    self.sidebarController.delegate = nil;
    [self.sidebarController dismissSidebarViewController];
    NSString *selectedRowString = [self.namesArray objectAtIndex:indexPath.row];
    UINavigationController *contentNaviationController;
    if([selectedRowString isEqualToString:NSLOCALIZEDSTRING(@"PROFILE")]){
        contentNaviationController = [[UINavigationController alloc]initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:PROFILE_VIEW_CONTROLLER]];
        self.sidebarController.contentViewController = contentNaviationController ;
    }
    else if([selectedRowString isEqualToString:NSLOCALIZEDSTRING(@"ORDER_INTERPRETATION")]){
        
    }
    else if([selectedRowString isEqualToString:NSLOCALIZEDSTRING(@"CALL_HISTORY")]){
        
    }
    else if([selectedRowString isEqualToString:NSLOCALIZEDSTRING(@"PURCHASES")]){
        
    }
    else if([selectedRowString isEqualToString:NSLOCALIZEDSTRING(@"FAVORITE_INTERPRETER")]){
        
    }
    else if([selectedRowString isEqualToString:NSLOCALIZEDSTRING(@"SETTINGS")]){
        
        contentNaviationController = [[UINavigationController alloc]initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:SETTINGS_VIEW_CONTROLLER]];
        self.sidebarController.contentViewController = contentNaviationController ;
        return;
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        if ( [FBSDKAccessToken currentAccessToken] ){
            [login logOut];
        }
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
        
        UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:@"LoginViewController"]];
        appDelegate.window.rootViewController = contentNavigationController;
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
