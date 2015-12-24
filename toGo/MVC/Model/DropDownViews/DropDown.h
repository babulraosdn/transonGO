//
//  DropDown.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDown;
@protocol DropDownDelegate
- (void) dropDownDelegateMethod: (DropDown *) sender;
@end

@interface DropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
    CGPoint rectPt;
}
@property (nonatomic, retain) id <DropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
@property (nonatomic, retain) NSString *indexNum;
@property(nonatomic, strong) UITableView *table;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction;
@end
