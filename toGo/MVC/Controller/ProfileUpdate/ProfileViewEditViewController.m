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

#define DESCRIPTION_BUTTON_TAG 555
#define IMAGE_VIEW_TAG  666
#define EDIT_BUTTON_TAG 777
#define LABEL_TAG       888
#define TEXT_VIEW_TAG   999



@implementation ProfileViewEditUpdateCell
@end
@implementation ProfileViewEditUpdateAnswerCell
@end

@interface ProfileViewEditViewController ()<UITableViewDataSource,UITableViewDelegate,MyLanguagesDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    CGFloat descriptionHeight;
    UITableViewCell *addressCell;
    UITableViewCell *descriptionCell;
    
    UIImage *selectedImage;
    BOOL isEditMode;
    NSString *editableString;
    
    NSInteger selectedCardTypeRow;
    NSInteger selectedGenderTypeRow;
}
@property(nonatomic,strong) NSMutableArray *namesArray;
//@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong) ProfileInfoObject *profileObject;

@property(nonatomic,strong) NSMutableDictionary *selectedLanguagesDict;
@property(nonatomic,strong)NSMutableArray *cardTypeArray;
@property(nonatomic,strong)NSMutableArray *genderArray;
@property(nonatomic,strong)UIView *backPickerview;
@end

