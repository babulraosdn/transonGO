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

#define HEADER_HEIGHT 163
#define DEFAULT_TABLE_CELL_HEIGHT 57
#define DEFAULT_TABLE_CELL_HEIGHT_IF_BUTTON 70
#define DEFAULT_HEIGHT 40
#define DESCRIPTION_BUTTON_TAG 555
#define IMAGE_VIEW_TAG  666
#define EDIT_BUTTON_TAG 777
#define LABEL_TAG       888
#define TEXT_VIEW_TAG   999

#define ADDRESS_TEXT_VIEW_TAG   1010
#define DESCRIPTION_TEXT_VIEW_TAG   1111

#define TEXT_MINIMUM_HEIGHT   25


@implementation ProfileViewEditUpdateCell
@end
@implementation ProfileViewLanguageCell
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
    
    MyLanguagesView *languagesView;
}
@property(nonatomic,strong) NSMutableArray *namesArray;
@property(nonatomic,strong) NSMutableArray *countryArray;
@property(nonatomic,strong) NSMutableArray *stateArray;
@property(nonatomic,strong) NSMutableArray *einTaxArray;
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong) ProfileInfoObject *profileObject;

@property(nonatomic,strong) NSMutableDictionary *selectedLanguagesDict;
@property(nonatomic,strong)NSMutableArray *cardTypeArray;
@property(nonatomic,strong)NSMutableArray *genderArray;
@property(nonatomic,strong)NSMutableArray *expiryMonthArray;
@property(nonatomic,strong)NSMutableArray *expiryYearArray;
@property(nonatomic,strong)UIView *backPickerview;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
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
    
    self.einTaxArray = [[NSMutableArray alloc]initWithObjects:@"India",@"Japan", nil];
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
    
    
    self.headerLabel.font = [UIFont normalSize];
    self.headerLabel.text = NSLOCALIZEDSTRING(@"PROFILE");
    
    [self getCountryList];
    
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
    
    self.cardTypeArray = [[NSMutableArray alloc]initWithObjects:@"Visa Card",@"MasterCard",@"Maestro Debit Card", nil];
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
            if (self.profileObject.addressString.length<TEXT_MINIMUM_HEIGHT) {
                //defaultHeight = DEFAULT_HEIGHT;
                return DEFAULT_TABLE_CELL_HEIGHT;
            }
            
            return [self heightOfTextViewWithString:self.profileObject.addressString withFont:[UIFont normal] andFixedWidth:self.view.frame.size.width]+defaultHeight;
        }
        else{
            int defaultHeight = 0;
            if (self.profileObject.descriptionString.length<TEXT_MINIMUM_HEIGHT) {
                //defaultHeight = DEFAULT_HEIGHT;
                return DEFAULT_TABLE_CELL_HEIGHT;
            }
            return [self heightOfTextViewWithString:self.profileObject.descriptionString withFont:[UIFont normal] andFixedWidth:self.view.frame.size.width]+defaultHeight;
        }
    }
    else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"MY_LANGUAGES")]){
        return [self.selectedLanguagesDict allKeys].count>=3?DEFAULT_TABLE_CELL_HEIGHT+3*35:DEFAULT_TABLE_CELL_HEIGHT+[self.selectedLanguagesDict allKeys].count*35+8;
        
    }
    else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"COUNTRY")] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"STATE")])
        return DEFAULT_TABLE_CELL_HEIGHT_IF_BUTTON;
    
    return DEFAULT_TABLE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return HEADER_HEIGHT;
    }
    else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Description"]) {
        //return 100;
        //return UITableViewAutomaticDimension;
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"]){
            int defaultHeight = 0;
            if (self.profileObject.addressString.length<TEXT_MINIMUM_HEIGHT) {
                //defaultHeight = DEFAULT_HEIGHT;
                return DEFAULT_TABLE_CELL_HEIGHT;
            }
            
            return [self heightOfTextViewWithString:self.profileObject.addressString withFont:[UIFont normal] andFixedWidth:self.view.frame.size.width]+defaultHeight+15;
        }
        else{
            int defaultHeight = 0;
            if (self.profileObject.descriptionString.length<TEXT_MINIMUM_HEIGHT) {
                //defaultHeight = DEFAULT_HEIGHT;
                return DEFAULT_TABLE_CELL_HEIGHT;
            }
            return [self heightOfTextViewWithString:self.profileObject.descriptionString withFont:[UIFont normal] andFixedWidth:self.view.frame.size.width]+defaultHeight;
        }
    }
    return DEFAULT_TABLE_CELL_HEIGHT;
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
            [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.profileObject.imageURLString]
                                     placeholderImage:[UIImage defaultPicImage]];
            
        }
        if (selectedImage) {
            cell.profileImageView.image= selectedImage;
        }
        cell.nameLabel.text = [Utility_Shared_Instance checkForNullString:self.profileObject.nameString];
        cell.nameLabel.textColor = [UIColor navigationBarColor];
        cell.nameLabel.font = [UIFont normal];
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
                if ([addressCell viewWithTag:789]) {
                    [[addressCell viewWithTag:789] removeFromSuperview];
                }
                
                UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 5, 18, 21)];
                starLabel.text = @"*";
                starLabel.textColor = [UIColor redColor];
                starLabel.tag = 789;
                [addressCell.contentView addSubview:starLabel];
                
                
                UIImageView *imgViewEdit = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 10, 12, 12)];
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
                
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 23, self.view.frame.size.width-20, [self heightOfTextViewWithString:self.profileObject.addressString withFont:[UIFont smallBig] andFixedWidth:280])];
                
                textView.delegate = self;
                textView.tag = ADDRESS_TEXT_VIEW_TAG;
                textView.textColor = [UIColor buttonBackgroundColor];
                textView.font = [UIFont smallBig];
                textView.text = self.profileObject.addressString;
                [UITextView roundedCornerTextView:textView];
                [addressCell.contentView addSubview:textView];
                
                if (self.profileObject.isAddressEdit) {
                    imgViewEdit.image = [UIImage CheckOrTickImage];
                    textView.userInteractionEnabled = YES;
                    textView.backgroundColor = [UIColor whiteColor];
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
                
                UIImageView *imgViewEdit = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 10, 12, 12)];
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
                
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 23, self.view.frame.size.width-20, [self heightOfTextViewWithString:self.profileObject.descriptionString withFont:[UIFont normal] andFixedWidth:280])];
                textView.textColor = [UIColor buttonBackgroundColor];
                textView.font = [UIFont smallBig];
                textView.delegate = self;
                textView.tag = DESCRIPTION_TEXT_VIEW_TAG;
                textView.text = self.profileObject.descriptionString;
                [UITextView roundedCornerTextView:textView];
                [descriptionCell.contentView addSubview:textView];
                
                if (self.profileObject.isDescriptionEdit) {
                    imgViewEdit.image = [UIImage CheckOrTickImage];
                    textView.userInteractionEnabled = YES;
                    textView.backgroundColor = [UIColor whiteColor];
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
        cell.descriptionTextField.textColor = [UIColor buttonBackgroundColor];
        cell.languagesButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cell.languagesButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        CGSize size = [[self.namesArray objectAtIndex:indexPath.row] sizeWithAttributes:
                       @{NSFontAttributeName:[UIFont normal]}];
    
        //cell.mandatoryLabel.frame = CGRectMake(size.width, 3, 18, 20);
        
        //[UIButton roundedCornerButton:cell.languagesButton];
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
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"MY_LANGUAGES")]||[[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"COUNTRY")]||[[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"STATE")]) {
            cell.descriptionTextField.placeholder = @"";
        }
        else{
            cell.descriptionTextField.placeholder = [self.namesArray objectAtIndex:indexPath.row];
        }
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
            
            [cell.languagesButton setTitle:NSLOCALIZEDSTRING(@"MY_LANGUAGES") forState:UIControlStateNormal];
            if ([self.selectedLanguagesDict allValues].count) {
                //[cell.languagesButton setTitle:self.profileObject.myLanguagesString forState:UIControlStateNormal];
            }
            else{
            }
            [cell.languagesButton removeTarget:nil
                               action:NULL
                     forControlEvents:UIControlEventAllEvents];
            [cell.languagesButton addTarget:self action:@selector(languagesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            
            //**** LanguagesScrollView removing
            if([cell viewWithTag:741])
                [[cell viewWithTag:741] removeFromSuperview];
            
            int x = cell.languagesButton.frame.origin.x;
            int y = 8;
            int height = 35;
            int width = cell.languagesButton.frame.size.width - 80;
            //int rowHeightCount = 0;
            
            UIScrollView *languagesScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(x, DEFAULT_TABLE_CELL_HEIGHT, cell.languagesButton.frame.size.width, [self.selectedLanguagesDict allKeys].count*height + 15)]; //+15 to show the seelcted language with full height
            languagesScrollView.tag = 741;
            
            NSArray *array = [self.profileObject.myLanguagesString componentsSeparatedByString:@","];
            int tag = 0;
            for (id langName in array) {
                UIView *scrollInnerView = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
                
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 16, 16)];
                //imgView.backgroundColor = [UIColor blackColor];
                //imgView.image= [];
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+17, 6, scrollInnerView.frame.size.width-imgView.frame.size.width-50, 21)];
                nameLabel.textColor = [UIColor textColorWhiteColor];
                nameLabel.text = langName;
                nameLabel.font = [UIFont smallBig];
                //nameLabel.backgroundColor = [UIColor blueColor];
                
                UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width+35, 10, 16, 16)];
                [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_iPhone"] forState:UIControlStateNormal];
                closeBtn.tag = tag;
                tag++;
                //[closeBtn setBackgroundColor:[UIColor redColor]];
                
                [scrollInnerView addSubview:imgView];
                [scrollInnerView addSubview:nameLabel];
                [scrollInnerView addSubview:closeBtn];
                 [scrollInnerView setBackgroundColor:[UIColor buttonBackgroundColor]];
                [languagesScrollView addSubview:scrollInnerView];
                y = y +height +5;
                
            }
            float sizeOfContent = 0;
            UIView *lLast = [languagesScrollView.subviews lastObject];
            NSInteger wd = lLast.frame.origin.y;
            NSInteger ht = lLast.frame.size.height;
            sizeOfContent = wd+ht+[self.selectedLanguagesDict allKeys].count*5;;
            
            if (array.count>3) {
                NSInteger multiply= array.count -3;
                languagesScrollView.contentSize = CGSizeMake(languagesScrollView.frame.size.width, sizeOfContent+(multiply*30));
            }
            else{
                languagesScrollView.contentSize = CGSizeMake(languagesScrollView.frame.size.width, sizeOfContent);
            }
            
            
            //[languagesScrollView setContentSize:CGSizeMake(width, [self.selectedLanguagesDict allKeys].count*height)];
            
            [cell addSubview:languagesScrollView];
            /*
             if (self.profileObject.myLanguagesString.length) {
             [cell.languagesButton setTitle:self.profileObject.myLanguagesString forState:UIControlStateNormal];
             }
             */
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
            cell.descriptionTextField.secureTextEntry = YES;
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
        
        else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"TaxID_EIN")]) {
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
    
    return tempTV.frame.size.height;
}

