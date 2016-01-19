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

#define ADDRESS_TEXT_VIEW_TAG   1010
#define DESCRIPTION_TEXT_VIEW_TAG   1111



@implementation ProfileViewEditUpdateCell
@end
@implementation ProfileViewEditUpdateAnswerCell
@end

@interface ProfileViewEditViewController ()<UITableViewDataSource,UITableViewDelegate,MyLanguagesDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate>{
    CGFloat descriptionHeight;
    UITableViewCell *addressCell;
    UITableViewCell *descriptionCell;
    
    UIImage *selectedImage;
    BOOL isEditMode;
    NSString *editableString;
    
    NSInteger selectedRowInPicker;
    
    UIDatePicker *datePicker;
    
    UITapGestureRecognizer *tapGesture;
    
    NSIndexPath *editingIndexPath;
}
@property(nonatomic,strong) NSMutableArray *namesArray;
//@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong) ProfileInfoObject *profileObject;

@property(nonatomic,strong) NSMutableDictionary *selectedLanguagesDict;
@property(nonatomic,strong)NSMutableArray *cardTypeArray;
@property(nonatomic,strong)NSMutableArray *genderArray;
@property(nonatomic,strong)NSMutableArray *expiryMonthArray;
@property(nonatomic,strong)NSMutableArray *expiryYearArray;
@property(nonatomic,strong)UIView *backPickerview;
@end

@implementation ProfileViewEditViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _isInterpreter = [[Utility_Shared_Instance readStringUserPreference:USER_TYPE] isEqualToString:INTERPRETER];
    
    [_tblView setShowsHorizontalScrollIndicator:NO];
    [_tblView setShowsVerticalScrollIndicator:NO];
    
    [self allocationsAndStaticText];
    
    if(self.isFromDashBoard)
        [self setCustomBackButtonForNavigation];
    else
        [self setSlideMenuButtonFornavigation];
    
    [self setLogoutButtonForNavigation];
    
    [Utility_Shared_Instance showProgress];
    [self performSelector:@selector(getProfileInfo) withObject:nil afterDelay:0.2];
    
    [self addTapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    self.tblView.contentInset = contentInsets;
    self.tblView.scrollIndicatorInsets = contentInsets;
    [self.tblView scrollToRowAtIndexPath:editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tblView.contentInset = UIEdgeInsetsZero;
    self.tblView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tblView.backgroundColor = [UIColor backgroundColor];
}

-(void)addTapGesture{
    tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removePickerViews)];
    tapGesture.numberOfTouchesRequired=1;
    //[self.view addGestureRecognizer:tapGesture];
}

-(void)removeTapGesture{
    //[self.view removeGestureRecognizer:tapGesture];
}

