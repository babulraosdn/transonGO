//
//  OrderInterpretationViewController.m
//  toGo
//
//  Created by Babul Rao on 25/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "OrderInterpretationViewController.h"
#import "MenuConferenceVC.h"
#import "MessageManager.h"
#import "ActiveUserManager.h"
#define TimeOut 30
@interface OrderInterpretationViewController ()<UIAlertViewDelegate>{
    UIButton *selectedButton;
    UIAlertView *myAlertView ;
    
    NSTimer *timer;
    int secCounter;
    
    NSMutableArray *arrFriends ; // we create friend list in this view only
    
    NSString *fromLanguageKeyString;
    NSString *toLanguageKeyString;

}
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fromImageView;
@property (weak, nonatomic) IBOutlet UIImageView *toImageView;

@property(nonatomic,strong) NSMutableArray *fromLanguageArray;
@property(nonatomic,strong) NSMutableArray *toLanguageArray;
@end

@implementation OrderInterpretationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    App_Delegate.naviController = self.navigationController;
    
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    [self setLabelButtonNames];
    [self setRoundCorners];
    [self setColors];
    [self setFonts];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [Utility_Shared_Instance showProgress];
    [self performSelector:@selector(getProfileInfo) withObject:nil afterDelay:0.2];
}

-(void)setLabelButtonNames{
    self.headerLabel.text = NSLOCALIZEDSTRING(@"SELCET_YOUR_INTERPRETATION_LANGUAGE");
    self.fromLabel.text = NSLOCALIZEDSTRING(@"FROM");
    self.toLabel.text = NSLOCALIZEDSTRING(@"TO");
    [self.confirmButton setTitle:NSLOCALIZEDSTRING(@"CONFIRM") forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLOCALIZEDSTRING(@"CANCEL") forState:UIControlStateNormal];
}

-(void)setRoundCorners{
    [UIButton roundedCornerButton:self.confirmButton];
    [UIButton roundedCornerButton:self.cancelButton];
    
    self.fromImageView.layer.cornerRadius = self.fromImageView.frame.size.height /2;
    self.fromImageView.layer.masksToBounds = YES;
    [self.fromImageView setContentMode:UIViewContentModeScaleToFill];
    
    self.toImageView.layer.cornerRadius = self.fromImageView.frame.size.height /2;
    self.toImageView.layer.masksToBounds = YES;
    [self.toImageView setContentMode:UIViewContentModeScaleToFill];

}


