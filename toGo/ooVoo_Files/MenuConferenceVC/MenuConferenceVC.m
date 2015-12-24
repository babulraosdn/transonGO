//
//  MenuConferenceVC.m
//  ooVooSample
//
//  Created by Udi on 7/26/15.
//  Copyright (c) 2015 ooVoo LLC. All rights reserved.
//



#import "MenuConferenceVC.h"
#import "ActiveUserManager.h"
//#import "VideoConferenceVC.h"
#import "FriendsListVC.h"
#import "UserDefaults.h"
#import "Constants.h"
#import "AppDelegate.h"
#define Segue_CallOrMessage @"Segue_CallOrMessage"

@interface MenuConferenceVC ()

@end

@implementation MenuConferenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButton];
    self.navigationItem.title=@"Menu";
        self.sdk = [ooVooClient sharedInstance];
    
    
    
     NSLog(@"token =%@",[UserDefaults getObjectforKey:[ActiveUserManager activeUser].userId]);
    
    if ([UserDefaults getObjectforKey:[ActiveUserManager activeUser].userId]) {
        [ActiveUserManager activeUser].token=[UserDefaults getObjectforKey:[ActiveUserManager activeUser].userId];
    }
    
    else{
        
        
        UIApplication *application=[UIApplication sharedApplication];
        
        AppDelegate *appDelegate  = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate subscribePushNotifications:application];
        
    }
}

-(void)dealloc{
    _sdk=nil;
    
}
-(void)subscribeUser{
    NSString * uuid = ooVooAppID ;
    NSString * token = [ActiveUserManager activeUser].token;
    if(token && token.length > 0){
        [self.sdk.PushService subscribe:token deviceUid:uuid completion:^(SdkResult *result){
            [ActiveUserManager activeUser].isSubscribed = true;
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackButton {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(actLogOut)];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = item;
}

-(void)actLogOut{
    [self.navigationController popViewControllerAnimated:YES];
    //NSString * uuid = ooVooAppID ;
    NSString * token = [ActiveUserManager activeUser].token;
    if(token && token.length > 0){
        [self.sdk.Account logout];
    }else{
        [self.sdk.Account logout];
    }

    
}
#pragma mark - Navigation

// sender tag == 10 is make a call
// sender tag == 20 is send push message
- (IBAction)actMakeCallOrSendMessage:(id)sender {
    NSNumber *tag = [NSNumber numberWithInt:[sender tag]];
    
    [self performSegueWithIdentifier:Segue_CallOrMessage sender:tag];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual:Segue_CallOrMessage]) {
        FriendsListVC *Fvc=segue.destinationViewController;
        
        if ([sender isEqualToNumber:@10]) // call
        {
            Fvc.isForCall =true;
        }
    }
}





@end
