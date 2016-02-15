//
//  RevenueViewController.h
//  toGO
//
//  Created by Babul Rao on 11/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@interface RevenueCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *fromLabel;
@property(nonatomic,weak) IBOutlet UILabel *toLabel;
@property(nonatomic,weak) IBOutlet UILabel *durationLabel;
@property(nonatomic,weak) IBOutlet UILabel *amountLabel;
@end
@interface RevenueViewController : BaseViewController

@end