@implementation ProfileViewEditViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _isInterpreter = [[Utility_Shared_Instance readStringUserPreference:USER_TYPE] isEqualToString:INTERPRETER];
    
    [_tblView setShowsHorizontalScrollIndicator:NO];
    [_tblView setShowsVerticalScrollIndicator:NO];
    
    isEditMode = false;
    editableString = @"";
    selectedCardTypeRow = 0;
    selectedGenderTypeRow = 0;
    
    self.cardTypeArray = [[NSMutableArray alloc]initWithObjects:@"Visa Debit Card",@"MasterCard Debit Card",@"Maestro Debit Card", nil];
    self.genderArray = [[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
    [self allocationsAndStaticText];
    
    if(self.isFromDashBoard)
        [self setCustomBackButtonForNavigation];
    else
        [self setSlideMenuButtonFornavigation];
    
    [self setLogoutButtonForNavigation];
    
    [Utility_Shared_Instance showProgress];
    [self performSelector:@selector(getProfileInfo) withObject:nil afterDelay:0.2];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tblView.backgroundColor = [UIColor backgroundColor];

    
}

-(void)allocationsAndStaticText{
    self.profileObject = [ProfileInfoObject new];
    self.selectedLanguagesDict = [NSMutableDictionary new];
    if (_isInterpreter) {
        self.namesArray = [[NSMutableArray alloc]initWithObjects:@"",
                           NSLOCALIZEDSTRING(@"EMAIL"),
                           NSLOCALIZEDSTRING(@"FIRST_NAME"),
                           NSLOCALIZEDSTRING(@"LAST_NAME"),
                           NSLOCALIZEDSTRING(@"NICK_NAME"),
                           NSLOCALIZEDSTRING(@"UID"),
                           NSLOCALIZEDSTRING(@"ADDRESS"),
                           NSLOCALIZEDSTRING(@"COUNTRY"),
                           NSLOCALIZEDSTRING(@"STATE"),
                           NSLOCALIZEDSTRING(@"CITY"),
                           NSLOCALIZEDSTRING(@"POSTAL_CODE"),
                           NSLOCALIZEDSTRING(@"PHONE_NUMBER"),
                           NSLOCALIZEDSTRING(@"EIN_TaxID"),
                           NSLOCALIZEDSTRING(@"MY_LANGUAGES"),
                           NSLOCALIZEDSTRING(@"CERTIFICATES"), nil];
    }
    else
    {
        self.namesArray = [[NSMutableArray alloc]initWithObjects:@"",
                           NSLOCALIZEDSTRING(@"FIRST_NAME"),
                           NSLOCALIZEDSTRING(@"LAST_NAME"),
                           NSLOCALIZEDSTRING(@"NICK_NAME"),
                           NSLOCALIZEDSTRING(@"UID"),
                           NSLOCALIZEDSTRING(@"DESCRIPTION"),
                           NSLOCALIZEDSTRING(@"EMAIL"),
                           NSLOCALIZEDSTRING(@"PHONE_NUMBER"),
                           NSLOCALIZEDSTRING(@"DOB"),
                           NSLOCALIZEDSTRING(@"GENDER"),
                           NSLOCALIZEDSTRING(@"ADDRESS"),
                           NSLOCALIZEDSTRING(@"COUNTRY"),
                           NSLOCALIZEDSTRING(@"STATE"),
                           NSLOCALIZEDSTRING(@"CITY"),
                           NSLOCALIZEDSTRING(@"POSTAL_CODE"),
                           NSLOCALIZEDSTRING(@"MY_LANGUAGES"),
                           NSLOCALIZEDSTRING(@"CARD_TYPE"),
                           NSLOCALIZEDSTRING(@"CARD_NUMBER"),
                           NSLOCALIZEDSTRING(@"EXPIRY_MONTH"),
                           NSLOCALIZEDSTRING(@"EXPIRY_YEAR"),
                           NSLOCALIZEDSTRING(@"CVV"),
                           //bank details
//                           "cardtype" : "visa",
//                           "cardnumber" : "4111111111111111",
//                           "expmonth" : "04",
//                           "expyear" : "2016",
//                           "cvv" : "587"
                            nil];
        /*
        "email": "rakeshp@ice-breakrr.com",
        "id" : "user#rakeshp@ice-breakrr.com#1452582382113",
        "name" : {
            "first_name" : "togo",
            "last_name" : "user"
        },
        "phone_number" : "9876543210",
        "mylanguage" : "['CS','NL']",
        "gender" : "male",
        "dob" : "1984-01-05",
        "payment_info" : {
            "cardtype" : "visa",
            "cardnumber" : "4111111111111111",
            "expmonth" : "04",
            "expyear" : "2016",
            "cvv" : "587"
        } */
    }
    
    
     
     
    
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
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"]){
            int defaultHeight = 0;
            if (self.profileObject.addressString.length<25) {
                defaultHeight = 40;
            }
            
            return [self heightOfTextViewWithString:self.profileObject.addressString withFont:[UIFont normal] andFixedWidth:280]+defaultHeight;
        }
        else{
            int defaultHeight = 0;
            if (self.profileObject.descriptionString.length<25) {
                defaultHeight = 40;
            }
            return [self heightOfTextViewWithString:self.profileObject.descriptionString withFont:[UIFont normal] andFixedWidth:280]+defaultHeight;
        }
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
        //return [self heightOfTextViewWithString:@"START  END" withFont:[UIFont normal] andFixedWidth:280];
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"])
            return [self heightOfTextViewWithString:self.profileObject.addressString withFont:[UIFont normal] andFixedWidth:280];
        else
            return [self heightOfTextViewWithString:self.profileObject.descriptionString withFont:[UIFont normal] andFixedWidth:280];
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
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height /2;
        cell.profileImageView.layer.masksToBounds = YES;
        if ([Utility_Shared_Instance checkForNullString:self.profileObject.imageURLString].length) {
            cell.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.profileObject.imageURLString]]];
        }
        if (selectedImage) {
            cell.profileImageView.image= selectedImage;
        }
        cell.nameLabel.text = self.profileObject.nameString;
        [cell.selectImageButton addTarget:self action:@selector(cameraGalleryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        cell.contentView.backgroundColor = [UIColor backgroundColor];
        return cell;
    }
    else{
        
        /////////////// Address Cell START///////
        {
            if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")]) {
                
                addressCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseADDRESS"];
                
                
                
                if ([addressCell viewWithTag:IMAGE_VIEW_TAG]) {
                    [[addressCell viewWithTag:IMAGE_VIEW_TAG] removeFromSuperview];
                }
                if ([addressCell viewWithTag:EDIT_BUTTON_TAG]) {
                    [[addressCell viewWithTag:EDIT_BUTTON_TAG] removeFromSuperview];
                }
                if ([addressCell viewWithTag:LABEL_TAG]) {
                    [[addressCell viewWithTag:LABEL_TAG] removeFromSuperview];
                }
                if ([addressCell viewWithTag:TEXT_VIEW_TAG]) {
                    [[addressCell viewWithTag:TEXT_VIEW_TAG] removeFromSuperview];
                }
                
                UIImageView *imgViewEdit = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 15, 12, 12)];
                imgViewEdit.tag = IMAGE_VIEW_TAG;
                //imgViewEdit.backgroundColor = [UIColor redColor];
                [addressCell.contentView addSubview:imgViewEdit];
                
                UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 40, 40)];
                ///////////// Text/Data/Button Actions Assigning
                    editBtn.tag = EDIT_BUTTON_TAG;
                
                
                //editBtn.backgroundColor = [UIColor blackColor];
                [editBtn addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [addressCell.contentView addSubview:editBtn];

                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-60, 20)];
                label.text = [self.namesArray objectAtIndex:indexPath.row];
                label.tag = LABEL_TAG;
                //label.backgroundColor = [UIColor redColor];
                [addressCell.contentView addSubview:label];
                
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 25, self.view.frame.size.width-20, [self heightOfTextViewWithString:self.profileObject.addressString withFont:[UIFont normal] andFixedWidth:280])];
                textView.tag = TEXT_VIEW_TAG;
                textView.text = self.profileObject.addressString;
                [addressCell.contentView addSubview:textView];
                
                if (self.profileObject.isAddressEdit) {
                    imgViewEdit.image = [UIImage CheckOrTickImage];
                    textView.userInteractionEnabled = YES;
                    textView.backgroundColor = [UIColor whiteColor];
                    [textView becomeFirstResponder];
                }
                else {
                    imgViewEdit.image = [UIImage editImage];
                    textView.userInteractionEnabled = NO;
                    textView.backgroundColor = [UIColor clearColor];
                }
                addressCell.contentView.backgroundColor = [UIColor backgroundColor];
                return addressCell;
            }
            /////////////// Address Cell END///////
        }
        
        /////////////// Description Cell START///////
        {
            if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"DESCRIPTION")]) {
                
                descriptionCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseDESCRIPTION"];
                
                
                if ([descriptionCell viewWithTag:IMAGE_VIEW_TAG]) {
                    [[descriptionCell viewWithTag:IMAGE_VIEW_TAG] removeFromSuperview];
                }
                if ([descriptionCell viewWithTag:DESCRIPTION_BUTTON_TAG]) {
                    [[descriptionCell viewWithTag:DESCRIPTION_BUTTON_TAG] removeFromSuperview];
                }
                if ([descriptionCell viewWithTag:LABEL_TAG]) {
                    [[descriptionCell viewWithTag:LABEL_TAG] removeFromSuperview];
                }
                if ([descriptionCell viewWithTag:TEXT_VIEW_TAG]) {
                    [[descriptionCell viewWithTag:TEXT_VIEW_TAG] removeFromSuperview];
                }
                
                UIImageView *imgViewEdit = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 15, 12, 12)];
                imgViewEdit.tag = IMAGE_VIEW_TAG;
                //imgViewEdit.backgroundColor = [UIColor redColor];
                [descriptionCell.contentView addSubview:imgViewEdit];
                
                UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 40, 40)];
                ///////////// Text/Data/Button Actions Assigning
                editBtn.tag = DESCRIPTION_BUTTON_TAG;
                
                //editBtn.backgroundColor = [UIColor blackColor];
                [editBtn addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [descriptionCell.contentView addSubview:editBtn];
                
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-60, 20)];
                label.text = [self.namesArray objectAtIndex:indexPath.row];
                label.tag = LABEL_TAG;
                //label.backgroundColor = [UIColor redColor];
                [descriptionCell.contentView addSubview:label];
                
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 25, self.view.frame.size.width-20, [self heightOfTextViewWithString:self.profileObject.descriptionString withFont:[UIFont normal] andFixedWidth:280])];
                textView.tag = TEXT_VIEW_TAG;
                textView.text = self.profileObject.descriptionString;
                [descriptionCell.contentView addSubview:textView];
                
                if (self.profileObject.isDescriptionEdit) {
                    imgViewEdit.image = [UIImage CheckOrTickImage];
                    textView.userInteractionEnabled = YES;
                    textView.backgroundColor = [UIColor whiteColor];
                    [textView becomeFirstResponder];
                }
                else {
                    imgViewEdit.image = [UIImage editImage];
                    textView.userInteractionEnabled = NO;
                    textView.backgroundColor = [UIColor clearColor];
                }
                descriptionCell.contentView.backgroundColor = [UIColor backgroundColor];
                return descriptionCell;
            }
            /////////////// Description Cell END///////
        }
        
        ProfileViewEditUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewEditUpdateCell"];
        cell.descriptionTextView.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.editImageView.hidden = YES;
        cell.editButton.hidden = YES;
        cell.languagesButton.hidden = YES;
        cell.descriptionTextField.userInteractionEnabled = NO;
        cell.descriptionTextField.secureTextEntry = NO;
        cell.dropDownImageView.hidden = YES;
        cell.mandatoryLabel.hidden = NO;
        cell.editImageView.image = [UIImage editImage];
        cell.descriptionTextField.backgroundColor = [UIColor clearColor];
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
//        [cell.languagesButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];

        /////////
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"UID")]) {
            cell.mandatoryLabel.hidden = YES;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.uIdString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EMAIL")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.emailString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"PASSWORD")]) {
            cell.descriptionTextField.secureTextEntry = YES;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.passwordString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"FIRST_NAME")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isFirstNameEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.firstNameString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"LAST_NAME")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isLastNameEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.lastNameString];
        }else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"NICK_NAME")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            if (self.profileObject.isNickNameEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                cell.descriptionTextField.userInteractionEnabled = NO;
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
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
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];
                [cell.descriptionTextField becomeFirstResponder];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
                
            }

            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.addressString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"GENDER")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.mandatoryLabel.hidden = YES;
            cell.editButton.tag = indexPath.row;
            
            cell.descriptionTextField.userInteractionEnabled = NO;
            cell.descriptionTextField.backgroundColor = [UIColor clearColor];
            [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            if (self.profileObject.isPostalCodeEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.genderString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"DOB")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.mandatoryLabel.hidden = YES;
            cell.editButton.tag = indexPath.row;
            
            cell.descriptionTextField.userInteractionEnabled = NO;
            cell.descriptionTextField.backgroundColor = [UIColor clearColor];
            [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            if (self.profileObject.isPostalCodeEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.dobString];
        }
        
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"COUNTRY")]) {
            cell.languagesButton.hidden = NO;
            cell.dropDownImageView.hidden = NO;
            cell.mandatoryLabel.hidden = YES;
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
            cell.mandatoryLabel.hidden = YES;
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
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];

                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.cityString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"POSTAL_CODE")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.mandatoryLabel.hidden = YES;
            cell.editButton.tag = indexPath.row;
            cell.descriptionTextField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
            if (self.profileObject.isPostalCodeEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];

                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.postalCodeString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.eINtaxIDString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]) {
            cell.descriptionTextField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            
            if (self.profileObject.isPhoneNumberEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];

                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
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
            [cell.languagesButton removeTarget:nil
                               action:NULL
                     forControlEvents:UIControlEventAllEvents];
            [cell.languagesButton addTarget:self action:@selector(languagesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.profileObject.myLanguagesString.length) {
                [cell.languagesButton setTitle:self.profileObject.myLanguagesString forState:UIControlStateNormal];
            }
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CARD_NUMBER")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            cell.descriptionTextField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
            if (self.profileObject.isCardNumberEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];
                
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.cardNumberString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CARD_TYPE")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.cardTypeString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CVV")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            cell.descriptionTextField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
            if (self.profileObject.isCVVEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.CVVString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EXPIRY_YEAR")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            cell.descriptionTextField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
            if (self.profileObject.isExpYearEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.expYearString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EXPIRY_MONTH")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            cell.descriptionTextField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
            if (self.profileObject.isExpMonthEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
                cell.descriptionTextField.userInteractionEnabled = YES;
                cell.descriptionTextField.backgroundColor = [UIColor whiteColor];

                [cell.descriptionTextField setBorderStyle:UITextBorderStyleRoundedRect];
            }
            else{
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.descriptionTextField.backgroundColor = [UIColor clearColor];
                [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.expMonthString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CERTIFICATES")]) {
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.certificatesString];
            if (![Utility_Shared_Instance checkForNullString:self.profileObject.certificatesString].length) {
                cell.descriptionTextField.text = NSLOCALIZEDSTRING(@"N/A");
            }
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
    
    NSLog(@"Tag is %ld",(long)sender.tag);

    
    if (sender.tag == EDIT_BUTTON_TAG) {
        //This Condition is only for Address Edit
        NSIndexPath *indexpath;
        
        if (_isInterpreter) {
            indexpath = [NSIndexPath indexPathForRow:6 inSection:0];
        }
        else{
            indexpath = [NSIndexPath indexPathForRow:10 inSection:0];
        }
        
        UITableViewCell *cell = (UITableViewCell *)[self.tblView cellForRowAtIndexPath:indexpath];
        UITextView *txtView =  (UITextView *)[cell viewWithTag:TEXT_VIEW_TAG];
        self.profileObject.addressString = txtView.text;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        if(self.profileObject.isAddressEdit){
            self.profileObject.isAddressEdit = NO;
            [self.view endEditing:YES];
            [self saveProfileInfo:indexpath];
            return;

        }
        else{
            self.profileObject.isAddressEdit = YES;
        }
        if (self.profileObject.isAddressEdit) {
            [self.tblView beginUpdates];
            [self.tblView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tblView endUpdates];
        }
        return;
    }
    ///////////////// ADDRESS END
    
    if (sender.tag == DESCRIPTION_BUTTON_TAG) {
        //This Condition is only for DESCRIPTION Edit
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:5 inSection:0];
        
        UITableViewCell *cell = (UITableViewCell *)[self.tblView cellForRowAtIndexPath:indexpath];
        UITextView *txtView =  (UITextView *)[cell viewWithTag:TEXT_VIEW_TAG];
        self.profileObject.descriptionString = txtView.text;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        if(self.profileObject.isDescriptionEdit){
            self.profileObject.isDescriptionEdit = NO;
            [self.view endEditing:YES];
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            self.profileObject.isDescriptionEdit = YES;
        }
        
        if (self.profileObject.isDescriptionEdit) {
            [self.tblView beginUpdates];
            [self.tblView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tblView endUpdates];
        }
        return;
    }
    ///////////////// DESCRIPTION END
    
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"Tag is %ld",(long)indexpath.row);
    ProfileViewEditUpdateCell *cell = [self.tblView cellForRowAtIndexPath:indexpath];
    if (editableString.length>1) {
        if (isEditMode && ![cell.headerLabel.text isEqualToString:editableString]) {
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:[NSString messageWithSAVEString:editableString]
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
            return;
        }
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"FIRST_NAME")]) {

        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        self.profileObject.firstNameString = cell.descriptionTextField.text;
        if(self.profileObject.isFirstNameEdit){
            editableString = @"";
            self.profileObject.isFirstNameEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
        }
        else{
            editableString = NSLOCALIZEDSTRING(@"FIRST_NAME");
            self.profileObject.isFirstNameEdit = YES;
        }
        isEditMode = self.profileObject.isFirstNameEdit;
    }
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"LAST_NAME")]) {
        
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.lastNameString = cell.descriptionTextField.text;
        if(self.profileObject.isLastNameEdit){
            editableString = @"";
            self.profileObject.isLastNameEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"LAST_NAME");
            self.profileObject.isLastNameEdit = YES;
        }
        isEditMode = self.profileObject.isLastNameEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"NICK_NAME")]) {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.nickNameString = cell.descriptionTextField.text;
        if(self.profileObject.isNickNameEdit){
            editableString = @"";
            self.profileObject.isNickNameEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            editableString = NSLOCALIZEDSTRING(@"NICK_NAME");
            self.profileObject.isNickNameEdit = YES;
        }
        isEditMode = self.profileObject.isNickNameEdit;
        
    }

    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"CITY")]) {
        
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.cityString = cell.descriptionTextField.text;
        if(self.profileObject.isCityEdit){
            editableString = @"";
            self.profileObject.isCityEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"CITY");
            self.profileObject.isCityEdit = YES;
        }
        isEditMode = self.profileObject.isCityEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"POSTAL_CODE")]) {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.postalCodeString = cell.descriptionTextField.text;
        if(self.profileObject.isPostalCodeEdit){
            editableString = @"";
            self.profileObject.isPostalCodeEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            editableString = NSLOCALIZEDSTRING(@"POSTAL_CODE");
            self.profileObject.isPostalCodeEdit = YES;
        }
        isEditMode = self.profileObject.isPostalCodeEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]) {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.phoneNumberString = cell.descriptionTextField.text;
        if(self.profileObject.isPhoneNumberEdit){
            editableString = @"";
            self.profileObject.isPhoneNumberEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"PHONE_NUMBER");
            self.profileObject.isPhoneNumberEdit = YES;
        }
        isEditMode = self.profileObject.isPhoneNumberEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"CARD_TYPE")]) {
        
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.cardTypeString = cell.descriptionTextField.text;
        if(self.profileObject.isCardTypeEdit){
            editableString = @"";
            self.profileObject.isCardTypeEdit = NO;
            self.profileObject.cardTypeString = [self.cardTypeArray objectAtIndex:selectedCardTypeRow];
            [self saveProfileInfo:indexpath];
            return;
        }
        else{
            editableString = NSLOCALIZEDSTRING(@"CARD_TYPE");
            self.profileObject.isCardTypeEdit = YES;
            [self showPickerView];
        }
        isEditMode = self.profileObject.isCardTypeEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"CARD_NUMBER")]) {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.cardNumberString = cell.descriptionTextField.text;
        if(self.profileObject.isCardNumberEdit){
            editableString = @"";
            self.profileObject.isCardNumberEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"CARD_NUMBER");
            self.profileObject.isCardNumberEdit = YES;
        }
        isEditMode = self.profileObject.isCardNumberEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"EXPIRY_MONTH")]) {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.expMonthString = cell.descriptionTextField.text;
        if(self.profileObject.isExpMonthEdit){
            editableString = @"";
            self.profileObject.isExpMonthEdit = NO;
            [self saveProfileInfo:indexpath];
            return;

        }
        else{
            editableString = NSLOCALIZEDSTRING(@"EXPIRY_MONTH");
            self.profileObject.isExpMonthEdit = YES;
        }
        isEditMode = self.profileObject.isExpMonthEdit;

    }
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"EXPIRY_YEAR")]) {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.expYearString = cell.descriptionTextField.text;
        if(self.profileObject.isExpYearEdit){
            editableString = @"";
            self.profileObject.isExpYearEdit = NO;
            [self saveProfileInfo:indexpath];
            return;

        }
        else{
            editableString = NSLOCALIZEDSTRING(@"EXPIRY_YEAR");
            self.profileObject.isExpYearEdit = YES;
        }
        isEditMode = self.profileObject.isExpYearEdit;

    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"CVV")]) {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        
        self.profileObject.CVVString = cell.descriptionTextField.text;
        
        if(self.profileObject.isCVVEdit){
            editableString = @"";
            self.profileObject.isCVVEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"CVV");
            self.profileObject.isCVVEdit = YES;
        }
        isEditMode = self.profileObject.isCVVEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"GENDER")])
    {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardTypeEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.CVVString = cell.descriptionTextField.text;
        
        if(self.profileObject.isCVVEdit){
            editableString = @"";
            self.profileObject.isGenderEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
        }
        else{
            editableString = NSLOCALIZEDSTRING(@"GENDER");
            self.profileObject.isGenderEdit = YES;
            [self showPickerView];
        }
        isEditMode = self.profileObject.isGenderEdit;
    }
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"CARD_TYPE")])
    {
        self.profileObject.isFirstNameEdit = NO;
        self.profileObject.isLastNameEdit = NO;
        self.profileObject.isNickNameEdit = NO;
        self.profileObject.isAddressEdit = NO;
        self.profileObject.isCityEdit = NO;
        self.profileObject.isPostalCodeEdit = NO;
        self.profileObject.isPhoneNumberEdit = NO;
        self.profileObject.isCardNumberEdit = NO;
        self.profileObject.isExpMonthEdit = NO;
        self.profileObject.isExpYearEdit = NO;
        self.profileObject.isDescriptionEdit = NO;
        self.profileObject.isGenderEdit = NO;
        self.profileObject.isCVVEdit = NO;
        self.profileObject.CVVString = cell.descriptionTextField.text;
        
        if(self.profileObject.cardTypeString){
            editableString = @"";
            self.profileObject.isCardTypeEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"CARD_TYPE");
            self.profileObject.isCardTypeEdit = YES;
        }
        isEditMode = self.profileObject.isCardTypeEdit;
        
    }
    
    
    if (isEditMode) {
        //[self.tblView beginUpdates];
        //[self.tblView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
        //[self.tblView endUpdates];
        [self.tblView reloadData];
    }
}

