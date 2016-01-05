//
//  FeedBackListViewController.h
//  toGo
//
//  Created by Babul Rao on 05/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@interface FeedBackListCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *displayImageView;
@property(nonatomic,weak) IBOutlet UILabel *titleLabel;
@property(nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,weak) IBOutlet UILabel *timeLabel;
@property(nonatomic,weak) IBOutlet UIButton *starButton1;
@property(nonatomic,weak) IBOutlet UIButton *starButton2;
@property(nonatomic,weak) IBOutlet UIButton *starButton3;
@property(nonatomic,weak) IBOutlet UIButton *starButton4;
@property(nonatomic,weak) IBOutlet UIButton *starButton5;
@end

@interface FeedBackListViewController : BaseViewController

@end
