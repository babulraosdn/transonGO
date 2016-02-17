//
//  RevenueViewController.m
//  toGO
//
//  Created by Babul Rao on 11/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "RevenueViewController.h"

@interface RevenueViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) IBOutlet UITableView *tblView;
@property(nonatomic,weak) IBOutlet UIButton *ytdButton;
@property(nonatomic,weak) IBOutlet UIButton *weekButton;
@property(nonatomic,weak) IBOutlet UIButton *monthButton;
@property(nonatomic,weak) IBOutlet UILabel *pickAdateLabel;
@property(nonatomic,weak) IBOutlet UILabel *startDateHeaderLabel;
@property(nonatomic,weak) IBOutlet UILabel *endDateHeaderLabel;
@property(nonatomic,weak) IBOutlet UILabel *startDateDAYLabel;
@property(nonatomic,weak) IBOutlet UILabel *endDateDAYLabel;
@property(nonatomic,weak) IBOutlet UILabel *startDateDateLabel;
@property(nonatomic,weak) IBOutlet UILabel *endDateDateLabel;
@property(nonatomic,weak) IBOutlet UILabel *totalLabel;
@property(nonatomic,weak) IBOutlet UILabel *startDateBorderLabel;
@property(nonatomic,weak) IBOutlet UILabel *endDateBorderLabel;

@property(nonatomic,weak) IBOutlet UILabel *ytdBorderLabel;
@property(nonatomic,weak) IBOutlet UILabel *monthBorderLabel;
@property(nonatomic,weak) IBOutlet UILabel *weekBorderLabel;
@end

@implementation RevenueCell
@end

@implementation RevenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSlideMenuButtonFornavigation];
    [self setLogoutButtonForNavigation];
    
    [self setLabelButtonNames];
    [self setColors];
    [self setFonts];
    
    self.startDateBorderLabel.backgroundColor = [UIColor buttonBackgroundColor];
    self.ytdBorderLabel.backgroundColor = [UIColor whiteColor];
}

-(void)setLabelButtonNames{
    [self.ytdButton setTitle:NSLOCALIZEDSTRING(@"YTD") forState:UIControlStateNormal];
    [self.monthButton setTitle:NSLOCALIZEDSTRING(@"MONTH") forState:UIControlStateNormal];
    [self.weekButton setTitle:NSLOCALIZEDSTRING(@"WEEK") forState:UIControlStateNormal];
    self.startDateHeaderLabel.text = NSLOCALIZEDSTRING(@"START_DATE");
    self.endDateHeaderLabel.text = NSLOCALIZEDSTRING(@"END_DATE");
    self.totalLabel.text = NSLOCALIZEDSTRING(@"TOTAL");
}

-(void)setColors{
    
    self.startDateDateLabel.textColor = [UIColor navigationBarColor];
    self.startDateDAYLabel.textColor = [UIColor navigationBarColor];
    
    self.endDateDateLabel.textColor = [UIColor navigationBarColor];
    self.endDateDAYLabel.textColor = [UIColor navigationBarColor];
    
    [self.totalLabel setBackgroundColor:[UIColor buttonBackgroundColor]];
}

-(void)setFonts{
    
    self.ytdButton.titleLabel.font = [UIFont normalSize];
    self.monthButton.titleLabel.font = [UIFont normalSize];
    self.weekButton.titleLabel.font = [UIFont normalSize];
    
    self.pickAdateLabel.font = [UIFont normalSize];
    
    self.startDateHeaderLabel.font = [UIFont normal];
    self.endDateHeaderLabel.font = [UIFont normal];
    
    self.startDateDateLabel.font = [UIFont normal];
    self.startDateDAYLabel.font = [UIFont normal];
    
    self.endDateDateLabel.font = [UIFont normal];
    self.endDateDAYLabel.font = [UIFont normal];
    
    self.totalLabel.font = [UIFont normal];
}


#pragma Mark TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevenueCell"];
    cell.fromLabel.font = [UIFont small];
    cell.toLabel.font = [UIFont small];
    cell.amountLabel.font = [UIFont small];
    cell.durationLabel.font = [UIFont small];
    if (indexPath.row==0) {
        cell.fromLabel.backgroundColor = [UIColor RevenueLabelBackgroundColor];
        cell.toLabel.backgroundColor = [UIColor RevenueLabelBackgroundColor];
        cell.durationLabel.backgroundColor = [UIColor RevenueLabelBackgroundColor];
        cell.amountLabel.backgroundColor = [UIColor RevenueLabelBackgroundColor];
        
        cell.fromLabel.text = NSLOCALIZEDSTRING(@"INTERPRETATION_FROM");
        cell.toLabel.text = NSLOCALIZEDSTRING(@"INTERPRETATION_TO");
        cell.amountLabel.text = NSLOCALIZEDSTRING(@"AMOUNT");
        cell.durationLabel.text = NSLOCALIZEDSTRING(@"DURATION");
        
        cell.fromLabel.textColor = [UIColor whiteColor];
        cell.toLabel.textColor = [UIColor whiteColor];
        cell.durationLabel.textColor = [UIColor whiteColor];
        cell.amountLabel.textColor = [UIColor whiteColor];
   }
    else {
        cell.fromLabel.backgroundColor = [UIColor clearColor];
        cell.toLabel.backgroundColor = [UIColor clearColor];
        cell.durationLabel.backgroundColor = [UIColor clearColor];
        cell.amountLabel.backgroundColor = [UIColor clearColor];
        
        cell.fromLabel.text = @"English";
        cell.toLabel.text = @"France";
        cell.durationLabel.text = @"20 min";
        cell.amountLabel.text = @"$2000";
        
        cell.fromLabel.textColor = [UIColor lightGrayColor];
        cell.toLabel.textColor = [UIColor lightGrayColor];
        cell.durationLabel.textColor = [UIColor lightGrayColor];
        cell.amountLabel.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

-(IBAction)startDateEndDateButtonPressed:(id)sender{
    if([sender tag]==1){
        [UIView animateWithDuration:0.5 animations:^{
            self.startDateBorderLabel.backgroundColor = [UIColor buttonBackgroundColor];
            self.endDateBorderLabel.backgroundColor = [UIColor clearColor];
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.startDateBorderLabel.backgroundColor = [UIColor clearColor];
            self.endDateBorderLabel.backgroundColor = [UIColor buttonBackgroundColor];
        }];
    }
}

-(IBAction)ytdWeekMonthButtonPressed:(id)sender{
    
    if([sender tag]==1){
        [UIView animateWithDuration:0.5 animations:^{
            self.ytdBorderLabel.backgroundColor = [UIColor whiteColor];
            self.weekBorderLabel.backgroundColor = [UIColor clearColor];
            self.monthBorderLabel.backgroundColor = [UIColor clearColor];
        }];
    }
    else if([sender tag]==2){
        [UIView animateWithDuration:0.5 animations:^{
            self.ytdBorderLabel.backgroundColor = [UIColor clearColor];
            self.weekBorderLabel.backgroundColor = [UIColor whiteColor];
            self.monthBorderLabel.backgroundColor = [UIColor clearColor];
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.ytdBorderLabel.backgroundColor = [UIColor clearColor];
            self.weekBorderLabel.backgroundColor = [UIColor clearColor];
            self.monthBorderLabel.backgroundColor = [UIColor whiteColor];
        }];
    }
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