-(void)allocationsAndStaticText{
    
    self.profileObject = [ProfileInfoObject new];
    self.selectedLanguagesDict = [NSMutableDictionary new];
    
    isEditMode = false;
    editableString = @"";
    selectedRowInPicker = 0;
    
    self.cardTypeArray = [[NSMutableArray alloc]initWithObjects:@"Visa Debit Card",@"MasterCard Debit Card",@"Maestro Debit Card", nil];
    self.genderArray = [[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
    
    self.expiryMonthArray = [[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    self.expiryYearArray = [NSMutableArray new];
    for (int i=2017; i<=2099; i++) {
        [self.expiryYearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    

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
                            nil];
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
        [cell.profileImageView setContentMode:UIViewContentModeScaleToFill];
        
        if ([Utility_Shared_Instance checkForNullString:self.profileObject.imageURLString].length) {
            cell.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.profileObject.imageURLString]]];
        }
        if (selectedImage) {
            cell.profileImageView.image= selectedImage;
        }
        cell.nameLabel.text = [Utility_Shared_Instance checkForNullString:self.profileObject.nameString];
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
                if ([addressCell viewWithTag:ADDRESS_TEXT_VIEW_TAG]) {
                    [[addressCell viewWithTag:ADDRESS_TEXT_VIEW_TAG] removeFromSuperview];
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
                
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 35, self.view.frame.size.width-20, [self heightOfTextViewWithString:self.profileObject.addressString withFont:[UIFont normal] andFixedWidth:280])];
                textView.delegate = self;
                textView.tag = ADDRESS_TEXT_VIEW_TAG;
                textView.text = self.profileObject.addressString;
                [UITextView roundedCornerTextView:textView];
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
                if ([descriptionCell viewWithTag:DESCRIPTION_TEXT_VIEW_TAG]) {
                    [[descriptionCell viewWithTag:DESCRIPTION_TEXT_VIEW_TAG] removeFromSuperview];
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
                
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 35, self.view.frame.size.width-20, [self heightOfTextViewWithString:self.profileObject.descriptionString withFont:[UIFont normal] andFixedWidth:280])];
                textView.delegate = self;
                textView.tag = DESCRIPTION_TEXT_VIEW_TAG;
                textView.text = self.profileObject.descriptionString;
                [UITextView roundedCornerTextView:textView];
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
        cell.descriptionTextField.delegate = self;
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
        cell.descriptionTextField.placeholder = [self.namesArray objectAtIndex:indexPath.row];
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
            cell.editButton.tag = indexPath.row;
            
            cell.descriptionTextField.userInteractionEnabled = NO;
            cell.descriptionTextField.backgroundColor = [UIColor clearColor];
            [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            if (self.profileObject.isGenderEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.genderString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"DOB")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            
            cell.descriptionTextField.userInteractionEnabled = NO;
            cell.descriptionTextField.backgroundColor = [UIColor clearColor];
            [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            if (self.profileObject.isDOBEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.dobString];
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
            
            cell.descriptionTextField.userInteractionEnabled = NO;
            cell.descriptionTextField.backgroundColor = [UIColor clearColor];
            [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            if (self.profileObject.isCardTypeEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
            }
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
            
            cell.descriptionTextField.userInteractionEnabled = NO;
            cell.descriptionTextField.backgroundColor = [UIColor clearColor];
            [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            if (self.profileObject.isExpYearEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.expYearString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EXPIRY_MONTH")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            
            cell.descriptionTextField.userInteractionEnabled = NO;
            cell.descriptionTextField.backgroundColor = [UIColor clearColor];
            [cell.descriptionTextField setBorderStyle:UITextBorderStyleNone];
            if (self.profileObject.isExpMonthEdit) {
                cell.editImageView.image = [UIImage CheckOrTickImage];
            }
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.expMonthString];
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.eINtaxIDString];
            if (self.profileObject.isEinTaxEdit) {
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
        }
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"CERTIFICATES")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
            cell.editButton.tag = indexPath.row;
            cell.mandatoryLabel.hidden = YES;
            cell.descriptionTextField.text = [Utility_Shared_Instance checkForNullString:self.profileObject.certificatesString];
            if (self.profileObject.isCertificatesEdit) {
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
    
    [self removePickerViews];
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
        editingIndexPath = indexpath;
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
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
        editingIndexPath = indexpath;
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
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
    editingIndexPath = indexpath;
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
        self.profileObject.expMonthString = cell.descriptionTextField.text;
        if(self.profileObject.isExpMonthEdit){
            [self removePickerViews];
            editableString = @"";
            self.profileObject.isExpMonthEdit = NO;
            [self saveProfileInfo:indexpath];
            return;

        }
        else{
            editableString = NSLOCALIZEDSTRING(@"EXPIRY_MONTH");
            self.profileObject.isExpMonthEdit = YES;
            [self showPickerView:@"monthyear"];
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
        self.profileObject.expYearString = cell.descriptionTextField.text;
        if(self.profileObject.isExpYearEdit){
            [self removePickerViews];
            editableString = @"";
            self.profileObject.isExpYearEdit = NO;
            [self saveProfileInfo:indexpath];
            return;

        }
        else{
            editableString = NSLOCALIZEDSTRING(@"EXPIRY_YEAR");
            self.profileObject.isExpYearEdit = YES;
            [self showPickerView:@"monthyear"];
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
        if(self.profileObject.isGenderEdit){
            [self removePickerViews];
            editableString = @"";
            self.profileObject.isGenderEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
        }
        else{
            editableString = NSLOCALIZEDSTRING(@"GENDER");
            self.profileObject.isGenderEdit = YES;
            [self showPickerView:@"gendercard"];
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.isEinTaxEdit = NO;
        self.profileObject.isDOBEdit = NO;
        
        if(self.profileObject.isCardTypeEdit){
            [self removePickerViews];
            editableString = @"";
            self.profileObject.isCardTypeEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            editableString = NSLOCALIZEDSTRING(@"CARD_TYPE");
            self.profileObject.isCardTypeEdit = YES;
            [self showPickerView:@"gendercard"];
        }
        isEditMode = self.profileObject.isCardTypeEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")])
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
        self.profileObject.isDOBEdit = NO;
        
        self.profileObject.eINtaxIDString = cell.descriptionTextField.text;
        self.profileObject.isCertificatesEdit = NO;
        if(self.profileObject.isEinTaxEdit){
            editableString = @"";
            self.profileObject.isEinTaxEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"EIN_TaxID");
            self.profileObject.isEinTaxEdit = YES;
        }
        isEditMode = self.profileObject.isEinTaxEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"CERTIFICATES")])
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
        self.profileObject.isDOBEdit = NO;
        
        self.profileObject.certificatesString = cell.descriptionTextField.text;
        self.profileObject.isEinTaxEdit = NO;
        if(self.profileObject.isCertificatesEdit){
            editableString = @"";
            self.profileObject.isCertificatesEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
            
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"CERTIFICATES");
            self.profileObject.isCertificatesEdit = YES;
        }
        isEditMode = self.profileObject.isCertificatesEdit;
        
    }
    
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"DOB")])
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
        self.profileObject.isCertificatesEdit = NO;
        self.profileObject.dobString = cell.descriptionTextField.text;
        self.profileObject.isEinTaxEdit = NO;
        if(self.profileObject.isDOBEdit){
            [self removePickerViews];
            editableString = @"";
            self.profileObject.isDOBEdit = NO;
            [self saveProfileInfo:indexpath];
            return;
        }
        else{
            
            editableString = NSLOCALIZEDSTRING(@"DOB");
            self.profileObject.isDOBEdit = YES;
            [self showPickerView:@"dob"];
        }
        isEditMode = self.profileObject.isDOBEdit;
        
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
                if ([userDict objectForKey:KNAME_W]) {
                    NSDictionary *nameDict =  [userDict objectForKey:KNAME_W];
                    self.profileObject.nameString = [NSString stringWithFormat:@"%@ %@",[nameDict objectForKey:KFIRST_NAME_W],[nameDict objectForKey:KLAST_NAME_W]];
                    if ([[nameDict allKeys]count] == 0) {
                        self.profileObject.firstNameString = @"";
                        self.profileObject.lastNameString = @"";
                    }else{
                        self.profileObject.firstNameString = [nameDict objectForKey:KFIRST_NAME_W];
                        self.profileObject.lastNameString = [nameDict objectForKey:KLAST_NAME_W];
                    }
                }
                else{
                    self.profileObject.nameString = @"";
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
                
                //////
                NSDictionary *profileImgDict =  [userDict objectForKey:KPROFILE_IMAGE_W];
                self.profileObject.imageURLString = [profileImgDict objectForKey:KURL_W];
                ///////////
                
                [self makeEditableMandatoryFields];
                
                self.profileObject.dobString = [self dateConvertion];
                
                ///////////
                NSArray *langArray = [self.profileObject.myLanguagesString componentsSeparatedByString:@","];
                if (langArray.count) {
                    self.profileObject.myLanguagesString = @"";
                    NSMutableString *mutableStr;
                    MyLanguagesView *languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
                    NSMutableDictionary *languagesDit = [languagesView getLanguagesDictionary];
                    for (id key in langArray) {
                        NSLog(@"adsads======>>%@",[languagesDit objectForKey:@"English"]);
                        NSString *str = [languagesDit objectForKey:key];
                        [mutableStr appendString:str];
                    }
                }
                /////////////////
                [self.tblView reloadData];
            });
        }
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

