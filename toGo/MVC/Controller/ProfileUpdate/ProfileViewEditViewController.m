//
//  ProfileViewEditViewController.m
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "ProfileViewEditViewController.h"
#import "ProfileViewEditUpdateCell.h"
#import "ProfileImageTableViewCell.h"
#import "Headers.h"

#define HEADER_HEIGHT 140

@interface ProfileViewEditViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *namesArray;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@end

@implementation ProfileViewEditViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tblView.backgroundColor = [UIColor backgroundColor];
    self.namesArray = [[NSMutableArray alloc]initWithObjects:@"",
                       NSLOCALIZEDSTRING(@"EMAIL"),
                       NSLOCALIZEDSTRING(@"PASSWORD"),
                       NSLOCALIZEDSTRING(@"NAME"),
                       NSLOCALIZEDSTRING(@"ADDRESS"),
                       NSLOCALIZEDSTRING(@"PHONE_NUMBER"),
                       NSLOCALIZEDSTRING(@"DESCRIPTION"),
                       NSLOCALIZEDSTRING(@"BANK_ACCOUNT_INFORMATION"),
                       NSLOCALIZEDSTRING(@"MY_LANGUAGES"),NSLOCALIZEDSTRING(@"CERTIFICATES"), nil];
    self.dataArray = [[NSMutableArray alloc]initWithObjects:@"",@"kat@gmail.com",@"**********",@"KatC",@"CA, Washington, USA",@"07515398752",@"dsasd",@"It's Confidential",@"Spanish, German",@"German certified", nil];
    [self setSlideMenuButtonFornavigation];
    
    /*
    self.tblView.estimatedRowHeight = 80;
    self.tblView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tblView setNeedsLayout];
    [self.tblView layoutIfNeeded];
    */

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    if (indexPath.row==0) {
        return HEADER_HEIGHT;
    }
    else if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Address"] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:@"Description"]) {
        return 157;
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
        
        static NSString *cellIdentifier = @"ProfileViewEditUpdateCell";
        ProfileViewEditUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [cellArray objectAtIndex:0];
        }
        
        cell.descriptionTextView.hidden = YES;
        cell.editImageView.hidden = YES;
        cell.editButton.hidden = YES;
        
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"DESCRIPTION")]) {
            cell.descriptionTextField.hidden = YES;
            cell.descriptionTextView.hidden = NO;
        }
        
        if ([[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"ADDRESS")] || [[self.namesArray objectAtIndex:indexPath.row] isEqualToString:NSLOCALIZEDSTRING(@"PHONE_NUMBER")]) {
            cell.editImageView.hidden = NO;
            cell.editButton.hidden = NO;
        }
        
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
        
        ///////////// Text/Data Assigning
        cell.descriptionTextField.text = [self.dataArray objectAtIndex:indexPath.row];
        cell.descriptionTextView.text = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.headerLabel.text = [self.namesArray objectAtIndex:indexPath.row];
        /////////
        
        
        return cell;
    }
    return nil;
}
@end
