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
#import "UserDefaults.h"
#define TimeOut 30

@interface OrderInterpretationViewController ()<UIAlertViewDelegate>{
    UIButton *selectedButton;
    UIAlertView *myAlertView ;
    
    NSTimer *timer;
    int secCounter;
    
    NSMutableArray *arrFriends ; // we create friend list in this view only
    
    NSString *fromLanguageKeyString;
    NSString *toLanguageKeyString;
    
    BOOL isViewDidLoad;
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
@dynamic sdk;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    [self setLabelButtonNames];
    [self setRoundCorners];
    [self setColors];
    [self setFonts];
    
    if (App_Delegate.languagesArray.count<1) {
        [App_Delegate getLanguages];
    }
    
    [App_Delegate UnSetNotificationObserversForCallMessaging];
    [App_Delegate SetNotificationObserversForCallMessaging];
    
    isViewDidLoad = YES;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    if (isViewDidLoad) {
        isViewDidLoad = NO;
        [Utility_Shared_Instance showProgress];
        [self performSelector:@selector(getProfileInfo) withObject:nil afterDelay:0.2];
    }
    
}

-(void)setLabelButtonNames {
    
    self.headerLabel.text = NSLOCALIZEDSTRING(@"SELCET_YOUR_INTERPRETATION_LANGUAGE");
    self.fromLabel.text = NSLOCALIZEDSTRING(@"FROM");
    self.toLabel.text = NSLOCALIZEDSTRING(@"TO");
    [self.confirmButton setTitle:NSLOCALIZEDSTRING(@"CONFIRM_CAPITAL") forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLOCALIZEDSTRING(@"CANCEL_CAPITAL") forState:UIControlStateNormal];
    
}

-(void)setRoundCorners {
    
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
        NSString *alertString;
        if ([self.fromDetailLabel.text isEqualToString:NSLOCALIZEDSTRING(@"LANGUAGE")]) {
            alertString = [NSString messageWithSelectString:NSLOCALIZEDSTRING(@"FROM_LANGUAGE")];
        }
        else if ([self.toDetailLabel.text isEqualToString:NSLOCALIZEDSTRING(@"LANGUAGE")]) {
            alertString = [NSString messageWithSelectString:NSLOCALIZEDSTRING(@"TO_LANGUAGE")];
        }
        else if ([self.fromDetailLabel.text isEqualToString:self.toDetailLabel.text]) {
            alertString = NSLOCALIZEDSTRING(@"PLEASE_SELECT_2_LANGUAGES_DIFFERENT");
        }
        if (alertString.length>1) {
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:alertString
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
            return;
        }
        
        
        NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        NSMutableString *randomString = [NSMutableString stringWithCapacity:8];
        
        for (int i = 0; i < 8; i++) {
            [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
            App_Delegate.conferenceIDString=randomString;
        }
        
        
        [self autorize];
        
        [self getPoolOfInterpreters];
        
    }
    else{
        UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[Utility_Shared_Instance getControllerForIdentifier:DASHBOARD_USER_VIEW_CONTROLLER]];
        self.revealController = [PKRevealController revealControllerWithFrontViewController:contentNavigationController leftViewController:[Utility_Shared_Instance getControllerForIdentifier:SLIDE_MENU_VIEW_CONTROLLER]];
        App_Delegate.window.rootViewController = self.revealController;
    }
}

- (void)ooVooLogin {
    
    self.sdk = [ooVooClient sharedInstance];
    [self.sdk.Account login:[Utility_Shared_Instance readStringUserPreference:KUID_W]
                 completion:^(SdkResult *result) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [SVProgressHUD dismiss];
                     });
                     if (result.Result == 37) {
                         NSLog(@"377777777--> Failure Either Authorization  or ooVoo Server DOWN");
                     }
                     else if (result.Result == 0) {
                         NSLog(@"0 --> SUCCESS");
                     }
                     NSLog(@"result code=%d result description %@", result.Result, result.description);
                     if (result.Result != sdk_error_OK){
                         [[[UIAlertView alloc] initWithTitle:@"ooVoo Server Error" message:result.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                     }
                     else
                     {
                         [self onLogin:result.Result];
                         if(![self.sdk.Messaging isConnected])
                             [self.sdk.Messaging connect];
                     }
                 }];
}

