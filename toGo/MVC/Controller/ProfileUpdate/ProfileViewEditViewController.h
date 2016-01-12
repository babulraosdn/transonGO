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
@property(nonatomic,weak) IBOutlet UILabel *headerLabel;
@property(nonatomic,weak) IBOutlet UITextField *descriptionTextField;
@property(nonatomic,weak) IBOutlet UITextView *descriptionTextView;
@property(nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,weak) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *languagesButton;
@property(nonatomic,weak) IBOutlet UIImageView *editImageView;
@end

@interface ProfileViewEditUpdateAnswerCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *headerLabel;
@property(nonatomic,weak) IBOutlet UILabel *answerLabel;
@property(nonatomic,weak) IBOutlet UITextView *answerTextView;
@end

@interface ProfileViewEditViewController : BaseViewController
@property(nonatomic,readwrite)BOOL isFromDashBoard;
@end
