//
//  CallHistoryViewController.m
//  toGO
//
//  Created by Babul Rao on 11/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "CallHistoryViewController.h"

@interface CallHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property(nonatomic,strong) NSMutableArray *cdrArray;
@property(nonatomic,weak) IBOutlet UITableView *tblView;
@end

@implementation CallHistoryCell
@end


@implementation CallHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    
    self.tblView.backgroundColor = [UIColor backgroundColor];//This is table view back goring color
    
    [self setFonts];
    
    [self getCallDetailsHistory];
}

-(void)setFonts{
    self.headerLabel.text = NSLOCALIZEDSTRING(@"CALL_HISTORY");
    self.headerLabel.font = [UIFont normalSize];
}

#pragma Mark TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cdrArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CallHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallHistoryCell"];
    cell.titleLabel.font = [UIFont normalSize];
    cell.descriptionLabel.font = [UIFont smallBig];
    cell.titleLabel.textColor = [UIColor textColorBlackColor];
    cell.descriptionLabel.textColor = [UIColor grayColor];
    
    CDRObject *cObj = [self.cdrArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = cObj.nickNameString;
    [cell.displayImageView sd_setImageWithURL:[NSURL URLWithString:cObj.imageURLString]
               placeholderImage:[UIImage defaultPicImage]];
    cell.displayImageView.layer.cornerRadius = cell.displayImageView.frame.size.height /2;
    cell.displayImageView.layer.masksToBounds = YES;
    cell.durationLabel.text = cObj.durationString;
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ > %@",cObj.fromLanguageString,cObj.toLanguageString];
    cell.heartButton.tag = indexPath.row;
    cell.favouriteButton.tag = indexPath.row;
    [cell.favouriteButton addTarget:self action:@selector(favouriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)getCallDetailsHistory{
    
    [Utility_Shared_Instance showProgress];
    NSMutableDictionary *cdrDict = [NSMutableDictionary new];
    [cdrDict setObject:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KID_W];
    [cdrDict setObject:[Utility_Shared_Instance readStringUserPreference:USER_TYPE] forKey:KTYPE_W];
    
    [Web_Service_Call serviceCallWithRequestType:cdrDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:GET_CDR_HISTORY_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cdrArray = [NSMutableArray new];
                if ([responseDict objectForKey:KCDR_DATA_W]) {
                    if ([[responseDict objectForKey:KCDR_DATA_W] isKindOfClass:[NSArray class]]) {
                        for (id cdrJson in [responseDict objectForKey:KCDR_DATA_W]) {
                            CDRObject *cObj = [CDRObject new];
                            
                            if ([[Utility_Shared_Instance readStringUserPreference:USER_TYPE] isEqualToString:INTERPRETER]) {
                                //Interpreter
                                NSDictionary *callFromDict =  [cdrJson objectForKey:KCALL_FROM_W];
                                if ([callFromDict isKindOfClass:[NSDictionary class]]) {
                                    NSDictionary *profileImgDict =  [callFromDict objectForKey:KPROFILE_IMAGE_W];
                                    cObj.imageURLString = [profileImgDict objectForKey:KURL_W];
                                    
                                    cObj.nickNameString = [callFromDict objectForKey:KNICKNAME_W];
                                }
                            }
                            else{
                                //USER
                                NSDictionary *callToDict =  [cdrJson objectForKey:KCALL_TO_W];
                                if ([callToDict isKindOfClass:[NSDictionary class]]) {
                                    NSDictionary *profileImgDict =  [callToDict objectForKey:KPROFILE_IMAGE_W];
                                    cObj.imageURLString = [profileImgDict objectForKey:KURL_W];
                                    cObj.nickNameString = [callToDict objectForKey:KNICKNAME_W];
                                }
                            }
                            
                            
                            
                            
                            if ([Utility_Shared_Instance checkForNullString:[cdrJson objectForKey:KDURATION_W]].length) {
                                int minutes = [[cdrJson objectForKey:KDURATION_W] intValue] / 60;
                                
                                int seconds = [[cdrJson objectForKey:KDURATION_W] intValue] % 60;
                                if (seconds>0) {
                                    minutes = minutes +1;
                                    cObj.durationString = [NSString stringWithFormat:@"%d min",minutes];
                                }
                                
                            }
                            
                            
                            NSDictionary *fromLangDict =  [cdrJson objectForKey:KFROM_LANGUAGE_small_L_Leter_W];
                            cObj.fromLanguageString = [fromLangDict objectForKey:KLANGUAGE_W];
                            
                            NSDictionary *toLangDict =  [cdrJson objectForKey:KTO_LANGUAGE_small_L_Leter_W];
                            cObj.toLanguageString = [toLangDict objectForKey:KLANGUAGE_W];
                            
                            [self.cdrArray addObject:cObj];
                        }
                    }
                    
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                            withMessage:[responseDict objectForKey:KCDR_DATA_W]
                                                                 inView:self
                                                              withStyle:UIAlertControllerStyleAlert];
                    });
                }
                [self.tblView reloadData];
                [SVProgressHUD dismiss];
                
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
            [AlertViewCustom showAlertViewWithMessage:[responseObject objectForKey:KMESSAGE_W] headingLabel:NSLOCALIZEDSTRING(APPLICATION_NAME) confirmButtonName:NSLOCALIZEDSTRING(@"") cancelButtonName:NSLOCALIZEDSTRING(@"OK") viewIs:self];
        });
    }];
}

-(void)favouriteButtonPressed : (id) sender{
    
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