-(void)getProfileInfo
{
    //WEB Service CODE
   
    [Web_Service_Call serviceCallWithRequestType:nil requestType:GET_REQUEST includeHeader:YES includeBody:NO webServicename:self.isInterpreter?PROFILE_INFO_W:PROFILE_INFO_W_USER SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
                NSMutableDictionary *userDict = [responseDict objectForKey:@"user"];
                self.profileObject = [ProfileInfoObject new];
                self.profileObject.uIdString = [userDict objectForKey:KUID_W];
                self.profileObject.idString = [userDict objectForKey:KID_W];
                [Utility_Shared_Instance writeStringUserPreference:KID_W value:[userDict objectForKey:KID_W]];
                self.profileObject.emailString = [userDict objectForKey:KEMAIL_W];
                self.profileObject.passwordString = [userDict objectForKey:KPASSWORD_W];
                self.profileObject.nickNameString = [userDict objectForKey:KUSERNAME_W];
                NSDictionary *nameDict =  [userDict objectForKey:KNAME_W];
                self.profileObject.nameString = [NSString stringWithFormat:@"%@ %@",[nameDict objectForKey:KFIRST_NAME_W],[nameDict objectForKey:KLAST_NAME_W]];
                if ([[nameDict allKeys]count] == 0) {
                    self.profileObject.firstNameString = @"";
                    self.profileObject.lastNameString = @"";
                }else{
                    self.profileObject.firstNameString = [nameDict objectForKey:KFIRST_NAME_W];
                    self.profileObject.lastNameString = [nameDict objectForKey:KLAST_NAME_W];
                }
                self.profileObject.countryString = [userDict objectForKey:KCOUNTRY_W];
                self.profileObject.cityString = [userDict objectForKey:KCITY_W];
                self.profileObject.stateString = [userDict objectForKey:KSTATE_W];
                self.profileObject.addressString = [userDict objectForKey:KADDRESS_W];
                self.profileObject.genderString = [userDict objectForKey:KGENDER];
                self.profileObject.dobString = [userDict objectForKey:KDOB];
                self.profileObject.postalCodeString = [userDict objectForKey:KPOSTALCODE_W];
                self.profileObject.phoneNumberString = [userDict objectForKey:KPHONE_NUMBER_W];
                self.profileObject.myLanguagesString = [userDict objectForKey:KMYLANGUAGES_W];
                
                NSDictionary *profileImgDict =  [userDict objectForKey:KPROFILE_IMAGE_W];
                self.profileObject.imageURLString = [profileImgDict objectForKey:KURL_W];
                
                if ([[Utility_Shared_Instance readStringUserPreference:KCOMPLETION_W] isEqualToString:PROFILE_INCOMPLETE])
                {
                    if (!self.profileObject.firstNameString.length) {
                        self.profileObject.isFirstNameEdit = YES;
                    }
                    if (!self.profileObject.lastNameString.length) {
                        self.profileObject.isLastNameEdit = YES;
                    }
                    if (!self.profileObject.nickNameString.length) {
                        self.profileObject.isNickNameEdit = YES;
                    }
                    if (!self.profileObject.addressString.length) {
                        self.profileObject.isAddressEdit = YES;
                    }
                    if (!self.profileObject.postalCodeString.length) {
                        self.profileObject.isPostalCodeEdit = YES;
                    }
                    if (!self.profileObject.cityString.length) {
                        self.profileObject.isCityEdit = YES;
                    }
                    if (!self.profileObject.phoneNumberString.length) {
                        self.profileObject.isPhoneNumberEdit = YES;
                    }
                    if (!self.profileObject.eINtaxIDString.length) {
                        self.profileObject.isEinTaxEdit = YES;
                    }
                    if (!self.profileObject.myLanguagesString.length) {
                    }
                    if (!self.profileObject.certificatesString.length) {
                        self.profileObject.isCertificatesEdit = YES;
                    }
                }
                [self.tblView reloadData];
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

-(void)languagesButtonPressed{
    if ([self.view viewWithTag:1000]) {
        [[self.view viewWithTag:1000] removeFromSuperview];
    }
    if ([self.view viewWithTag:3000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    if ([self.view viewWithTag:2000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.tag = 1000;
    languagesView.delegate = self;
    languagesView.selectedLanguagesDict  = [NSMutableDictionary new];
    if (self.selectedLanguagesDict.allValues.count) {
        languagesView.selectedLanguagesDict = self.selectedLanguagesDict;
    }
    [languagesView.tblView reloadData];
    [self.view addSubview:languagesView];
}

-(void)countryButtonPressed{
    if ([self.view viewWithTag:1000]) {
        [[self.view viewWithTag:1000] removeFromSuperview];
    }
    if ([self.view viewWithTag:3000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    if ([self.view viewWithTag:2000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.tag = 2000;

    languagesView.delegate = self;
    languagesView.isCountry = YES;
    languagesView.selectedCountriesStatesArray  = [NSMutableArray new];
    languagesView.countriesStatesArray = [[NSMutableArray alloc]initWithObjects:@"Afghanistan",@"Albania",@"Algeria",@"India",@"United Kingdom",@"USA", nil];
    [languagesView.tblView reloadData];
    [self.view addSubview:languagesView];
}

-(void)stateButtonPressed{
    if ([self.view viewWithTag:1000]) {
        [[self.view viewWithTag:1000] removeFromSuperview];
    }
    if ([self.view viewWithTag:3000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    if ([self.view viewWithTag:2000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.delegate = self;
    languagesView.tag = 3000;

    languagesView.isState = YES;
    languagesView.selectedCountriesStatesArray  = [NSMutableArray new];
    languagesView.countriesStatesArray = [[NSMutableArray alloc]initWithObjects:@"Maryland",@"Oklahoma",@"Oregon",@"Nevada", nil];
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

-(void)saveProfileInfo:(NSIndexPath *)currentIndexPath{
    [Utility_Shared_Instance showProgress];
    BOOL callWebService = YES;
    if ([[Utility_Shared_Instance readStringUserPreference:KCOMPLETION_W] isEqualToString:PROFILE_INCOMPLETE]){
        
        NSString *alertString;
        callWebService = NO;
        if (!self.profileObject.firstNameString.length) {
            alertString = NSLOCALIZEDSTRING(@"FIRST_NAME");
        }
        if (!self.profileObject.lastNameString.length) {
            alertString = NSLOCALIZEDSTRING(@"LAST_NAME");
        }
        if (!self.profileObject.nickNameString.length) {
            alertString = NSLOCALIZEDSTRING(@"NICK_NAME");
        }
        if (!self.profileObject.addressString.length) {
            alertString = NSLOCALIZEDSTRING(@"ADDRESS");
        }
        if (!self.profileObject.postalCodeString.length) {
            alertString = NSLOCALIZEDSTRING(@"POSTAL_CODE");
        }
        if (!self.profileObject.cityString.length) {
            alertString = NSLOCALIZEDSTRING(@"CITY");
        }
        if (!self.profileObject.phoneNumberString.length) {
            alertString = NSLOCALIZEDSTRING(@"PHONE_NUMBER");
        }
        if (!self.profileObject.eINtaxIDString.length) {
            alertString = NSLOCALIZEDSTRING(@"EIN_TaxID");
        }
        if (!self.profileObject.myLanguagesString.length) {
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:NSLOCALIZEDSTRING(@"PLEASE_SELECT_MY_LANGUAGES")
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
            return;
        }
        if (!self.profileObject.certificatesString.length) {
            alertString = NSLOCALIZEDSTRING(@"CERTIFICATES");
        }
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:[NSString messageWithString:alertString]
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];
        
        return;
    }
    ///WEB Service CODE
    NSMutableDictionary *saveDict=[NSMutableDictionary new];
    [saveDict setValue:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KID_W];
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.emailString] forKey:KEMAIL_W];
    //[saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.nameString] forKey:KNAME_W];
    NSMutableDictionary *dictName = [NSMutableDictionary new];
    [dictName setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.firstNameString] forKey:KFIRST_NAME_W];
    [dictName setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.lastNameString] forKey:KLAST_NAME_W];
    [saveDict setValue:dictName forKey:KNAME_W];

    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.nickNameString] forKey:KNICKNAME_W];
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.phoneNumberString] forKey:KPHONE_NUMBER_W];
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.myLanguagesString] forKey:KMYLANGUAGE_W];
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.addressString] forKey:KADDRESS_W];
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.countryString] forKey:KCOUNTRY_W];
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.stateString] forKey:KSTATE_W];
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.cityString] forKey:KCITY_W];
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.postalCodeString] forKey:KPOSTALCODE_W];
    
    
    
    if (!_isInterpreter) {
        NSMutableDictionary *dictName1 = [NSMutableDictionary new];
        [dictName1 setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.cardTypeString] forKey:KCARD_TYPE_W];
        [dictName1 setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.cardNumberString] forKey:KCARD_NUMBER_W];
        [dictName1 setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.expMonthString] forKey:KEXP_MONTH_W];
        [dictName1 setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.expYearString] forKey:KEXP_YEAR_W];
        [dictName1 setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.CVVString] forKey:KCVV_W];
        
        [saveDict setValue:dictName1 forKey:KPAYMENT_INFO_W];
        
        [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.genderString] forKey:KGENDER];
        [saveDict setValue:[Utility_Shared_Instance checkForNullString:@"1980-01-05"] forKey:KDOB];
        [saveDict setValue:@"about usserr" forKey:KABOUT_USER_W];
        
    }
    else
    {
        [saveDict setValue:@"2222" forKey:KEIN_TAXID_W];
        [saveDict setValue:dictName forKey:@"payment_info"];
    }
    
    
    
    [Web_Service_Call serviceCallWithRequestType:saveDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:self.isInterpreter?UPDATE_INTERPRETER_PROFILE_INFO_W:UPDATE_USER_PROFILE_INFO_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSLog(@"dict-->%@",responseDict);
            [self.tblView beginUpdates];
            [self.tblView reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tblView endUpdates];
        });
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

