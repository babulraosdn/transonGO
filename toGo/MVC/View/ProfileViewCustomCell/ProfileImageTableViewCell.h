//
//  ProfileImageTableViewCell.h
//  toGo
//
//  Created by Babul Rao on 06/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic,weak) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic,weak) IBOutlet UIImageView *profileImageView;
@property(nonatomic,weak) IBOutlet UIButton *selectImageButton;
@end
