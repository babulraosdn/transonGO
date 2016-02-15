//
//  CallHistoryViewController.h
//  toGO
//
//  Created by Babul Rao on 11/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@interface CallHistoryCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *displayImageView;
@property(nonatomic,weak) IBOutlet UILabel *titleLabel;
@property(nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,weak) IBOutlet UIButton *favouriteButton;
@property(nonatomic,weak) IBOutlet UIButton *heartButton;
@property(nonatomic,weak) IBOutlet UILabel *durationLabel;
@end

@interface CallHistoryViewController : BaseViewController

@end
