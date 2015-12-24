//
//  DropDown.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "DropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface DropDown ()

@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecogniser;
@end

@implementation DropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;
@synthesize indexNum;
@synthesize gestureRecogniser;

- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction {
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    [self.table setUserInteractionEnabled:YES];
    if (self) {
        
        rectPt = [b.superview convertPoint:b.frame.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(rectPt.x, rectPt.y, btn.size.width, 0);
            //self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(rectPt.x, rectPt.y+btn.size.height, btn.size.width, 0);
            //self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
//        self.layer.shadowRadius = 5;
//        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, -2, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
       // table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(rectPt.x, rectPt.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(rectPt.x, rectPt.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, -2, btn.size.width, *height);
        [UIView commitAnimations];
        //[b.superview addSubview:self];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(b.frame.size.width-7.5, rectPt.y+b.frame.size.height-4, 37, 10)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.tag = 18899;
        
        
        self.tag = 18999;
        
        [self addSubview:table];
        
        self.gestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopOverTable)];
        
        //DDAlertViewController* ddAlert = [[Global sharedInstance].ddAlertArray lastObject];
        //[ddAlert.view addGestureRecognizer:self.gestureRecogniser];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        [[[UIApplication sharedApplication] keyWindow] addSubview:whiteView];
        table.layer.borderWidth = 1.0;
        //table.layer.borderColor = [[Global sharedInstance] colorWithHexString:kDefaultCCode].CGColor;
    }
    return self;
}

-(void)dismissPopOverTable
{
    [self hideDropDown:btnSender];
    [self myDelegate];
}



-(void)hideDropDown:(UIButton *)b {
    
    //DDAlertViewController* ddAlert = [[Global sharedInstance].ddAlertArray lastObject];
    //[ddAlert.view removeGestureRecognizer:self.gestureRecogniser];
    
    CGRect btn = b.frame;
    
    //[b setButtonBorderColor:[[Global sharedInstance] colorWithHexString:kDefaultCCode]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(rectPt.x, rectPt.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(rectPt.x, rectPt.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, -2, btn.size.width, 0);
    [UIView commitAnimations];
    
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:18899] removeFromSuperview];
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:18999] removeFromSuperview];
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:1201] removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    //NSString *selectedExpenseType = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Title"]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel* cellSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,34,130,1)];
        //cellSeparatorLabel.backgroundColor = [[Global sharedInstance] colorWithHexString:kLightGreyCCode];
        [cell.contentView addSubview:cellSeparatorLabel];
    }
    if ([self.imageList count] == [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        cell.imageView.image = [imageList objectAtIndex:indexPath.row];
    } else if ([self.imageList count] > [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    } else if ([self.imageList count] < [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.font = [[Global sharedInstance] getMuliRegular:14.0];
    //if ([selectedExpenseType isEqualToString:[list objectAtIndex:indexPath.row]])
    {
        //cell.textLabel.textColor = [[Global sharedInstance] colorWithHexString:kLinkGreenCCode];
        UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"path-1-path copy"]];
        cell.accessoryView = checkmark;
    }
    

    
    return cell;
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
//    c.textLabel.textColor = [UIColor greenColor];
//    return indexPath;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    

    NSString *strtitle = c.textLabel.text;//[btnSender currentTitle];
    
    [[NSUserDefaults standardUserDefaults] setObject:strtitle forKey:@"Title"];
    
    for (UIView *subview in btnSender.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            //[subview removeFromSuperview];
        }
    }
    [self hideDropDown:btnSender];
    
    imgView.image = c.imageView.image;
    imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
    imgView.frame = CGRectMake(5, 5, 25, 25);
    [btnSender addSubview:imgView];
    
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate dropDownDelegateMethod:self];
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

@end
