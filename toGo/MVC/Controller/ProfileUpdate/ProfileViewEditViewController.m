//
//  ProfileViewEditViewController.m
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "ProfileViewEditViewController.h"
	#import "ProfileImageTableViewCell.h"
#import "Headers.h"

#define HEADER_HEIGHT 140

@implementation ProfileViewEditUpdateCell
@end
@implementation ProfileViewEditUpdateAnswerCell
@end

@interface ProfileViewEditViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *namesArray;
//@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong) ProfileInfoObject *profileObject;
@end

@implementation ProfileViewEditViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tblView.backgroundColor = [UIColor backgroundColor];
    
    [self allocationsAndStaticText];
    
    if(self.isFromDashBoard)
        [self setCustomBackButtonForNavigation];
    else
        [self setSlideMenuButtonFornavigation];
    
    [self setLogoutButtonForNavigation];
    
    self.tblView.estimatedRowHeight = 80;
    self.tblView.rowHeight = UITableViewAutomaticDimension;
    
    
    /*
    [self.tblView setNeedsLayout];
    [self.tblView layoutIfNeeded];
    */

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[Utility_Shared_Instance showProgress];
    [self getProfileInfo];
}

-(void)allocationsAndStaticText{
    self.namesArray = [[NSMutableArray alloc]initWithObjects:@"",
                       NSLOCALIZEDSTRING(@"EMAIL"),
                       NSLOCALIZEDSTRING(@"PASSWORD"),
                       NSLOCALIZEDSTRING(@"NAME"),
                       NSLOCALIZEDSTRING(@"ADDRESS"),
                       NSLOCALIZEDSTRING(@"PHONE_NUMBER"),
                       NSLOCALIZEDSTRING(@"DESCRIPTION"),
                       NSLOCALIZEDSTRING(@"BANK_ACCOUNT_INFORMATION"),
                       NSLOCALIZEDSTRING(@"MY_LANGUAGES"),NSLOCALIZEDSTRING(@"CERTIFICATES"), nil];
    //self.dataArray = [[NSMutableArray alloc]initWithObjects:@"",@"kat@gmail.com",@"Admin@123",@"KatC",@"CA, Washington, USA dgf gdfgdf gdf dgdfg d7777",@"07515398752",@"dsasdgdfgdfgdgdfgdfgdfgdfggdfgdgdfgdfgdfg 7777",@"It's Confidential",@"Spanish, German",@"German certified", nil];
    /*
    self.profileObject = [ProfileInfoObject new];
    self.profileObject.emailString = @"kat@gmail.com";
    self.profileObject.passwordString = @"Admin@123";
    self.profileObject.nameString = @"KatC";
    self.profileObject.addressString = @"CA, USA";
    self.profileObject.phoneNumberString = @"07515398752";
    self.profileObject.descriptionString = @"Description is __________";
    self.profileObject.bankAccountInfoString = @"10598752469";
    self.profileObject.myLanguagesString = @"Spanish, German";
    self.profileObject.certificatesString = @"German certified";
    */
}