- (void)onLogin:(BOOL)error {
    
    if (!error) {
        [ActiveUserManager activeUser].userId =[Utility_Shared_Instance readStringUserPreference:KUID_W];
        
        [UserDefaults setObject:[ActiveUserManager activeUser].token ForKey:[ActiveUserManager activeUser].userId];
        
        [ActiveUserManager activeUser].displayName = [Utility_Shared_Instance readStringUserPreference:KUID_W];
        NSString * token = [ActiveUserManager activeUser].token;
        if(token && token.length > 0){
            [self.sdk.PushService subscribe:token deviceUid:[ActiveUserManager activeUser].userId completion:^(SdkResult *result){
                [ActiveUserManager activeUser].isSubscribed = true;
            }];
        }
    }
}

/*
 Retrieve the pool of members from data base whose status is "0". It means those interpreters are availale
*/
-(void)getPoolOfInterpreters
{
    App_Delegate.isConnected = NO;
    //WEB Service CODE
    [Utility_Shared_Instance showProgress];
    NSMutableDictionary *languagePriceDict=[NSMutableDictionary new];
    [languagePriceDict setValue:fromLanguageKeyString forKey:KFROM_LANGUAGE_W];
    [languagePriceDict setValue:toLanguageKeyString forKey:KTO_LANGUAGE_W];
    [Web_Service_Call serviceCallWithRequestType:languagePriceDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:GET_INTERPRETER_BY_LANGUAGE_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        
        NSDictionary *responseDict=responseObject;
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
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
                        iObj.idString = [json objectForKey:KID_W];
                        iObj.poolIdString = [responseDict objectForKey:KPOOL_ID_W];
                        [App_Delegate.interpreterListArray addObject:iObj];
                        [arrFriends addObject:[json objectForKey:KUID_W]];
                    }
                    NSLog(@"-->%@",App_Delegate.interpreterListArray);
                    [self sendMsgToFriends:@"Someone is calling you for interpretation."];
                }
                
                
                ooVooPushNotificationMessage * msg = [[ooVooPushNotificationMessage alloc] initMessageWithUsersArray:arrFriends message:@"Someone is calling you for interpretation." property:@"Im optional" timeToLeave:1000];
                
                [self.sdk.PushService sendPushMessage:msg completion:^(SdkResult *result){
                    if(result.Result == sdk_error_OK)
                    {
                        NSLog(@"Send succeeded");
                    }
                }];

                
                if (arrFriends.count) {
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
                }
            });
            
            
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

