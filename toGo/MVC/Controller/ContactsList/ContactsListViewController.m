//
//  ContactsListViewController.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "ContactsListViewController.h"

@interface ContactsListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) IBOutlet UITableView *tblView;
- (IBAction)testID:(id)sender;
- (IBAction)test:(UIButton *)sender;
@property(nonatomic,strong) NSMutableArray *contactsArray;
@end

@implementation ContactsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contactsArray = [NSMutableArray new];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier =  @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"test";
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

- (IBAction)testID:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"--%ld",(long)btn.tag);
}

- (IBAction)test:(UIButton *)sender {
    
    NSLog(@"--%ld",sender.tag);
}
@end