-(UIView*)createProfileImageView{
    
    int imageViewWidth = 120;
    int imageViewHeight = 120;
    UIView *profileView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)];
    UIImageView *backGroundCircleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-(imageViewWidth/2), 20, imageViewWidth, imageViewHeight)];
    UIImageView *innerCircleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-(imageViewWidth/2)+5, 25, imageViewWidth-10, imageViewHeight-10)];
    
    backGroundCircleImageView.backgroundColor = [UIColor lightGrayColor];
   
    innerCircleImageView.image = [UIImage defaultPicImage];
    [profileView addSubview:backGroundCircleImageView];
    [profileView addSubview:innerCircleImageView];
    return profileView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.namesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //return UITableViewAutomaticDimension;
    if (indexPath.row==0) {
        return HEADER_HEIGHT;
    }
    else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Description"]) {
        //return 100;
        return UITableViewAutomaticDimension;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return HEADER_HEIGHT;
    }
    else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Description"]) {
        return 80;;
    }
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"ProfileImageTableViewCell";
        ProfileImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [cellArray objectAtIndex:0];
        }
        cell.contentView.backgroundColor = [UIColor backgroundColor];
        return cell;
    }
    else{

        
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Description"]) {
            
            NSString *cellIdentifier = @"ProfileViewEditUpdateAnswerCell";
            ProfileViewEditUpdateAnswerCell *addressDescriptionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")]) {
                addressDescriptionCell.answerLabel.text = self.profileObject.addressString;
            }
            if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"DESCRIPTION")]) {
                addressDescriptionCell.answerLabel.text = self.profileObject.descriptionString;
            }
            
            //@"START asdgaajkgghffsfsdjghjProfileViewEditUpdateCell  ProfileViewEditUpdateCell  ProfileViewEditUpdateCell                             ghjghjghjghjghjghjghjhj ghjghj  middle sdhajksdh kas ProfileViewEditUpdateCell END";
            
            ///////////// Fonts
            addressDescriptionCell.headerLabel.font = [UIFont normal];
            addressDescriptionCell.answerLabel.font = [UIFont smallBig];
            
            ///////////// Text/background Color
            addressDescriptionCell.answerLabel.textColor = [UIColor textColorLightBrownColor];
            addressDescriptionCell.contentView.backgroundColor = [UIColor backgroundColor];
            ///////////// Text/Data/Button Actions Assigning
            addressDescriptionCell.headerLabel.text = [self.namesArray objectAtIndex:indexPath.row];
            
            return addressDescriptionCell;
        }
        ProfileViewEditUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewEditUpdateCell"];
        cell.descriptionTextView.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.editImageView.hidden = YES;
        cell.editButton.hidden = YES;
        cell.descriptionTextView.userInteractionEnabled = NO;
        cell.descriptionTextField.secureTextEntry = NO;
        ///////////// Styles
        [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///////////// Fonts
        cell.headerLabel.font = [UIFont normal];
        cell.descriptionTextField.font = [UIFont smallBig];
        cell.descriptionTextView.font = [UIFont smallBig];
        
        ///////////// Text/background Color
        cell.descriptionTextField.textColor = [UIColor textColorLightBrownColor];
        cell.descriptionTextView.textColor = [UIColor textColorLightBrownColor];
        cell.contentView.backgroundColor = [UIColor backgroundColor];
        
        ///////////// Text/Data/Button Actions Assigning
        //cell.descriptionTextField.text = [self.dataArray objectAtIndex:indexPath.row];
        //cell.descriptionTextView.text = [self.dataArray objectAtIndex:indexPath.row];
        //cell.descriptionLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        cell.headerLabel.text = [self.namesArray objectAtIndex:indexPath.row];
        [cell.editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        /////////
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EMAIL")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.emailString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"PASSWORD")]) {
            cell.descriptionTextField.secureTextEntry = YES;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.passwordString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"NAME")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.nameString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")]) {
            cell.descriptionTextField.hidden = YES;
            cell.descriptionTextView.hidden = NO;
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isAddressEdit) {
                cell.descriptionTextView.userInteractionEnabled = YES;
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                //[cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.addressString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isPhoneNumberEdit) {
                cell.descriptionTextField.enabled = YES;
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.enabled = NO;
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.phoneNumberString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"DESCRIPTION")]) {
            cell.descriptionTextField.hidden = YES;
            cell.descriptionTextView.hidden = NO;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.descriptionString];
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"BANK_ACCOUNT_INFORMATION")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.bankAccountInfoString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"MY_LANGUAGES")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.myLanguagesString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CERTIFICATES")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.certificatesString];
        }
        ////////

        
        return cell;
    }
    return nil;
}

-(void)editButtonPressed:(UIButton *)sender{
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ProfileViewEditUpdateCell *cell = [self.tblView cellForRowAtIndexPath:indexpath];
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")]) {
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.addressString = cell.descriptionTextView.text;
        if(self.profileObject.addressString){
            
            self.profileObject.isAddressEdit = NO;
        }
        else{
            self.profileObject.isAddressEdit = YES;
        }
    }
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]) {
        self.profileObject.isAddressEdit = NO;
        self.profileObject.phoneNumberString = cell.descriptionTextField.text;
        if(self.profileObject.isPhoneNumberEdit){
            self.profileObject.isPhoneNumberEdit = NO;
        }
        else{
            self.profileObject.isPhoneNumberEdit = YES;
        }
    }
    [self.tblView reloadData];
}

-(void)getProfileInfo
{
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLOCALIZEDSTRING(@"PLEASE_WAIT")]];
    //WEB Service CODE
    [Web_Service_Call getProfileInfoServiceCall:[Utility_Shared_Instance checkForNullString:[NSString stringWithFormat:@"%@%@",@"Bearer ",[Utility_Shared_Instance readStringUserPreference:USER_TOKEN]]] webServicename:PROFILE_INFO_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
                NSMutableDictionary *userDict = [responseDict objectForKey:@"user"];
                self.profileObject = [ProfileInfoObject new];
                self.profileObject.emailString = [userDict objectForKey:KEMAIL_W];
                self.profileObject.passwordString = [userDict objectForKey:KPASSWORD_W];
                self.profileObject.nameString = [userDict objectForKey:KNICKNAME_W];
                self.profileObject.addressString = [userDict objectForKey:KADDRESS_W];
                self.profileObject.phoneNumberString = [userDict objectForKey:KPHONE_NUMBER_W];
                self.profileObject.myLanguagesString = [userDict objectForKey:KMYLANGUAGES_W];
                [self.tblView reloadData];
                
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                
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
/*
{
 
 
 
 
    NSURL *url = [NSURL URLWithString:@"http://172.10.55.110:3000/api/getAgentInfo"];
    //NSURL *url = [NSURL URLWithString:@"http://54.153.22.179:3000/api/getAgentInfo"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    [request addValue:[Utility_Shared_Instance checkForNullString:[NSString stringWithFormat:@"%@%@",@"Bearer ",[Utility_Shared_Instance readStringUserPreference:USER_TOKEN]]] forHTTPHeaderField:KAUTHORIZATION_W];
    [request addValue:@"application/json; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          [SVProgressHUD dismiss];
          
          if (!error)
          {
              NSError *errorNIl = nil;
              NSDictionary *dictResponse =[NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorNIl]];
              NSLog(@"dic-->%@",dictResponse.description);
          }
          else{
          }
      }] resume];
}
*/
@end