-(void)setColors{
    [self.fromDetailLabel setTextColor:[UIColor textColorBlackColor]];
    [self.fromLabel setTextColor:[UIColor buttonBackgroundColor]];
    [self.toDetailLabel setTextColor:[UIColor textColorBlackColor]];
    [self.toLabel setTextColor:[UIColor buttonBackgroundColor]];
    [self.descriptionLabel setTextColor:[UIColor buttonBackgroundColor]];
    [self.confirmButton setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    self.headerLabel.font = [UIFont normalSize];
    self.fromLabel.font = [UIFont normal];
    self.fromDetailLabel.font = [UIFont normal];
    self.toLabel.font = [UIFont normal];
    self.toDetailLabel.font = [UIFont normal];
    self.descriptionLabel.font = [UIFont normal];
    self.confirmButton.titleLabel.font = [UIFont largeSize];
    self.cancelButton.titleLabel.font = [UIFont largeSize];
}

-(IBAction)selectLanguageButtonPressed:(UIButton*)sender{
    
    selectedButton = sender;
    
    if ([self.view viewWithTag:1000]) {
        [[self.view viewWithTag:1000] removeFromSuperview];
    }
    
    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.tag = 1000;
    
    languagesView.delegate = self;
    languagesView.isSelectInterpretationLanguage = YES;
    
    languagesView.selectedDataArray  = [NSMutableArray new];
    
    if (App_Delegate.languagesArray.count)
        languagesView.dataArray = App_Delegate.languagesArray;
    
    if (selectedButton.tag==1) {
        if (self.fromLanguageArray.count) {
            languagesView.selectedDataArray = self.self.fromLanguageArray;
        }
    }
    else{
        if (self.toLanguageArray.count) {
            languagesView.selectedDataArray = self.self.toLanguageArray;
        }
    }
    
    [languagesView.tblView reloadData];
    [self.view addSubview:languagesView];
}

-(IBAction)confirmCancelButtonPressed:(UIButton *)sender{
    if (sender.tag==1) {
        //appDelegate.callingUsers = arrFriends;
        
        myAlertView = [[UIAlertView alloc] initWithTitle:@"Calling" message:@""
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:nil, nil];
        myAlertView.tag=100; // call alert
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loading.frame=CGRectMake(0, 0, 16, 16);
        [myAlertView setValue:loading forKey:@"accessoryView"];
        [loading startAnimating];
        [myAlertView show];
        
        [self callToFriends];
        
        NSMutableArray *arr = [NSMutableArray new];
        [arr addObject:@"babul123"];
        [[MessageManager sharedMessage]messageOtherUsers:[arr mutableCopy] WithMessageType:Calling WithConfID:[ActiveUserManager activeUser].randomConference Compelition:^(BOOL CallSuccess) {
            
            
            
            if (!CallSuccess) {
                [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
            }
            else
            {
                [self stopTimer];
                timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer_Tick:) userInfo:nil repeats:YES];
                
            }
            
        }];
        //[self performSegueWithIdentifier:Segue_MenuConferenceVC sender:nil]; //
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_ooVoo" bundle:[NSBundle mainBundle]];
//        MenuConferenceVC *menu = (MenuConferenceVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"MenuConferenceVC"];
//        [self.navigationController pushViewController:menu animated:YES];
        //[self performSegueWithIdentifier:Segue_MenuConferenceVC sender:nil];
    }
    else{
        
    }
}

-(void)getLanguagePrice{
    //WEB Service CODE
    [Utility_Shared_Instance showProgress];
    NSMutableDictionary *languagePriceDict=[NSMutableDictionary new];
    [languagePriceDict setValue:fromLanguageKeyString forKey:KFROM_LANGUAGE_W];
    [languagePriceDict setValue:toLanguageKeyString forKey:KTO_LANGUAGE_W];
    [Web_Service_Call serviceCallWithRequestType:languagePriceDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:GET_INTERPRETER_BY_LANGUAGE_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            NSMutableArray *array = [responseDict objectForKey:KDATA_W];
            if (array.count) {
                arrFriends = [NSMutableArray new];
                App_Delegate.interpreterListArray = [NSMutableArray new];
                for (id json in array) {
                    InterpreterListObject *iObj = [InterpreterListObject new];
                    iObj.emailString  = [json objectForKey:KEMAIL_W];
                    iObj.interpreter_availabilityString  = [json objectForKey:KINTERPRETER_AVAILABILITY_W];
                    iObj.statusString  = [json objectForKey:KSTATUS_W];
                    iObj.uidString  = [json objectForKey:KUID_W];
                    iObj.usernameString  = [json objectForKey:KUSERNAME_W];
                    [App_Delegate.interpreterListArray addObject:iObj];
                    [arrFriends addObject:[json objectForKey:KUID_W]];
                }
            }
            
            NSMutableArray *priceArray = [responseDict objectForKey:KPRICE_W];
            if (priceArray.count) {
                NSMutableDictionary *priceDict = [priceArray lastObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.descriptionLabel.text = [NSString stringWithFormat:@"%@ $%.2f %@",NSLOCALIZEDSTRING(@"INTERPRETATION_SERVICE_CHARGE"),[[Utility_Shared_Instance checkForNullString:[priceDict objectForKey:KLANGUAGE_PRICE_W]] floatValue],NSLOCALIZEDSTRING(@"PER_MIN")];
                    [SVProgressHUD dismiss];
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                    withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                         inView:self
                                                      withStyle:UIAlertControllerStyleAlert];
                
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
        });
    }];
}

