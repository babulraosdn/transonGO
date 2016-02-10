//
//  FavouriteInterpreterViewController.m
//  toGO
//
//  Created by Babul Rao on 10/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "FavouriteInterpreterViewController.h"

@interface FavouriteInterpreterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property(nonatomic,strong) NSMutableArray *favouriteListArray;
@property(nonatomic,weak) IBOutlet UITableView *tblView;
@end

@implementation FavouriteCell
@end


@implementation FavouriteInterpreterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    
    self.tblView.backgroundColor = [UIColor backgroundColor];//This is table view back goring color
    self.favouriteListArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    [self setFonts];
    
    
}

-(void)setFonts{
    self.headerLabel.text = NSLOCALIZEDSTRING(@"FAVOURITES");
    self.headerLabel.font = [UIFont normalSize];
}

#pragma Mark TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favouriteListArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteCell"];
    cell.titleLabel.font = [UIFont normalSize];
    cell.descriptionLabel.font = [UIFont smallBig];
    cell.titleLabel.textColor = [UIColor textColorBlackColor];
    cell.descriptionLabel.textColor = [UIColor grayColor];
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