-(void)editButtonPressed:(UIButton *)sender{
    
    [self.view endEditing:YES];
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
            //self.profileObject.addressString = txtView.text;
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
            //self.profileObject.descriptionString = txtView.text;
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
    if ([cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")] || [cell.headerLabel.text isEqualToString:NSLOCALIZEDSTRING(@"TaxID_EIN")])
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
//        
//        if ([self.einTaxArray containsObject:self.profileObject.countryString]){
//            self.profileObject.eINtaxIDString = [NSString stringWithFormat:@"TIN:%@",self.profileObject.eINtaxIDString];
//        }
//        else{
//            self.profileObject.eINtaxIDString = [NSString stringWithFormat:@"EIN:%@",self.profileObject.eINtaxIDString];
//        }
        
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
                
                if ([userDict objectForKey:KEIN_TAXID_W]) {
                    NSString *einTempSting = [userDict objectForKey:KEIN_TAXID_W];
                    NSArray *einArray = [einTempSting componentsSeparatedByString:@":"];
                    if (einArray.count>1) {
                        self.profileObject.eINtaxIDString = [einArray objectAtIndex:1];
                        [self changeTableLabelHeaders_Tax_EIN];
                    }
                }
                
                //////
                NSDictionary *profileImgDict =  [userDict objectForKey:KPROFILE_IMAGE_W];
                self.profileObject.imageURLString = [profileImgDict objectForKey:KURL_W];
                ///////////
                
                [self makeEditableMandatoryFields];
                
                self.profileObject.dobString = [self dateConvertion];
                self.profileObject.myLanguagesKEYsString = self.profileObject.myLanguagesString;
//                /////////// Languages
//                NSArray *langArray = [self.profileObject.myLanguagesString componentsSeparatedByString:@","];
//                if (langArray.count) {
//
//                    self.profileObject.myLanguagesString = @"";
//                    NSMutableString *mutableStr = [NSMutableString new];;
//                    MyLanguagesView *languages =[[MyLanguagesView alloc]init];
//                    NSMutableDictionary *languagesDit = [languages getLanguagesDictionary];
//                    for (id key in langArray) {
//                        NSString *str = [NSString stringWithFormat:@"%@,",[languagesDit objectForKey:key]];
//                        [mutableStr appendString:str];
//                        [self.selectedLanguagesDict setObject:[languagesDit objectForKey:key] forKey:key];
//                    }
//                    self.profileObject.myLanguagesString = [NSString stringWithString:mutableStr];
//                    if ([self.profileObject.myLanguagesString hasSuffix:@","]) {
//                        self.profileObject.myLanguagesString = [self.profileObject.myLanguagesString substringToIndex:[self.profileObject.myLanguagesString length] - 1];
//                    }
//                }
//                /////////////////
                
                [self getLanguagesNames:self.profileObject.myLanguagesString];
                
                ///////////////// Get States With Country Name
                if (self.profileObject.countryString.length) {
                    if (self.countryArray.count) {
                        //Get Country Key
                        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"countryName beginswith[c] %@",self.profileObject.countryString];
                        NSArray *sortedArray = [self.countryArray filteredArrayUsingPredicate:predicate];
                        if (sortedArray.count) {
                            CountryObject *cObj = [sortedArray lastObject];
                            self.profileObject.countryCodeString = cObj.countryCode;
                            [self getStateList];
                        }
                    }
                }
                /////////////////
                
                [self changeTableLabelHeaders_Tax_EIN];
                
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
        
        if (!_isInterpreter) {
            if (!self.profileObject.cardNumberString.length) {
                self.profileObject.isCardNumberEdit = YES;
            }
            if (!self.profileObject.CVVString.length) {
                self.profileObject.isCVVEdit = YES;
            }
        }
    }
    [self.tblView reloadData];
}