- (void)cameraGalleryButtonPressed{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.view.tag = 1010;
    //[self.view addSubview:imagePickerController.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self presentViewController:imagePickerController animated:YES completion:nil];
    });
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    // Dismiss the image selection, hide the picker and
    //show the image view with the picked image
    selectedImage=image;
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self dismissViewControllerAnimated:picker completion:nil];
        [self.tblView reloadData];
    });
    
    [[self.view viewWithTag:1010] removeFromSuperview];
    
    //UIImage *newImage = image;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[self.view viewWithTag:1010] removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self dismissViewControllerAnimated:picker completion:nil];
    });
}


-(void)showPickerView {

    
    self.backPickerview = [[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-290,[UIScreen mainScreen].bounds.size.width, 290)];
     self.backPickerview.backgroundColor = [UIColor grayColor];
    self.backPickerview.userInteractionEnabled=YES;
    [self.view addSubview:self.backPickerview];
    
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-60,05, 60, 27);
    [self.backPickerview addSubview:customButton];
    [customButton setTitle:@"Done" forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    
    UIPickerView * picker = [UIPickerView new];
    picker.backgroundColor = [UIColor clearColor];
    picker.frame = CGRectMake(0,40,[UIScreen mainScreen].bounds.size.width, 260);
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.backPickerview addSubview:picker];

}


-(void)doneButtonClicked {
    
    if (self.profileObject.isGenderEdit) {
        self.profileObject.genderString = [self.genderArray objectAtIndex:selectedGenderTypeRow];
    }
    else{
        self.profileObject.cardTypeString = [self.cardTypeArray objectAtIndex:selectedCardTypeRow];
    }
    
    if (self.backPickerview) {
        [self.backPickerview removeFromSuperview];
        self.backPickerview=nil;
    }
    
    [self.tblView reloadData];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.profileObject.isGenderEdit) {
        return self.genderArray.count;
    }
    return [self.cardTypeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.profileObject.isGenderEdit)
        return [self.genderArray objectAtIndex:row];
    
    return [self.cardTypeArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.profileObject.isGenderEdit)
        selectedGenderTypeRow = row;
    
    selectedCardTypeRow = row;
}

@end
