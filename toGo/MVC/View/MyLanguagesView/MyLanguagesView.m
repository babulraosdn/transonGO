//
//  MyLanguagesView.m
//  toGo
//
//  Created by Babul Rao on 06/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "MyLanguagesView.h"
#import "Headers.h"
@implementation MyLanguagesView


-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self) {
        self = [super initWithFrame:frame];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
        
        self.backgroundColor = [UIColor redColor];
        
        [self configureUI];
        
    }
    return self;
}

-(void)configureUI {
    
    [self addTableView];
    
}

-(void)addTableView {
    
    int alertViewHeight = self.frame.size.height-30;
    int alertViewWidth = self.frame.size.width-30;
    
    UIView *mainView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    mainView.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:0.8];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.center.x-(alertViewWidth/2), 30, alertViewWidth, alertViewHeight-30)];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor redColor];
    [self addSubview:tableView];
    
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50, 10 , 40, 40)];
    closeBtn.backgroundColor = [UIColor blackColor];
    [closeBtn addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    mainView.tag = 999;
    [self addSubview:closeBtn];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    cell.textLabel.text = @"TEST";
    return cell;
}



-(void)closeButtonPressed{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
