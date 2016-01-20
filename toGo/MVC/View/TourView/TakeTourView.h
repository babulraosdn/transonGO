//
//  TakeTourView.h
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@interface TakeTourView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong)UIScrollView *scrollImages;

+ (void)launchTakeTourViewWithNewVersion:(BOOL)isNewVersion;

@end
