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
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [self configureUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)configureUI {
    
    [self addTableView];
    
}

-(void)addTableView
{
    
    int tableViewHeight = self.frame.size.height-30;
    int tableViewWidth = self.frame.size.width-30;
    
    UIView *mainView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    mainView.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:0.8];
    mainView.tag = 999;
    
    self.tblView = [[UITableView alloc]initWithFrame:CGRectMake(self.center.x-(tableViewWidth/2), 30, tableViewWidth, tableViewHeight-70)];//tableViewHeight-30
    
    int buttonWidth = tableViewWidth/2;
    int buttonHeight = 35;
    
    UIView *submitView = [[UIView alloc]initWithFrame:CGRectMake(self.center.x-(tableViewWidth/2), self.tblView.frame.origin.y+self.tblView.frame.size.height, tableViewWidth, 40)];
    [submitView setBackgroundColor:[UIColor backgroundColor]];
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,3, buttonWidth, buttonHeight)];
    submitBtn.backgroundColor = [UIColor buttonBackgroundColor];
    [submitBtn setTitle:NSLOCALIZEDSTRING(@"SAVE") forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tag = 1;
    [UIButton roundedCornerButton:submitBtn];
    [submitView addSubview:submitBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(submitBtn.frame.size.width+2, 3, buttonWidth, buttonHeight)];
    cancelBtn.tag = 2;
    [cancelBtn setBackgroundImage:[UIImage lightButtonImage] forState:UIControlStateNormal];
    [cancelBtn setTitle:NSLOCALIZEDSTRING(@"CANCEL") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [UIButton roundedCornerButton:cancelBtn];
    
    [submitView setBackgroundColor:[UIColor clearColor]];
    [submitView addSubview:cancelBtn];
    
    [self addSubview:submitView];
    
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    
    self.tblView.layer.cornerRadius = 6.0f;
    self.tblView.layer.masksToBounds = YES;
    [self addSubview:self.tblView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isCountry || self.isState) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"countryState"];
        if (self.isCountry){
            CountryObject *cObj = [self.dataArray objectAtIndex:indexPath.row];
            cell.textLabel.text = cObj.countryName;
        }
        else{
            StateObject *sObj = [self.dataArray objectAtIndex:indexPath.row];
            cell.textLabel.text = sObj.stateName;
        }
        
        if ([self.selectedDataArray containsObject:[self.dataArray objectAtIndex: indexPath.row]]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        return cell;
    }

    
    MyLanguagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyLanguagesCell"];
    if (cell==nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyLanguagesCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    LanguageObject *lObj = [self.dataArray objectAtIndex:indexPath.row];
    cell.countryNameLabel.text = lObj.languageName;
    [cell.countryImageView sd_setImageWithURL:[NSURL URLWithString:lObj.imagePathString]
                             placeholderImage:[UIImage defaultPicImage]];
    if ([self.selectedDataArray containsObject:[self.dataArray objectAtIndex: indexPath.row]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isCountry || self.isState) {
        [self.selectedDataArray removeAllObjects];
        [self.selectedDataArray addObject:[self.dataArray objectAtIndex: indexPath.row]];
    }
    else{
        
        if (self.isCustomer || self.isSelectInterpretationLanguage) {
            [self.selectedDataArray removeAllObjects];
        }
        
        if ([self.selectedDataArray containsObject:[self.dataArray objectAtIndex: indexPath.row]]) {
            [self.selectedDataArray removeObject:[self.dataArray objectAtIndex: indexPath.row]];
        }
        else{
             [self.selectedDataArray addObject:[self.dataArray objectAtIndex: indexPath.row]];
        }
    }
    [self.tblView reloadData];
}


-(void)closeButtonPressed:(UIButton *)sender{
    
    [self removeFromSuperview];
    if (sender.tag==1) {
        if (self.isCountry) {
            [self.delegate finishCountrySelection:self.selectedDataArray];
        }
        else if (self.isState) {
            [self.delegate finishStateSelection:self.selectedDataArray];
        }
        else{
            [self.delegate finishLanguagesSelection:self.selectedDataArray];
        }
    }
}

-(void)assignData{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
