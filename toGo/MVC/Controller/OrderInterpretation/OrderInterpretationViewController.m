//
//  OrderInterpretationViewController.m
//  toGo
//
//  Created by Babul Rao on 25/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "OrderInterpretationViewController.h"

@interface OrderInterpretationViewController (){
    UIButton *selectedButton;
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
        [self performSegueWithIdentifier:Segue_MenuConferenceVC sender:nil];
    }
    else{
        
    }
    
}

-(void)getLanguagePrice{
    //WEB Service CODE
    [Utility_Shared_Instance showProgress];
    NSMutableDictionary *languagePriceDict=[NSMutableDictionary new];
    [languagePriceDict setValue:self.fromDetailLabel.text forKey:KFROM_LANGUAGE_W];
    [languagePriceDict setValue:self.toDetailLabel.text forKey:KTO_LANGUAGE_W];
    [Web_Service_Call serviceCallWithRequestType:languagePriceDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:GET_LANGUAGE_PRICE_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            NSMutableArray *array = [responseDict objectForKey:KDATA_W];
            if (array.count) {
                NSMutableDictionary *dict = [array lastObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.descriptionLabel.text = [NSString stringWithFormat:@"%@ $%.2f %@",NSLOCALIZEDSTRING(@"INTERPRETATION_SERVICE_CHARGE"),[[Utility_Shared_Instance checkForNullString:[dict objectForKey:KLANGUAGE_PRICE_W]] floatValue],NSLOCALIZEDSTRING(@"PER_MIN")];
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
            self.fromDetailLabel.text = lObj.languageName;
            [self.fromImageView sd_setImageWithURL:[NSURL URLWithString:lObj.imagePathString]
                                     placeholderImage:[UIImage defaultPicImage]];
        }
    }
    else{
        self.toLanguageArray = selectedDataArray;
        if (selectedDataArray.count) {
            LanguageObject *lObj = [selectedDataArray lastObject];
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
                NSLog(@"--langArray -->%@",App_Delegate.languagesArray);
                NSArray *langArray = [[userDict objectForKey:KMYLANGUAGES_W] componentsSeparatedByString:@","];
                if (langArray.count) {
                    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"languageCode beginswith[c] %@",[langArray objectAtIndex:0]];
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
                        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"languageCode beginswith[c] %@",str];
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