-(void)finishLanguagesSelection:(NSMutableArray *)selectedDataArray{
    if (selectedButton.tag==1) {
        self.fromLanguageArray =  selectedDataArray;
        if (selectedDataArray.count) {
            LanguageObject *lObj = [selectedDataArray lastObject];
            fromLanguageKeyString = lObj.languageID;
            self.fromDetailLabel.text = lObj.languageName;
            [self.fromImageView sd_setImageWithURL:[NSURL URLWithString:lObj.imagePathString]
                                     placeholderImage:[UIImage defaultPicImage]];
        }
    }
    else{
        self.toLanguageArray = selectedDataArray;
        if (selectedDataArray.count) {
            LanguageObject *lObj = [selectedDataArray lastObject];
            toLanguageKeyString = lObj.languageID;
            self.toDetailLabel.text = lObj.languageName;
            [self.toImageView sd_setImageWithURL:[NSURL URLWithString:lObj.imagePathString]
                                  placeholderImage:[UIImage defaultPicImage]];
        }
    }
    
    if (self.fromDetailLabel.text.length && self.toDetailLabel.text.length) {
        [self getLanguagePrice];
    }
}


-(void)getProfileInfo
{
    //WEB Service CODE
    [Web_Service_Call serviceCallWithRequestType:nil requestType:GET_REQUEST includeHeader:YES includeBody:NO webServicename:PROFILE_INFO_W_USER SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
                NSMutableDictionary *userDict = [responseDict objectForKey:@"user"];
                [Utility_Shared_Instance writeStringUserPreference:KID_W value:[userDict objectForKey:KID_W]];
                ;
                /////////// Languages
               // NSLog(@"--langArray -->%@",App_Delegate.languagesArray);
                NSArray *langArray = [userDict objectForKey:KMYLANGUAGES_W];//[ componentsSeparatedByString:@","];
                if (langArray.count) {
                    fromLanguageKeyString = [langArray lastObject];
                    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"languageID beginswith[c] %@",[langArray objectAtIndex:0]];
                    NSArray *sortedArray = [App_Delegate.languagesArray filteredArrayUsingPredicate:predicate];
                    if (sortedArray.count) {
                        LanguageObject *lObj = [sortedArray lastObject];
                        self.fromDetailLabel.text = lObj.languageName;
                        [self.fromImageView sd_setImageWithURL:[NSURL URLWithString:lObj.imagePathString]
                                              placeholderImage:[UIImage defaultPicImage]];
                    }
                }
                else{
                    NSString *str = [userDict objectForKey:KMYLANGUAGES_W];
                    if (str.length) {
                        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"languageID beginswith[c] %@",str];
                        NSArray *sortedArray = [App_Delegate.languagesArray filteredArrayUsingPredicate:predicate];
                        if (sortedArray.count) {
                            LanguageObject *lObj = [sortedArray lastObject];
                            self.fromDetailLabel.text = lObj.languageName;
                            [self.fromImageView sd_setImageWithURL:[NSURL URLWithString:lObj.imagePathString]
                                                  placeholderImage:[UIImage defaultPicImage]];
                        }
                    }
                }
                /////////////////
            
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

#pragma Mark ooVoo Call
#pragma  mark - Call Methods CNMESSAGE
int callAmount1 = 0 ; // saving the calling amount so if one of then rejects , the call alert conyinue to show for the other friends call
-(void)callToFriends{
    
    callAmount1=[arrFriends count];
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.callingUsers = arrFriends;
    __block index=0;
    
    //  for (int i=0; i<[arrFriends count]; i++)
    {
        //  NSString *userName = arrFriends[i];
        
        //    NSLog(@"Calling friend %@",userName);
        // sending a message of calling BUT if something is wrong cancel the call alert
        [[MessageManager sharedMessage]messageOtherUsers:arrFriends WithMessageType:Calling WithConfID:[ActiveUserManager activeUser].randomConference Compelition:^(BOOL CallSuccess) {
            
            
            
            if (!CallSuccess) {
                [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
            }
            else
            {
                [self stopTimer];
                timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer_Tick:) userInfo:nil repeats:YES];
                
            }
            
        }];
        
    }
    
    
}

