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
    
    
    self.tblView.estimatedRowHeight = 80;
    self.tblView.rowHeight = UITableViewAutomaticDimension;
    /*
    [self.tblView setNeedsLayout];
    [self.tblView layoutIfNeeded];
    */

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Utility_Shared_Instance showProgress];
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
    self.profileObject = [ProfileInfoObject new];
    self.profileObject.emailString = @"kat@gmail.com";
    self.profileObject.passwordString = @"Admin@123";
    self.profileObject.nameString = @"KatC";
    self.profileObject.addressString = @"CA, Washington, USA";
    self.profileObject.phoneNumberString = @"07515398752";
    self.profileObject.descriptionString = @"It's all about the data about me";
    self.profileObject.bankAccountInfoString = @"It's Confidential";
    self.profileObject.myLanguagesString = @"Spanish, German";
    self.profileObject.certificatesString = @"German certified";
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
        
        static NSString *cellIdentifier = @"ProfileViewEditUpdateAnswerCell";
        ProfileViewEditUpdateAnswerCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell1 == nil) {
            NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil];
            cell1 = [cellArray objectAtIndex:0];
        }
        //cell1.answerLabel.text = @"START asdgahjsdgahjksdgahjsdgahjsdgahjsdgahjsdghjasdgahjsdgahjsdghjasgdhjasgdhjasgdhjagdhjasgdhjasgdhjas hghjdgahs Hi hsadjkhasjkdhajkdh ajksdajksdhajksdh jkh ajksdh ajksdh ajksdhajksdh kas END";
        cell1.contentView.backgroundColor = [UIColor backgroundColor];
        return cell1;
        
        ProfileViewEditUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewEditUpdateCell"];
        cell.descriptionTextView.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.editImageView.hidden = YES;
        cell.editButton.hidden = YES;
        cell.descriptionTextView.userInteractionEnabled = NO;
        
        ///////////// Styles
        [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///////////// Fonts
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
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"PASSWORD")]) {
            cell.descriptionTextField.secureTextEntry = YES;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.passwordString];
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"NAME")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.nameString];
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")]) {
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
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isPhoneNumberEdit) {
                cell.descriptionTextField.enabled = YES;
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.enabled = NO;
                //[cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.phoneNumberString];
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"DESCRIPTION")]) {
            cell.descriptionTextField.hidden = YES;
            cell.descriptionTextView.hidden = NO;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.descriptionString];
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"BANK_ACCOUNT_INFORMATION")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.bankAccountInfoString];
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"MY_LANGUAGES")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.myLanguagesString];
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CERTIFICATES")]) {
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

-(void)getProfileInfo{
    
    NSMutableDictionary *payLoadDict = [NSMutableDictionary new];
    [payLoadDict setObject:[Utility_Shared_Instance checkForNullString:[NSString stringWithFormat:@"%@%@",@"Bearer ",[Utility_Shared_Instance readStringUserPreference:USER_TOKEN]]] forKey:KAUTHORIZATION_W];
    //[payLoadDict setObject:@"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb3VudHJ5IjoiVVNBIiwiYWRkcmVzcyI6Ik5hZ3B1ciIsImVpbl90YXhJZCI6IjExMTExMTExMTEiLCJjaXR5IjoiTmFncHVyIiwiY3JlYXRlZCI6IjIwMTYtMDEtMDZUMTI6MDY6MjUuNzM0WiIsInJldmVyc2VfdGltZXN0YW1wIjoiMTQ1MjA4MTk4NTU4NCIsInR5cGUiOiJpbnRlcnByZXRlciIsInppcGNvZGUiOiI0NDEwMDIiLCJjcmVhdGVkQXQiOiIyMDE2LTAxLTA2VDEyOjA2OjI1Ljc1OVoiLCJ1aWQiOiJpbnRlcnByZXRlciMxNDUyMDgxOTg1NTg0IiwicGFzc3dvcmQiOiIkMmEkMDgkQ291aDUuZlF6NmNmSFA2bnkwNElidURoZUJ2bktBSE1jMC5SUjIyR0JmZWlLdnh5SzNtT0MiLCJpc19kZWxldGVkIjpmYWxzZSwibmFtZSI6eyJmaXJzdF9uYW1lIjoib2JhaWQiLCJsYXN0X25hbWUiOiJyYWhtYW4ifSwibmlja25hbWUiOiJzZGZnc2RmZyIsImludGVycHJldGVyX2F2YWlsYWJpbGl0eSI6ZmFsc2UsIm1vZGlmaWVkIjoiMjAxNi0wMS0wNlQxMjowMjoyMC4wMDBaIiwicGhvbmVfbnVtYmVyIjoiOTg3NjU0MzIxMSIsImlkIjoiaW50ZXJwcmV0ZXIjb2JhaWRycnJAeW9wbWFpbC5jb20jMTQ1MjA4MTk4NTU4NCIsInN0YXRlIjoiTlkiLCJlbWFpbCI6Im9iYWlkcnJyQHlvcG1haWwuY29tIiwic3RhdHVzIjp0cnVlLCJ1cGRhdGVkQXQiOiIyMDE2LTAxLTA4VDExOjA3OjI5Ljg1NloiLCJ1c2VybmFtZSI6Im9iYWlkcnJyIiwiaWF0IjoxNDUyMjUxMzI3LCJleH AiOjE0NTIzMzc3Mjd9.iUn2JhNPgYt3_PXu3vg5qOq1ZM0zRUg9ihQ4_qDbrjA" forKey:KTOKEN_W];
    
    NSURL *url = [NSURL URLWithString:@"http://172.10.55.110:3000/api/getAgentInfo"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:120.0f];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json; charset=UTF-8"  forHTTPHeaderField:@"Content-Type"];
    
    NSError *err = nil;
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:payLoadDict options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          [SVProgressHUD dismiss];
          NSError *errorNIl = nil;
          if (!error)
          {
              NSDictionary *dictResponse =[NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorNIl]];
              NSLog(@"dic-->%@",dictResponse.description);
          }
          else{
          }
      }] resume];
    
    
//    
//    [Web_Service_Call serviceCall:payLoadDict webServicename:@"http://172.10.55.110:3000/api/getAgentInfo" SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
//        
//        NSDictionary *responseDict=responseObject;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
//                                                withMessage:[responseDict objectForKey:KMESSAGE_W]
//                                                     inView:self
//                                                  withStyle:UIAlertControllerStyleAlert];
//        });
//        
//        if ([responseDict objectForKey:KCODE_W]){
//            if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
//            {
//                if ([responseDict objectForKey:KTOKEN_W]) {
//                    [Utility_Shared_Instance writeStringUserPreference:USER_TOKEN value:[responseDict objectForKey:KTOKEN_W]];
//                }
//            }
//        }
//        
//    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
//                                                withMessage:[responseObject objectForKey:KMESSAGE_W]
//                                                     inView:self
//                                                  withStyle:UIAlertControllerStyleAlert];
//        });
//    }];
}
@end
