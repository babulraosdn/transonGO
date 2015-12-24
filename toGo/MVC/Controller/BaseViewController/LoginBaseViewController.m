//
//  LoginBaseViewController.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "LoginBaseViewController.h"

@implementation LoginBaseViewController

-(void)setBackButtonForNavigation{
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(IBAction)webServiceCall:(id)sender{
    
}
@end