-(void)sendMsgToFriends:(NSString*)message{
    NSLog(@"msg = %@",message);
    
    //no need for sending push for each user becuase message receives array of users and send the push to all of them
    //for (NSString *userName in arrFriends) {
    
    ooVooPushNotificationMessage * msg = [[ooVooPushNotificationMessage alloc] initMessageWithUsersArray:arrFriends message:message property:@"Im optional" timeToLeave:1000];
    
        [self.sdk.PushService sendPushMessage:msg completion:^(SdkResult *result){
        if(result.Result == sdk_error_OK)
        {
            NSLog(@"Send succeeded");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sent Msg" message:@"Your msg has been sent ,Thanks ! " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    
    //}
    
}

-(void)timer_Tick:(NSTimer*)timer{
    secCounter++;
    NSLog(@"Counter Timer %d",secCounter);
    
    if (secCounter>=TimeOut) {
        [self callCancelFriends];
        [timer invalidate];
        secCounter=0;
        if (myAlertView) {
            [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
            
        }
    }
}


// if the caller canceled his call
-(void)callCancelFriends{
    
    [self stopTimer];
    
    callAmount1=0;
    
    // for (NSString *userName in arrFriends) {
    //     NSLog(@"Calling friend %@",userName);
    [[MessageManager sharedMessage]messageOtherUsers:arrFriends WithMessageType:Cancel WithConfID:[ActiveUserManager activeUser].randomConference Compelition:^(BOOL CallSuccess) {
        
    }];
    //  }
    
}


-(void)stopTimer{
    if (timer.valid) {
        [timer invalidate];
        secCounter=0;
    }
}

-(void)remoteUserIsOffLine:(NSNotification*)notif{
    // some one rejected the call
    
    NSLog(@"notification %@",notif.userInfo);
    NSString *userName=[notif object];
    
    callAmount1--;
    
    if (!callAmount1) // if there are other friends we call to than dont remove the call spinner alert
    {
        [self stopCallAndDismissView];
    }
    
    [self showAlertWithTitle:@"OffLine" WithMessage:[NSString stringWithFormat:@"Your friend %@ \n is Offline.",userName]  CancelButton:@"Ok" OkButton:nil];
    
}


-(void)AnswerDecline:(NSNotification*)notif{
    // some one rejected the call
    
    NSLog(@"notification %@",notif.userInfo);
    CNMessage *message=[notif object];
    
    callAmount1--;
    
    if (!callAmount1) // if there are other friends we call to than dont remove the call spinner alert
    {
        [self stopCallAndDismissView];
    }
    
    [self showAlertWithTitle:@"Rejected" WithMessage:[NSString stringWithFormat:@"Your friend %@ \n rejected the call.",message.displayName]  CancelButton:@"Ok" OkButton:nil];
    
}

-(void)otherUserbusy:(NSNotification*)notif{
    // some one rejected the call
    
    NSLog(@"notification %@",notif.userInfo);
    CNMessage *message=[notif object];
    
    callAmount1--;
    
    if (!callAmount1) // if there are other friends we call to than dont remove the call spinner alert
    {
        [self stopCallAndDismissView];
    }
    
    [self showAlertWithTitle:@"Busy" WithMessage:[NSString stringWithFormat:@"Your friend %@ \n is busy with another call.",message.displayName]  CancelButton:@"Ok" OkButton:nil];
    
}

-(void)stopCallAndDismissView{
    [self stopTimer];
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [[MessageManager sharedMessage]stopCallSound];
    
}

-(void)AnswerAccept{
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [self stopTimer];
}



-(void)showAlertWithTitle:(NSString*)title WithMessage:(NSString*)message CancelButton:(NSString*)cancel OkButton:(NSString*)Ok{
    
    UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:Ok,nil];
    
    if (Ok!=nil) {
        alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
    }
    
    [alertViewChangeName show];
    
    
}

#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==100) // call alert
    {
        if (alertView.cancelButtonIndex == buttonIndex)
        {
            // cancell the call Send to the users
            [self callCancelFriends];
            
            return;
        }
    }
    
    if (alertView.tag==200) // call alert
    {
        if (alertView.cancelButtonIndex != buttonIndex)
        {
            // cancell the call Send to the users
            UITextField *text = [alertView textFieldAtIndex:0];
            
            [self sendMsgToFriends:text.text];
            
            return;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
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
