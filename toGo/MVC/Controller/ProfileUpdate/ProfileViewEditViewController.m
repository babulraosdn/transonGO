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

@interface ProfileViewEditViewController ()<UITableViewDataSource,UITableViewDelegate,MyLanguagesDelegate>{
    CGFloat descriptionHeight;
    UITableViewCell *addressDescriptionCell;
}
@property(nonatomic,strong) NSMutableArray *namesArray;
//@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong) ProfileInfoObject *profileObject;

@property(nonatomic,strong) NSMutableDictionary *selectedLanguagesDict;
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
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getProfileInfo];
    [_tblView setShowsHorizontalScrollIndicator:NO];
    [_tblView setShowsVerticalScrollIndicator:NO];
}

-(void)allocationsAndStaticText{
    self.profileObject = [ProfileInfoObject new];
    self.selectedLanguagesDict = [NSMutableDictionary new];
    if ([Utility_Shared_Instance readStringUserPreference:USER_TYPE]) {
        
    }
    self.namesArray = [[NSMutableArray alloc]initWithObjects:@"",
                       NSLOCALIZEDSTRING(@"NICK_NAME"),
                       NSLOCALIZEDSTRING(@"UID"),
                       NSLOCALIZEDSTRING(@"EMAIL"),
                       NSLOCALIZEDSTRING(@"ADDRESS"),
                       NSLOCALIZEDSTRING(@"COUNTRY"),
                       NSLOCALIZEDSTRING(@"STATE"),
                       NSLOCALIZEDSTRING(@"CITY"),
                       NSLOCALIZEDSTRING(@"POST_CODE"),
                       NSLOCALIZEDSTRING(@"PHONE_NUMBER"),
                       NSLOCALIZEDSTRING(@"EIN_TaxID"),
                       NSLOCALIZEDSTRING(@"MY_LANGUAGES"),NSLOCALIZEDSTRING(@"CERTIFICATES"), nil];
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
        cell.dropDownImageView.hidden = YES;
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
        [cell.languagesButton setBackgroundColor:[UIColor buttonBackgroundColor]];
        
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
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"NICK_NAME")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isNickNameEdit) {
                cell.descriptionTextField.enabled = YES;
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.enabled = NO;
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.nickNameString];
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
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"COUNTRY")]) {
            cell.languagesButton.hidden = NO;
            cell.dropDownImageView.hidden = NO;
            if ([Utility_Shared_Instance checkForNullString:self.profileObject.countryString].length) {
                [cell.languagesButton setTitle:self.profileObject.countryString forState:UIControlStateNormal];
            }
            else{
                [cell.languagesButton setTitle:NSLOCALIZEDSTRING(@"COUNTRY") forState:UIControlStateNormal];
            }
            
            [cell.languagesButton addTarget:self action:@selector(countryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"STATE")]) {
            cell.languagesButton.hidden = NO;
            cell.dropDownImageView.hidden = NO;
            if ([Utility_Shared_Instance checkForNullString:self.profileObject.stateString].length) {
                [cell.languagesButton setTitle:self.profileObject.stateString forState:UIControlStateNormal];
            }
            else{
                [cell.languagesButton setTitle:NSLOCALIZEDSTRING(@"STATE") forState:UIControlStateNormal];
            }
            
            [cell.languagesButton addTarget:self action:@selector(stateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CITY")]) {
            
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isCityEdit) {
                cell.descriptionTextField.enabled = YES;
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.enabled = NO;
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.cityString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"POST_CODE")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isPostalCodeEdit) {
                cell.descriptionTextField.enabled = YES;
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.enabled = NO;
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.postalCodeString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.eINtaxIDString];
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
        }
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"BANK_ACCOUNT_INFORMATION")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.bankAccountInfoString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"MY_LANGUAGES")]) {
            cell.languagesButton.hidden = NO;
            cell.dropDownImageView.hidden = NO;
            if ([self.selectedLanguagesDict allValues].count) {
                [cell.languagesButton setTitle:self.profileObject.myLanguagesString forState:UIControlStateNormal];
            }
            else{
                [cell.languagesButton setTitle:NSLOCALIZEDSTRING(@"MY_LANGUAGES") forState:UIControlStateNormal];
            }
            
            [cell.languagesButton addTarget:self action:@selector(languagesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CERTIFICATES")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.certificatesString];
        }
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
        //This Condition is only for Address Edit
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:4 inSection:0];
        UITableViewCell *cell = (UITableViewCell *)[self.tblView cellForRowAtIndexPath:indexpath];
        UITextView *txtView =  (UITextView *)[cell viewWithTag:TEXT_VIEW_TAG];
        self.profileObject.addressString = txtView.text;
        if(self.profileObject.isAddressEdit){
            self.profileObject.isAddressEdit = NO;
            [self.view endEditing:YES];
            [self saveProfileInfo];
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
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        if(self.profileObject.isAddressEdit){
            
            self.profileObject.isAddressEdit = NO;
            [self saveProfileInfo];
        }
        else{
            self.profileObject.isAddressEdit = YES;
        }
    }
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]) {
        self.profileObject.isCityEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.phoneNumberString = cell.descriptionTextField.text;
        if(self.profileObject.isPhoneNumberEdit){
            self.profileObject.isPhoneNumberEdit = NO;
            [self saveProfileInfo];
        }
        else{
            self.profileObject.isPhoneNumberEdit = YES;
        }
    }
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"CITY")]) {
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.cityString = cell.descriptionTextField.text;
        if(self.profileObject.isCityEdit){
            self.profileObject.isCityEdit = NO;
            [self saveProfileInfo];
        }
        else{
            self.profileObject.isCityEdit = YES;
        }
    }
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"NICK_NAME")]) {
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.nickNameString = cell.descriptionTextField.text;
        if(self.profileObject.isNickNameEdit){
            self.profileObject.isNickNameEdit = NO;
            [self saveProfileInfo];
        }
        else{
            self.profileObject.isNickNameEdit = YES;
        }
    }
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"POSTAL_CODE")]) {
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.postalCodeString = cell.descriptionTextField.text;
        if(self.profileObject.isPostalCodeEdit){
            self.profileObject.isPostalCodeEdit = NO;
            [self saveProfileInfo];
        }
        else{
            self.profileObject.isPostalCodeEdit = YES;
        }
    }
    [self.tblView reloadData];
    
}

