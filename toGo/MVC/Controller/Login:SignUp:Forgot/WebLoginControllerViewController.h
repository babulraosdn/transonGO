//
//  WebLoginControllerViewController.h
//  toGo
//
//  Created by Anil Upadhyay on 16/12/15.
//  Copyright (c) 2015 toGo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebLoginControllerViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)actionForTopBar:(id)sender;
-(void)loadURL:(NSURL *)loadURL;
@end