-(void)makeEditableMandatoryFields{
    
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
    }
    [self.tblView reloadData];
}

-(void)languagesButtonPressed{
    [self.view endEditing:YES];
    [self removeTapGesture];
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
    [self.view endEditing:YES];
    [self removeTapGesture];
    
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
    [self.view endEditing:YES];
    [self removeTapGesture];
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
    self.profileObject.myLanguagesKEYsString = [[self.selectedLanguagesDict allKeys] componentsJoinedByString:@","];
    [self.tblView reloadData];
    [self addTapGesture];
}

-(void)finishCountrySelection:(NSMutableArray *)selectedDataArray{
    NSLog(@"selectedDataArray -->%@",[selectedDataArray description]);
    self.profileObject.countryString = [selectedDataArray componentsJoinedByString:@","];
    [self.tblView reloadData];
    [self addTapGesture];
}

-(void)finishStateSelection:(NSMutableArray *)selectedDataArray{
    NSLog(@"selectedDataArray -->%@",[selectedDataArray description]);
    self.profileObject.stateString = [selectedDataArray componentsJoinedByString:@","];
    [self.tblView reloadData];
    [self addTapGesture];
}

-(void)saveProfileInfo:(NSIndexPath *)currentIndexPath{
    [Utility_Shared_Instance showProgress];
    [self.view endEditing:YES];
    BOOL callWebService = YES;
    if ([[Utility_Shared_Instance readStringUserPreference:KCOMPLETION_W] isEqualToString:PROFILE_INCOMPLETE]){
        
        NSString *alertString=@"";
        callWebService = NO;
        if (!self.profileObject.firstNameString.length) {
            alertString = NSLOCALIZEDSTRING(@"FIRST_NAME");
        }
        else if (!self.profileObject.lastNameString.length) {
            alertString = NSLOCALIZEDSTRING(@"LAST_NAME");
        }
        else if (!self.profileObject.nickNameString.length) {
            alertString = NSLOCALIZEDSTRING(@"NICK_NAME");
        }
        else if (!self.profileObject.addressString.length) {
            alertString = NSLOCALIZEDSTRING(@"ADDRESS");
        }
        else if (!self.profileObject.postalCodeString.length) {
            alertString = NSLOCALIZEDSTRING(@"POSTAL_CODE");
        }
        else if (!self.profileObject.cityString.length) {
            alertString = NSLOCALIZEDSTRING(@"CITY");
        }
        else if (!self.profileObject.phoneNumberString.length) {
            alertString = NSLOCALIZEDSTRING(@"PHONE_NUMBER");
        }
        else if (!self.profileObject.eINtaxIDString.length) {
            alertString = NSLOCALIZEDSTRING(@"EIN_TaxID");
        }
        else if (!self.profileObject.myLanguagesString.length) {
            [SVProgressHUD dismiss];
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:NSLOCALIZEDSTRING(@"PLEASE_SELECT_MY_LANGUAGES")
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
            return;
        }
        
        if (alertString.length>1) {
            [SVProgressHUD dismiss];
            [self makeEditableMandatoryFields];
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:[NSString messageWithString:alertString]
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
            
            return;
        }
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
    [saveDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.myLanguagesKEYsString] forKey:KMYLANGUAGE_W];
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
        [saveDict setValue:self.profileObject.eINtaxIDString forKey:KEIN_TAXID_W];
        [saveDict setValue:dictName forKey:@"payment_info"];
    }
    
    [Web_Service_Call serviceCallWithRequestType:saveDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:self.isInterpreter?UPDATE_INTERPRETER_PROFILE_INFO_W:UPDATE_USER_PROFILE_INFO_W SuccessfulBlock:^(NSInteger responseCode, id responseObject){
        
        NSDictionary *responseDict=responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSLog(@"dict-->%@",responseDict);
            [self.tblView beginUpdates];
            [self.tblView reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tblView endUpdates];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:[responseDict objectForKey:KMESSAGE_W]
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
            
        });
        
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            [Utility_Shared_Instance writeStringUserPreference:KCOMPLETION_W value:PROFILE_COMPLETE];
        }
    }
      FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              [SVProgressHUD dismiss];
              [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                  withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                       inView:self
                                                    withStyle:UIAlertControllerStyleAlert];
          });
      }];
}