-(void)getLanguagePrice{
    //WEB Service CODE
    [Utility_Shared_Instance showProgress];
    NSMutableDictionary *languagePriceDict=[NSMutableDictionary new];
    [languagePriceDict setValue:fromLanguageKeyString forKey:KFROM_LANGUAGE_W];
    [languagePriceDict setValue:toLanguageKeyString forKey:KTO_LANGUAGE_W];
    [Web_Service_Call serviceCallWithRequestType:languagePriceDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:GET_LANGUAGE_PRICE_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            NSMutableArray *priceArray = [responseDict objectForKey:KDATA_W];
            if (priceArray.count) {
                
                NSMutableDictionary *priceDict = [priceArray lastObject];
                
                App_Delegate.cdrObject.fromLanguageIDString = fromLanguageKeyString;
                App_Delegate.cdrObject.toLanguageIDString = toLanguageKeyString;
                App_Delegate.cdrObject.fromLanguageString = self.fromDetailLabel.text;
                App_Delegate.cdrObject.toLanguageString = self.toDetailLabel.text;
                App_Delegate.cdrObject.toLanguageString = self.toDetailLabel.text;
                App_Delegate.cdrObject.costString = [priceDict objectForKey:KLANGUAGE_PRICE_W];
                
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
    
    if((![self.fromDetailLabel.text isEqualToString:NSLOCALIZEDSTRING(@"LANGUAGE")]) && (![self.toDetailLabel.text isEqualToString:NSLOCALIZEDSTRING(@"LANGUAGE")])){
        [self getLanguagePrice];
    }

    
}


-(void)getProfileInfo{
    
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
                NSArray *langArray = [userDict objectForKey:KMYLANGUAGES_W];
                if (langArray.count) {
                    fromLanguageKeyString = [langArray lastObject];
                    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"languageID like[c] %@",[langArray objectAtIndex:0]];
                    NSArray *sortedArray = [App_Delegate.languagesArray filteredArrayUsingPredicate:predicate];
                    if (sortedArray.count) {
                        LanguageObject *lObj = [sortedArray lastObject];
                        self.fromDetailLabel.text = lObj.languageName;
                        [self.fromImageView sd_setImageWithURL:[NSURL URLWithString:lObj.imagePathString]
                                              placeholderImage:[UIImage defaultPicImage]];
                    }
                }
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
    App_Delegate.callingUsers = arrFriends;
    __block index=0;
    
    {
        //  NSString *userName = arrFriends[i];
        
        //    NSLog(@"Calling friend %@",userName);
        // sending a message of calling BUT if something is wrong cancel the call alert
        
        NSLog(@"---subscribe-->%d",[ActiveUserManager activeUser].isSubscribed);
        
        
        [[MessageManager sharedMessage]messageOtherUsers:arrFriends WithMessageType:Calling WithConfID:App_Delegate.conferenceIDString Compelition:^(BOOL CallSuccess)
         {

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
    self.sdk = [ooVooClient sharedInstance];
    ooVooPushNotificationMessage * msg = [[ooVooPushNotificationMessage alloc] initMessageWithUsersArray:arrFriends message:message property:@"Im optional" timeToLeave:1000];
    
        [self.sdk.PushService sendPushMessage:msg completion:^(SdkResult *result){
        if(result.Result == sdk_error_OK)
        {
            NSLog(@"Send succeeded");
            
            
        }
        else{
            NSLog(@"---------------$$$$$$$$$$$$$$$  ERROR ***********************");
        }
        
    }];
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
    if (!App_Delegate.isConnected) {
        [App_Delegate saveDisconnectedCallDetailsinServer:nil isNoOnePicksCallorEndedByCustomer:YES];
    }
    else{
        
    }
    
    
    [[MessageManager sharedMessage]messageOtherUsers:arrFriends WithMessageType:Cancel WithConfID:App_Delegate.conferenceIDString Compelition:^(BOOL CallSuccess) {
        
    }];
    
    
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

-    (void)stopCallAndDismissView{
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
            [App_Delegate saveDisconnectedCallDetailsinServer:nil isNoOnePicksCallorEndedByCustomer:YES];
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


- (void)autorize {
    
    
    [Utility_Shared_Instance showProgress];
    NSString* token = @"MDAxMDAxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZUYVW%2BB1MwyBDpt22C0WvOeMPW7fH6mMOv8d%2FAPeFZ2QeCOguU288bRzsChrixFyZ%2BKzm9nrLmfOkZwyPrAO%2BDP8wgDiVtL%2F0w9mZQ78Az5Hk6imDbhYGNGRFMqo0H2virlVE4Q%2Bpf5S%2Fm50MO%2BMh";
    NSLog(@"Token -->Login--->%@",token);
    
    if (![self.sdk IsAuthorized]) {
        [self.sdk authorizeClient:token
                       completion:^(SdkResult *result) {
                           
                           sdk_error err = result.Result;
                           if (err == sdk_error_OK) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [SVProgressHUD dismiss];
                               });
                               
                               NSLog(@"good autorization");
                               sleep(0.5);
                               [self ooVooLogin];
                               //[_delegate AuthorizationDelegate_DidAuthorized];
                           }
                           else {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [SVProgressHUD dismiss];
                               });
                               NSLog(@"fail  autorization");
                               
                               if (err == sdk_error_InvalidToken) {
                                   double delayInSeconds = 0.75;
                                   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                   dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                       [SVProgressHUD dismiss];
                                       
                                   });
                                   
                               }
                               else if (err != sdk_error_InvalidToken)
                               {
                                   
                                   double delayInSeconds = 0.75;
                                   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                   dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                       [SVProgressHUD dismiss];
                                   });
                               }
                           }
                           
                       }];
    }
    else{
        [self ooVooLogin];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)finishStateSelection:(NSMutableArray *)selectedDataArray{
    
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
