//
//  ProfileViewEditViewController.h
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@interface ProfileViewEditUpdateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImageView;
@property(nonatomic,weak) IBOutlet UILabel *headerLabel;
@property(nonatomic,weak) IBOutlet UITextField *descriptionTextField;
@property(nonatomic,weak) IBOutlet UITextView *descriptionTextView;
@property(nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,weak) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *languagesButton;
@property(nonatomic,weak) IBOutlet UIImageView *editImageView;
@property(nonatomic,weak) IBOutlet UILabel *mandatoryLabel;
@property(nonatomic,weak) IBOutlet UIScrollView *scrollViewLabel;
@end

@interface ProfileViewLanguageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImageView;
@property(nonatomic,weak) IBOutlet UILabel *headerLabel;
@property(nonatomic,weak) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *languagesButton;
@property(nonatomic,weak) IBOutlet UIImageView *editImageView;
@property(nonatomic,weak) IBOutlet UILabel *mandatoryLabel;
@property(nonatomic,weak) IBOutlet UIScrollView *scrollViewLabel;
@end


@interface ProfileViewEditViewController : BaseViewController<UtilityProtocol>
@property(nonatomic,readwrite)BOOL isFromDashBoard;
@property(nonatomic,assign)BOOL isInterpreter;
@end