- (void)cameraGalleryButtonPressed{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLOCALIZEDSTRING(@"CHOOSE_PROFILE_IMAGE") message:@"" delegate:self cancelButtonTitle:NSLOCALIZEDSTRING(@"CAMERA") otherButtonTitles:NSLOCALIZEDSTRING(@"GALLERY"), nil];
    alertView.delegate = self;
    alertView.tag = 111;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera
            ;
        }
        else {
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:NSLOCALIZEDSTRING(@"DEVICE_NO_CAMERA")
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
        }
    }
    else{
        //if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        }
        /*
        else
        {
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:NSLOCALIZEDSTRING(@"DEVICE_NO_PHOTO_LIBRARY")
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
        }
        */
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:imagePickerController animated:YES completion:nil];
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
        [self dismissViewControllerAnimated:picker completion:nil];
        [self.tblView reloadData];
    });
    
    self.profileObject.base64EncodedImageString = [Utility_Shared_Instance encodeToBase64String:image];
    
    [self uploadImageToServer];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:picker completion:nil];
    });
}


-(void)showPickerView:(NSString *)pickerType {

    
    self.backPickerview = [[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-290,[UIScreen mainScreen].bounds.size.width, 290)];
     self.backPickerview.backgroundColor = [UIColor grayColor];
    self.backPickerview.userInteractionEnabled=YES;
    [self.view addSubview:self.backPickerview];
    
    UIToolbar *toolBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar1.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(doneButtonClicked)];
    [toolBar1 setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    if ([pickerType isEqualToString:@"gendercard"] || [pickerType isEqualToString:@"monthyear"]) {
        UIPickerView * picker = [UIPickerView new];
        picker.backgroundColor = [UIColor clearColor];
        picker.frame = CGRectMake(0,40,[UIScreen mainScreen].bounds.size.width, 260);
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        [self.backPickerview addSubview:picker];
    }
    else if ([pickerType isEqualToString:@"dob"]) {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,40,[UIScreen mainScreen].bounds.size.width, 260)];
        datePicker.datePickerMode=UIDatePickerModeDate;
        //Setting user selected date as the date picker default
        //[datePicker setDate:date animated:YES];
        [datePicker addTarget:self action:@selector(taskDatePicked)forControlEvents:UIControlEventValueChanged];
        [_backPickerview addSubview:datePicker];
    }
    
    [_backPickerview addSubview:toolBar1];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.profileObject.isGenderEdit) {
        return self.genderArray.count;
    }
    else if (self.profileObject.isExpMonthEdit) {
        return self.expiryMonthArray.count;
    }
    else if (self.profileObject.isExpYearEdit) {
        return self.expiryYearArray.count;
    }
    else if (self.profileObject.isCardTypeEdit) {
        return self.cardTypeArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.profileObject.isGenderEdit)
        return [self.genderArray objectAtIndex:row];
    else if (self.profileObject.isExpMonthEdit) {
        return [self.expiryMonthArray objectAtIndex:row];
    }
    else if (self.profileObject.isExpYearEdit) {
        return [self.expiryYearArray objectAtIndex:row];
    }
    else if (self.profileObject.isCardTypeEdit) {
        return [self.cardTypeArray objectAtIndex:row];
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        selectedRowInPicker = row;
}



