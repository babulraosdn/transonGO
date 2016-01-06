//
//  MyLanguagesView.m
//  toGo
//
//  Created by Babul Rao on 06/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "MyLanguagesView.h"

@implementation MyLanguagesView


-(UIView *)myLanguagesView:(NSMutableArray *)dataArray viewIs:(UIView *)currentView{
    
    
    int alertViewHeight = 300;
    int alertViewWidth = 270;
    
    UIView *mainView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    mainView.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:0.8];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(currentView.center.x-(alertViewWidth/2), currentView.center.y-(alertViewHeight/2), alertViewWidth, alertViewHeight)];
    
    
    
    [mainView addSubview:tableView];
    return mainView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
