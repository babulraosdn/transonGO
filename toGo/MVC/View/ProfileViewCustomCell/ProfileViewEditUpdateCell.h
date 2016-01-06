//
//  ProfileViewEditUpdateCell.h
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewEditUpdateCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *headerLabel;
@property(nonatomic,weak) IBOutlet UITextField *descriptionTextField;
@property(nonatomic,weak) IBOutlet UITextView *descriptionTextView;
@property(nonatomic,weak) IBOutlet UIButton *editButton;
@property(nonatomic,weak) IBOutlet UIImageView *editImageView;
@end
