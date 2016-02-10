//
//  FavouriteInterpreterViewController.h
//  toGO
//
//  Created by Babul Rao on 10/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@interface FavouriteCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *displayImageView;
@property(nonatomic,weak) IBOutlet UILabel *titleLabel;
@property(nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,weak) IBOutlet UIButton *favouriteButton;
@end
@interface FavouriteInterpreterViewController : BaseViewController

@end