-(void)languagesButtonPressed{
    [self.view endEditing:YES];
    [self removeTapGesture];
    [self removePopUpView];
    languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.tag = 1000;
    languagesView.delegate = self;
    languagesView.selectedLanguagesDict  = [NSMutableDictionary new];
    
    if (!_isInterpreter)
        languagesView.isCustomer = YES;
    
    
    if (self.selectedLanguagesDict.allValues.count) {
        languagesView.selectedLanguagesDict = self.selectedLanguagesDict;
    }
    [languagesView.tblView reloadData];
    [self.view addSubview:languagesView];
}

-(void)countryButtonPressed{
    [self.view endEditing:YES];
    [self removeTapGesture];
    [self removePopUpView];
    
    if ([self.view viewWithTag:1000]) {
        [[self.view viewWithTag:1000] removeFromSuperview];
    }
    if ([self.view viewWithTag:3000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    if ([self.view viewWithTag:2000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
    languagesView.tag = 2000;

    languagesView.delegate = self;
    languagesView.isCountry = YES;
    
    languagesView.selectedCountriesStatesArray  = [NSMutableArray new];
    if (self.countryArray.count) {
        languagesView.countriesStatesArray = self.countryArray;
    }
    //languagesView.countriesStatesArray = [[NSMutableArray alloc]initWithObjects:@"Afghanistan",@"Albania",@"Algeria",@"India",@"United Kingdom",@"USA", nil];
    [languagesView.tblView reloadData];
    [self.view addSubview:languagesView];
}

-(void)stateButtonPressed{
    [self.view endEditing:YES];
    [self removeTapGesture];
    [self removePopUpView];
    
    if(self.profileObject.countryString){
        languagesView =[[MyLanguagesView alloc]initWithFrame:CGRectZero];
        languagesView.delegate = self;
        languagesView.tag = 3000;
        
        languagesView.isState = YES;
        languagesView.selectedCountriesStatesArray  = [NSMutableArray new];
        if (self.stateArray.count) {
            languagesView.countriesStatesArray = self.stateArray;
        }
        //languagesView.countriesStatesArray = [[NSMutableArray alloc]initWithObjects:@"Maryland",@"Oklahoma",@"Oregon",@"Nevada", nil];
        [languagesView.tblView reloadData];
        [self.view addSubview:languagesView];
    }
    else{
        [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                            withMessage:NSLOCALIZEDSTRING(@"PLEASE_SELECT_COUNTRY")
                                                 inView:self
                                              withStyle:UIAlertControllerStyleAlert];

    }
}


-(void)finishLanguagesSelection:(NSMutableDictionary *)selectedLanguagesDict{
    [self removePopUpView];
    NSLog(@"selectedlanguages -->%@",[selectedLanguagesDict description]);
    self.selectedLanguagesDict = selectedLanguagesDict;
    self.profileObject.myLanguagesString = [[self.selectedLanguagesDict allValues] componentsJoinedByString:@","];
    self.profileObject.myLanguagesKEYsString = [[self.selectedLanguagesDict allKeys] componentsJoinedByString:@","];
    [self.tblView reloadData];
    [self addTapGesture];
}

-(void)finishCountrySelection:(NSMutableArray *)selectedDataArray{
    [self removePopUpView];
    NSLog(@"selectedDataArray -->%@",[selectedDataArray description]);
    if (selectedDataArray.count) {
        CountryObject *cObj = [selectedDataArray lastObject];
        self.profileObject.countryString = cObj.countryName;
        self.profileObject.countryCodeString  = cObj.countryCode;
        [self getStateList];
    }
    [self changeTableLabelHeaders_Tax_EIN];
    
    [self.tblView reloadData];
    [self addTapGesture];
}

-(void)finishStateSelection:(NSMutableArray *)selectedDataArray{
    [self removePopUpView];
    NSLog(@"selectedDataArray -->%@",[selectedDataArray description]);
    if (selectedDataArray.count) {
        StateObject *sObj = [selectedDataArray lastObject];
        self.profileObject.stateString = sObj.stateName;
    }
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
        else if (!self.profileObject.addressString.length && _isInterpreter) {
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
        else if (!self.profileObject.eINtaxIDString.length && _isInterpreter) {
            if ([self.einTaxArray containsObject:self.profileObject.countryString])
                alertString = NSLOCALIZEDSTRING(@"EIN_TaxID");
            else
                alertString = NSLOCALIZEDSTRING(@"TaxID_EIN");
            
            
        }
        else if (!self.profileObject.myLanguagesString.length) {
            alertString = NSLOCALIZEDSTRING(@"MY_LANGUAGES");
        }
        else if (!self.profileObject.countryString.length) {
            alertString = NSLOCALIZEDSTRING(@"COUNTRY");
        }
        else if (!self.profileObject.stateString.length) {
            alertString = NSLOCALIZEDSTRING(@"STATE");
        }
        else if (!self.profileObject.dobString.length && !_isInterpreter) {
            alertString = NSLOCALIZEDSTRING(@"DOB");
        }
        else if (!self.profileObject.genderString.length && !_isInterpreter) {
            alertString = NSLOCALIZEDSTRING(@"GENDER");
        }
        else if (!self.profileObject.addressString.length) {
            alertString = NSLOCALIZEDSTRING(@"ADDRESS");
        }
        else if (!self.profileObject.cardNumberString.length && !_isInterpreter) {
            alertString = NSLOCALIZEDSTRING(@"CARD_NUMBER");
        }
        else if (!self.profileObject.cardTypeString.length && !_isInterpreter) {
            alertString = NSLOCALIZEDSTRING(@"CARD_TYPE");
        }
        else if (!self.profileObject.cardNumberString.length && !_isInterpreter) {
            alertString = NSLOCALIZEDSTRING(@"CARD_NUMBER");
        }
        else if (!self.profileObject.expMonthString.length && !_isInterpreter) {
            alertString = NSLOCALIZEDSTRING(@"EXPIRY_MONTH");
        }
        else if (!self.profileObject.expYearString.length && !_isInterpreter) {
            alertString = NSLOCALIZEDSTRING(@"EXPIRY_YEAR");
        }
        else if (!self.profileObject.CVVString.length && !_isInterpreter) {
            alertString = NSLOCALIZEDSTRING(@"CVV");
        }
        
        if (alertString.length>1) {
            [SVProgressHUD dismiss];
            [self makeEditableMandatoryFields];
            
            NSString *messageStr;
            if (([alertString isEqualToString:NSLOCALIZEDSTRING(@"GENDER")])||([alertString isEqualToString:NSLOCALIZEDSTRING(@"DOB")])||([alertString isEqualToString:NSLOCALIZEDSTRING(@"MY_LANGUAGES")])||([alertString isEqualToString:NSLOCALIZEDSTRING(@"COUNTRY")])||([alertString isEqualToString:NSLOCALIZEDSTRING(@"STATE")])||([alertString isEqualToString:NSLOCALIZEDSTRING(@"CARD_TYPE")])||([alertString isEqualToString:NSLOCALIZEDSTRING(@"EXPIRY_MONTH")])||([alertString isEqualToString:NSLOCALIZEDSTRING(@"EXPIRY_YEAR")])) {
                messageStr = [NSString messageWithSelectString:alertString];
            }
            else{
                messageStr = [NSString messageWithString:alertString];
            }
            
            [Utility_Shared_Instance showAlertViewWithTitle:NSLOCALIZEDSTRING(APPLICATION_NAME)
                                                withMessage:messageStr
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
        if ([self.einTaxArray containsObject:self.profileObject.countryString]){
            [saveDict setValue:[NSString stringWithFormat:@"TIN:%@",self.profileObject.eINtaxIDString] forKey:KEIN_TAXID_W];
        }
        else{
            [saveDict setValue:[NSString stringWithFormat:@"EIN:%@",self.profileObject.eINtaxIDString] forKey:KEIN_TAXID_W];
        }
        
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
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
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
    [self dismissViewControllerAnimated:picker completion:nil];
    [self.tblView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
    
    [Utility_Shared_Instance showProgress];
    NSMutableDictionary *imageDict=[NSMutableDictionary new];
    [imageDict setValue:[Utility_Shared_Instance readStringUserPreference:KID_W] forKey:KID_W];
    [imageDict setValue:[Utility_Shared_Instance checkForNullString:self.profileObject.emailString] forKey:KEMAIL_W];
    [imageDict setValue:[NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",self.profileObject.base64EncodedImageString] forKey:KFILE_W];
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
}
#pragma mark TextField Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    textField.keyboardType  = UIKeyboardTypeDefault;
    if (([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"POSTAL_CODE")])||([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")])||([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CARD_NUMBER")])||([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"EIN_TaxID")])||([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CVV")])){
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"POSTAL_CODE")]){
        return (([string isEqualToString:filtered])&&(newLength <= POSTAL_CODE_LIMIT));
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]){
        return (([string isEqualToString:filtered])&&(newLength <= PHONE_NUMBER_LIMIT));
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CARD_NUMBER")]){
        return (([string isEqualToString:filtered])&&(newLength <= CARD_NUMBER_LIMIT));
    }
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CVV")]){
        return (([string isEqualToString:filtered])&&(newLength <= CVV_LIMIT));
    }
    return YES;
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
    else if ([textField.placeholder isEqualToString:NSLOCALIZEDSTRING(@"CVV")]){
        self.profileObject.CVVString = textField.text;
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
        NSIndexPath *indexpath;
        if (_isInterpreter) {
            indexpath = [NSIndexPath indexPathForRow:6 inSection:0];
        }
        else{
            indexpath = [NSIndexPath indexPathForRow:10 inSection:0];
        }
        [self.tblView beginUpdates];
        [self.tblView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tblView endUpdates];
    }
    else if(textView.tag == DESCRIPTION_TEXT_VIEW_TAG){
        self.profileObject.descriptionString = textView.text;
        NSIndexPath *indexpath;
        indexpath = [NSIndexPath indexPathForRow:5 inSection:0];
        [self.tblView beginUpdates];
        [self.tblView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tblView endUpdates];
    }
    [self.view endEditing:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
       [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)getCountryList{
    [Utility_Shared_Instance showProgress];
    NSMutableDictionary *statusDict=[NSMutableDictionary new];
    
    [Web_Service_Call serviceCallWithRequestType:statusDict requestType:GET_REQUEST includeHeader:YES includeBody:NO webServicename:GET_COUNTRY_LIST_W SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            //CountryStore *store = [[CountryStore alloc]initWithJsonDictionary:responseDict];
           // NSMutableArray *array = [[StoreManager sharedManager] getCountryObject];
            
            NSMutableArray *countryTemp = [NSMutableArray new];
            NSArray *dataArray = [responseDict objectForKey:@"data"];
            for (id jsonObject in dataArray) {
                CountryObject *cObj = [CountryObject new];
                cObj.countryCode = [jsonObject objectForKey:KCOUNTRY_CODE_W];
                cObj.countryName = [jsonObject objectForKey:KCOUNTRY_NAME_W];
                cObj.createdAt = [jsonObject objectForKey:KCREATED_AT_W];
                [countryTemp addObject:cObj];
            }
            [self.countryArray removeAllObjects];
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES];
            self.countryArray=[[countryTemp sortedArrayUsingDescriptors:@[sort]] mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
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

-(void)getStateList{
    [Utility_Shared_Instance showProgress];
    NSMutableDictionary *statusDict=[NSMutableDictionary new];
    NSString *webServiceNameWithStateCode  = [NSString stringWithFormat:@"%@%@",GET_STATE_LIST_W,self.profileObject.countryCodeString];
    [Web_Service_Call serviceCallWithRequestType:statusDict requestType:GET_REQUEST includeHeader:YES includeBody:NO webServicename:webServiceNameWithStateCode SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSDictionary *responseDict=responseObject;
        if ([[responseDict objectForKey:KCODE_W] intValue] == KSUCCESS)
        {
            //CountryStore *store = [[CountryStore alloc]initWithJsonDictionary:responseDict];
            // NSMutableArray *array = [[StoreManager sharedManager] getCountryObject];
            
            self.stateArray = [NSMutableArray new];
            NSArray *dataArray = [responseDict objectForKey:@"data"];
            for (id jsonObject in dataArray) {
                StateObject *sObj = [StateObject new];
                sObj.countryId = [jsonObject objectForKey:KCOUNTRY_ID_W];
                sObj.stateName = [jsonObject objectForKey:KSTATE_NAME_W];
                sObj.createdAt = [jsonObject objectForKey:KCREATED_AT_W];
                [self.stateArray addObject:sObj];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"dict-->%@",responseDict);
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

-(void)removePopUpView{
    [languagesView removeFromSuperview];
    if ([self.view viewWithTag:1000]) {
        [[self.view viewWithTag:1000] removeFromSuperview];
    }
    if ([self.view viewWithTag:3000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    if ([self.view viewWithTag:2000]) {
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
}

-(void)changeTableLabelHeaders_Tax_EIN{
    if (_isInterpreter){
        if ([self.einTaxArray containsObject:self.profileObject.countryString]) {
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
                               NSLOCALIZEDSTRING(@"TaxID_EIN"),
                               NSLOCALIZEDSTRING(@"MY_LANGUAGES"),
                               NSLOCALIZEDSTRING(@"CERTIFICATES"), nil];
        }
        else{
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
    }
}


#pragma mark AlertView Custom PopUp CLicked

-(void)popUpButtonClicked:(UIButton *)sender{
    if (sender.tag == 2) {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:999] removeFromSuperview];
    }
}


-(void)getLanguagesNames:(NSString *)keysString{
    /////////// Languages
    NSArray *langArray = [keysString componentsSeparatedByString:@","];
    if (langArray.count) {
        
        NSMutableString *mutableStr = [NSMutableString new];;
        MyLanguagesView *languages =[[MyLanguagesView alloc]init];
        NSMutableDictionary *languagesDit = [languages getLanguagesDictionary];
        for (id key in langArray) {
            NSString *str = [NSString stringWithFormat:@"%@,",[languagesDit objectForKey:key]];
            [mutableStr appendString:str];
            //[self.selectedLanguagesDict setObject:[languagesDit objectForKey:key] forKey:key];
        }
        self.profileObject.myLanguagesString = [NSString stringWithString:mutableStr];
        if ([self.profileObject.myLanguagesString hasSuffix:@","]) {
            self.profileObject.myLanguagesString = [self.profileObject.myLanguagesString substringToIndex:[self.profileObject.myLanguagesString length] - 1];
        }
    }
    /////////////////
}
@end