-(void)doneButtonClicked {
    
    if (self.profileObject.isGenderEdit) {
        self.profileObject.genderString = [self.genderArray objectAtIndex:selectedRowInPicker];
    }
    else if (self.profileObject.isCardTypeEdit){
        self.profileObject.cardTypeString = [self.cardTypeArray objectAtIndex:selectedRowInPicker];
    }
    else if (self.profileObject.isExpMonthEdit){
        self.profileObject.expMonthString = [self.expiryMonthArray objectAtIndex:selectedRowInPicker];
    }
    else if (self.profileObject.isExpYearEdit){
        self.profileObject.expYearString = [self.expiryYearArray objectAtIndex:selectedRowInPicker];
    }
    
    [self removePickerViews];
    
    [self.tblView reloadData];
}

-(void)removePickerViews{
    if (self.backPickerview) {
        [self.backPickerview removeFromSuperview];
        self.backPickerview=nil;
    }
}
-(void)taskDateDone{
    
}
-(void)taskDatePicked{
    self.profileObject.dobString=[NSString stringWithFormat:@"%@",datePicker.date];
}

-(NSString *)dateConvertion
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *strTempDate = [dateFormatter dateFromString:self.profileObject.dobString];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *str=[dateFormatter stringFromDate:strTempDate];
    return str;
}