-(void)getProfileInfo
{
    [Utility_Shared_Instance showProgress];
    //WEB Service CODE
    [Web_Service_Call serviceCallWithRequestType:nil requestType:GET_REQUEST includeHeader:YES includeBody:NO webServicename:PROFILE_INFO_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
                NSMutableDictionary *userDict = [responseDict objectForKey:@"user"];
                self.profileObject = [ProfileInfoObject new];
                self.profileObject.idString = [userDict objectForKey:KID_W];
                [Utility_Shared_Instance writeStringUserPreference:KID_W value:[userDict objectForKey:KID_W]];
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
        
    }];
    
}

-(void)languagesButtonPressed{
    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.delegate = self;
    languagesView.selectedLanguagesDict = self.selectedLanguagesDict;
    [languagesView.tblView reloadData];
    [self.view addSubview:languagesView];
}

-(void)countryButtonPressed{
    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.delegate = self;
    languagesView.isCountry = YES;
    languagesView.selectedCountriesStatesArray  = [NSMutableArray new];
    languagesView.countriesStatesArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    [languagesView.tblView reloadData];
    [self.view addSubview:languagesView];
}

-(void)stateButtonPressed{
    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.delegate = self;
    languagesView.isState = YES;
    languagesView.selectedCountriesStatesArray  = [NSMutableArray new];
    languagesView.countriesStatesArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    [languagesView.tblView reloadData];
    [self.view addSubview:languagesView];
}


-(void)finishLanguagesSelection:(NSMutableDictionary *)selectedLanguagesDict{
    NSLog(@"selectedlanguages -->%@",[selectedLanguagesDict description]);
    self.selectedLanguagesDict = selectedLanguagesDict;
    self.profileObject.myLanguagesString = [[self.selectedLanguagesDict allValues] componentsJoinedByString:@","];
    [self.tblView reloadData];
}

-(void)finishCountrySelection:(NSMutableArray *)selectedDataArray{
    NSLog(@"selectedDataArray -->%@",[selectedDataArray description]);
    self.profileObject.countryString = [selectedDataArray componentsJoinedByString:@","];
    [self.tblView reloadData];
}

-(void)finishStateSelection:(NSMutableArray *)selectedDataArray{
    NSLog(@"selectedDataArray -->%@",[selectedDataArray description]);
    self.profileObject.stateString = [selectedDataArray componentsJoinedByString:@","];
    [self.tblView reloadData];
}

-(void)saveProfileInfo{
    [Utility_Shared_Instance showProgress];
    //WEB Service CODE
    NSMutableDictionary *saveDict=[NSMutableDictionary new];
    [saveDict setValue:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KID_W];
    [saveDict setValue:self.profileObject.emailString forKey:KEMAIL_W];
    [saveDict setValue:self.profileObject.nameString forKey:KNAME_W];
    [saveDict setValue:self.profileObject.nickNameString forKey:KNICKNAME_W];
    [saveDict setValue:self.profileObject.phoneNumberString forKey:KPHONE_NUMBER_W];
    [saveDict setValue:self.profileObject.myLanguagesString forKey:KMYLANGUAGE_W];
    [saveDict setValue:self.profileObject.addressString forKey:KADDRESS_W];
    [saveDict setValue:self.profileObject.countryString forKey:KCOUNTRY_W];
    [saveDict setValue:self.profileObject.stateString forKey:KSTATE_W];
    [saveDict setValue:self.profileObject.cityString forKey:KCITY_W];
    [saveDict setValue:self.profileObject.postalCodeString forKey:KPOSTALCODE_W];
    [saveDict setValue:self.profileObject.eINtaxIDString forKey:KEIN_TAXID_W];
    
    [Web_Service_Call serviceCallWithRequestType:saveDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:UPDATE_PROFILE_INFO_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        
    }];
}
@end
