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

#define HEADER_HEIGHT 157

#define IMAGE_VIEW_TAG  666
#define EDIT_BUTTON_TAG 777
#define LABEL_TAG       888
#define TEXT_VIEW_TAG   999



@implementation ProfileViewEditUpdateCell
@end
@implementation ProfileViewEditUpdateAnswerCell
@end

@interface ProfileViewEditViewController ()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat descriptionHeight;
    UITableViewCell *addressDescriptionCell;
}
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
    
    //[self registerForKeyboardNotifications];
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardWasShown:(NSNotification*)notification
{
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.view.frame.origin.x,self.view.frame.origin.y, kbSize.height+100, 0);
    self.tblView.contentInset = contentInsets;
    self.tblView.scrollIndicatorInsets = contentInsets;
    self.tblView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tblView.contentInset = contentInsets;
    self.tblView.scrollIndicatorInsets = contentInsets;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[Utility_Shared_Instance showProgress];
    //[self getProfileInfo];
}

-(void)allocationsAndStaticText{
    self.profileObject = [ProfileInfoObject new];
    self.namesArray = [[NSMutableArray alloc]initWithObjects:@"",
                       NSLOCALIZEDSTRING(@"EMAIL"),
                       NSLOCALIZEDSTRING(@"PASSWORD"),
                       NSLOCALIZEDSTRING(@"NAME"),
                       NSLOCALIZEDSTRING(@"NICK_NAME"),
                       NSLOCALIZEDSTRING(@"ADDRESS"),
                       NSLOCALIZEDSTRING(@"PHONE_NUMBER"),
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
        //return UITableViewAutomaticDimension;
        return [self heightOfTextViewWithString:@"START  END" withFont:[UIFont normal] andFixedWidth:280]+40;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return HEADER_HEIGHT;
    }
    else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Description"]) {
        //return 100;
        //return UITableViewAutomaticDimension;
        return [self heightOfTextViewWithString:@"START  END" withFont:[UIFont normal] andFixedWidth:280];
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
        cell.nameLabel.text = self.profileObject.nameString;
        cell.contentView.backgroundColor = [UIColor backgroundColor];
        return cell;
    }
    else{
        
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Description"]) {
            
            addressDescriptionCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
            
            ///////////// Text/Data/Button Actions Assigning
            if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")]) {
                //addressDescriptionCell.answerLabel.text = self.profileObject.addressString;
            }
            if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"DESCRIPTION")]) {
            }
            
            if ([addressDescriptionCell viewWithTag:IMAGE_VIEW_TAG]) {
                [[addressDescriptionCell viewWithTag:IMAGE_VIEW_TAG] removeFromSuperview];
            }
            if ([addressDescriptionCell viewWithTag:EDIT_BUTTON_TAG]) {
                [[addressDescriptionCell viewWithTag:EDIT_BUTTON_TAG] removeFromSuperview];
            }
            if ([addressDescriptionCell viewWithTag:LABEL_TAG]) {
                [[addressDescriptionCell viewWithTag:LABEL_TAG] removeFromSuperview];
            }
            if ([addressDescriptionCell viewWithTag:TEXT_VIEW_TAG]) {
                [[addressDescriptionCell viewWithTag:TEXT_VIEW_TAG] removeFromSuperview];
            }
            
            UIImageView *imgViewEdit = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 15, 12, 12)];
            imgViewEdit.tag = IMAGE_VIEW_TAG;
            //imgViewEdit.backgroundColor = [UIColor redColor];
            imgViewEdit.image = [UIImage editImage];
            [addressDescriptionCell.contentView addSubview:imgViewEdit];
            
            UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 40, 40)];
            editBtn.tag = EDIT_BUTTON_TAG;
            //editBtn.backgroundColor = [UIColor blackColor];
            [editBtn addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [addressDescriptionCell.contentView addSubview:editBtn];

            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-60, 20)];
            label.text = [self.namesArray objectAtIndex:indexPath.row];
            label.tag = LABEL_TAG;
            //label.backgroundColor = [UIColor redColor];
            [addressDescriptionCell.contentView addSubview:label];
            
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 25, self.view.frame.size.width-20, descriptionHeight)];
            textView.text = @"START  END";
            textView.tag = TEXT_VIEW_TAG;
            textView.text = self.profileObject.addressString;
            [addressDescriptionCell.contentView addSubview:textView];
            
            if (self.profileObject.isAddressEdit) {
                textView.userInteractionEnabled = YES;
                textView.backgroundColor = [UIColor whiteColor];
                [textView becomeFirstResponder];
            }
            else{
                textView.userInteractionEnabled = NO;
                textView.backgroundColor = [UIColor clearColor];
            }
            addressDescriptionCell.contentView.backgroundColor = [UIColor backgroundColor];
            return addressDescriptionCell;
        }
        
        ProfileViewEditUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewEditUpdateCell"];
        cell.descriptionTextView.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.editImageView.hidden = YES;
        cell.editButton.hidden = YES;
        cell.languagesButton.hidden = YES;
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
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];
                [cell.descriptionTextField becomeFirstResponder];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
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
            //cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.descriptionString];
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"BANK_ACCOUNT_INFORMATION")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.bankAccountInfoString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"MY_LANGUAGES")]) {
            //cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.myLanguagesString];
            cell.languagesButton.hidden = NO;
            [cell.languagesButton addTarget:self action:@selector(languagesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CERTIFICATES")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.certificatesString];
        }
        ////////
        return cell;
    }
    return nil;
}

- (CGFloat)heightOfTextViewWithString:(NSString *)string
                             withFont:(UIFont *)font
                        andFixedWidth:(CGFloat)fixedWidth
{
    UITextView *tempTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, fixedWidth, 1)];
    tempTV.text = [string uppercaseString];
    tempTV.font = font;
    
    CGSize newSize = [tempTV sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = tempTV.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    tempTV.frame = newFrame;
    
    descriptionHeight = tempTV.frame.size.height;;
    
    return tempTV.frame.size.height;
}

-(void)editButtonPressed:(UIButton *)sender{
    
    if (sender.tag == EDIT_BUTTON_TAG) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:4 inSection:0];
        UITableViewCell *cell = (UITableViewCell *)[self.tblView cellForRowAtIndexPath:indexpath];
        UITextView *txtView =  (UITextView *)[cell viewWithTag:TEXT_VIEW_TAG];
        self.profileObject.addressString = txtView.text;
        if(self.profileObject.isAddressEdit){
            self.profileObject.isAddressEdit = NO;
            [self.view endEditing:YES];
        }
        else{
            self.profileObject.isAddressEdit = YES;
        }
        [self.tblView reloadData];
        return;
    }
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ProfileViewEditUpdateCell *cell = [self.tblView cellForRowAtIndexPath:indexpath];
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")]) {
        self.profileObject.isPhoneNumberEdit = NO;
        if(self.profileObject.isAddressEdit){
            
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

-(void)languagesButtonPressed{
   // MyLanguagesView *languagesView = [MyLanguagesView new];
   // [self.view addSubview:[languagesView myLanguagesView:nil viewIs:self.view]];
    
    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:languagesView];
    

}


@end