-(void)uploadImageToServer{
    ///WEB Service CODE
    //"data:image/jpeg;base64"
    /*
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://54.153.22.179/api/upload"]];
    
    NSData *imageData = UIImageJPEGRepresentation(selectedImage, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request addValue:[NSString stringWithFormat:@"%@%@",@"Bearer ",[Utility_Shared_Instance readStringUserPreference:USER_TOKEN]]  forHTTPHeaderField:KAUTHORIZATION_W];
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        
        NSMutableDictionary *imageDict=[NSMutableDictionary new];
        [imageDict setValue:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KID_W];
        [imageDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.emailString] forKey:KEMAIL_W];
        [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64",self.profileObject.base64EncodedImageString];
        [imageDict setValue:self.profileObject.base64EncodedImageString forKey:KFILE_W];
        [imageDict setValue:@"api" forKey:KSERVICE_TYPE_W];
        NSError *err = nil;
        NSData *bodyMore = [NSJSONSerialization dataWithJSONObject:imageDict options:NSJSONWritingPrettyPrinted error:&err];
        
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:bodyMore];
        //[body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", (unsigned)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            NSError *errorNIl = nil;
            NSDictionary *dictResponse =[NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorNIl]];
            
            NSLog(@"-------SUCCESSSSSSS----dictResponse-->%@",dictResponse.description);
            //success
        }
        else{
             NSLog(@"-------failure------>%@",error.description);
        }
    }];
    */
    
    ///*
    NSMutableDictionary *imageDict=[NSMutableDictionary new];
    [imageDict setValue:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KID_W];
    [imageDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.emailString] forKey:KEMAIL_W];
    //[imageDict setValue:[NSString stringWithFormat:@"%@%@",@"",self.profileObject.base64EncodedImageString] forKey:KFILE_W];
    //[imageDict setValue:[NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",self.profileObject.base64EncodedImageString] forKey:KFILE_W];
    //[imageDict setValue:[NSString stringWithFormat:@"%@%@",@"data:image/png;base64",self.profileObject.base64EncodedImageString] forKey:KFILE_W];
    [imageDict setValue:@"data:image/jpeg;base64,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" forKey:KFILE_W];
    [imageDict setValue:@"api" forKey:KSERVICE_TYPE_W];
    
    [Web_Service_Call serviceCallWithRequestType:imageDict requestType:POST_REQUEST includeHeader:YES includeBody:YES webServicename:PROFILE_IMAGE_UPLOAD_W SuccessfulBlock:^(NSInteger responseCode, id responseObject){
        
        NSDictionary *responseDict=responseObject;

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:[responseDict objectForKey:KMESSAGE_W]
                                                     inView:self
                                                  withStyle:UIAlertControllerStyleAlert];
            
        });
        
        
    }
    FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
      dispatch_async(dispatch_get_main_queue(), ^{
          [SVProgressHUD dismiss];
          [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                              withMessage:[responseObject objectForKey:KMESSAGE_W]
                                                   inView:self
                                                withStyle:UIAlertControllerStyleAlert];
      });
    }];
    //*/
}
#pragma mark TextField Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    textField.keyboardType  = UIKeyboardTypeDefault;
    if (([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"POSTAL_CODE")])||([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")])||([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CARD_NUMBER")])||([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")])){
        textField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"EMAIL")])
    {
        self.profileObject.emailString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"FIRST_NAME")]){
        self.profileObject.firstNameString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"LAST_NAME")]){
        self.profileObject.lastNameString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"NICK_NAME")]){
        self.profileObject.nickNameString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CITY")]){
        self.profileObject.cityString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"POSTAL_CODE")]){
        self.profileObject.postalCodeString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]){
        self.profileObject.phoneNumberString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CARD_NUMBER")]){
        self.profileObject.cardNumberString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")]){
        self.profileObject.eINtaxIDString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CERTIFICATES")]){
        self.profileObject.certificatesString = textField.text;
    }
    [self.tblView reloadData];
}

#pragma Mark TextView Delegate Methods
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == ADDRESS_TEXT_VIEW_TAG) {
        self.profileObject.addressString = textView.text;
    }
    else if(textView.tag == DESCRIPTION_TEXT_VIEW_TAG){
        self.profileObject.descriptionString = textView.text;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
       [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
