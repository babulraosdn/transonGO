//
//  FeedBackListViewController.m
//  toGo
//
//  Created by Babul Rao on 05/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "FeedBackListViewController.h"

@implementation FeedBackListCell
@end

@interface FeedBackListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property(nonatomic,strong) NSMutableArray *feedBackListArray;
@property(nonatomic,weak) IBOutlet UITableView *tblView;
@end

@implementation FeedBackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomBackButtonForNavigation];
    self.tblView.backgroundColor = [UIColor backgroundColor];//This is table view back goring color
    self.feedBackListArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
}

#pragma Mark TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.feedBackListArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedBackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedBackListCell"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
